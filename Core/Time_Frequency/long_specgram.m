function B = long_specgram(sound, t, dt, ch, opt, filt, block_size)

% long_specgram - compute long term spectrograms
% ----------------------------------------------
%
% B = long_specgram(sound, t, dt, ch, opt, filt, block_size)
%
% Input:
% ------
%  sound - sound
%  t - start time
%  dt - duration
%  ch - channels
%  opt - spectrogram options
%  active - active filters struct
%  block_size - samples to process per block
%
% Output:
% -------
%  B - spectrogram(s)

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%--------------------------------
% Author: Matt Robbins
%--------------------------------
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% set default block size
%--

% NOTE: the block size is the number of double frames

if (nargin < 7) || isempty(block_size)

	bytes = 2^22; block_size = floor((bytes / 8) / length(ch));
	
end

%--
% set default empty filter state
%--

if (nargin < 6)
	filt = [];
end

%--------------------------------
% SETUP
%--------------------------------

%--
% get some important values
%--

nch = length(ch); rate = get_sound_rate(sound);

block_duration = block_size / rate;

blocks = ceil(dt / block_duration);


% NOTE: this provides display page adaptation
		
page.start = t; page.duration = dt; page.channels = ch;

filt.signal_context.page = page;
		
%---------------------------
% COMPUTE VIEW
%---------------------------

%--
% create waitbar
%--

pal = long_wait(dt); 

origin = offset_date(sound.realtime, t);

%--
% get parent from slider to aid in interrupt
%--

par = get_palette_parent(pal);

if ~isempty(par)
	slider = get_time_slider(par);
end

%--
% initialize output cells
%--

B = cell(1, nch);

for block = 1:blocks	
	
	%-------------------------------------------
	% READ SOUND
	%-------------------------------------------

	%--
	% calculate duration
	%--
	
	start_time = t + ((block - 1) * block_duration);

	duration = min([ ...
		get_sound_duration(sound) - start_time, ...
		t + dt - start_time, ...
		dt, ...
		block_duration ...
	]);

	%--
	% calculate duration necessary to have correct number of spectrogram blocks
	%--
	
	duration = specgram_duration(opt, rate, duration);
	
	%--
	% read samples
	%--

	X = sound_read(sound, 'time', start_time, duration, ch);

	%-------------------------------------------
	% COMPUTE VIEW
	%-------------------------------------------

	% TODO: consider the fact that we may place view results in parent axes
	
	%--
	% filter signal
	%--

	if ~isempty(filt.signal_filter)		
		
		% NOTE: this provides display page page adaptation
		
		% NOTE: this adaptation is very much like that of detector scan
		
% 		page.start = start_time; page.duration = duration; page.channels = ch;
% 		
% 		filt.signal_context.page = page;
		
		X = apply_signal_filter(X, filt.signal_filter, filt.signal_context);
	
	end

	%--
	% compute view
	%--

	% TODO: eventually render view here as well?
	
	% TODO: consider multiple channel case up front
	
	C{block} = fast_specgram(X, rate, 'norm', opt);
	
	%--------------------------------------
	% UPDATE WAITBAR
	%--------------------------------------

	%--
	% check for interrupt from parent
	%--
	
	if ~isempty(par)
		
		current = get_time_slider(par);

		% NOTE: this is a special return from that display understands
		
		if ~isequal(slider.value, current.value)
			close(pal); B = []; return;
		end

	end
		
	%--
	% compute waitbar position
	%--

	value = block / blocks; 

	%--
	% compute waitbar message based on time horizon
	%--

	% TODO: make this message depend on the time grid display setting

	if (~isempty(origin))

		horizon = offset_date(origin, value * dt); 

		message = datestr(horizon);

	else		

		horizon = t + (value * dt);

		if (dt > 5)
			horizon = round(horizon);
		end

		message = sec_to_clock(horizon);

	end

	%--
	% update waitbar, or break out of computation loop
	%--

	% HACK: this is to decide if the waitbar has been closed

	try	
		
		waitbar_update(pal, 'PROGRESS', ...
			'message', message, ...
			'value', value ...
		);

	catch

		block = block - 1; break;	

	end

end 

%--
% check for early exit due to closed waitbar, and pad with zeros
%--

blocks_remaining = blocks - block;

if blocks_remaining
	
	blocks = block;
	
	if block > 0
		C{block} = zero_specgram(opt, rate, blocks_remaining * block_duration, nch);
	end
	
end

%--
% concatenate long view
%--

if (nch < 2)
	
	B = {[C{:}]};
	
else
	
	%--
	% create anonymous concatenate function
	%--
	
	% TODO: create a function that returns a function
	
	str = '@(C,k) [';
	
	for j = 1:blocks
		str = [str, 'C{', int2str(j), '}{k},'];
	end

	str(end) = []; str = [str, ']'];
	
	try
		cat_fun = eval(str);
	catch
		disp('WARNING: Problem concatenating long spectrogram.');
		delete(pal); return;
	end
	%--
	% concatenate channels
	%--
	
	for k = 1:nch
		B{k} = cat_fun(C,k);
	end
	
end

%--
% delete waitbar if needed
%--

if ~isempty(pal) && ishandle(pal)
	delete(pal);
end


%--------------------------------------------------
% LONG_WAIT
%--------------------------------------------------

function pal = long_wait(duration)

% long_wait - waitbar for long view display
% -----------------------------------------
%
% pal = long_wait(duration)
%
% Input:
% ------
%  duration - real duration
%
% Output:
% -------
%  pal - waitbar handle

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3084 $
% $Date: 2005-12-20 18:54:15 -0500 (Tue, 20 Dec 2005) $
%--------------------------------

% TODO: use the sound to inform a real time multiplier display

%--
% progress waitbar
%--

control = control_create( ...
	'name','PROGRESS', ...
	'alias','Chunked Computation', ...
	'style','waitbar', ...
	'units',duration, ...
	'confirm',1, ...
	'lines',1.1, ...
	'space',0.5 ...
);

%--
% ensure singleton waitbar
%--

name = ['Computing Spectrogram ...']; 

pal = find_waitbar(name);

if ~isempty(pal)
	delete(pal);
end

%--
% create waitbar
%--

par = get_active_browser;

if isempty(par)
	pal = waitbar_group(name, control); return;
end

%--
% create waitbar with parent
%--

opt = waitbar_group; opt.show_after = 1;

pal = waitbar_group(name, control, par, 'bottom right', opt);


%--------------------------------------------------
% SLIDER_INTERRUPT
%--------------------------------------------------

function value = slider_interrupt(pal)

% slider_interrupt - indicate parent slider interrupt for computation
% -------------------------------------------------------------------
%
% value = slider_interrupt(pal)
%
% Input:
% ------
%  pal - computation waitbar handle
%
% Output:
% -------
%  value - interrupt indicator

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3084 $
% $Date: 2005-12-20 18:54:15 -0500 (Tue, 20 Dec 2005) $
%--------------------------------

% NOTE: default to no interrupt

value = 0;

%--
% waitbar with parent is required for interrupt
%--

if isempty(pal)
	return;
end

par = get_palette_parent(pal);

if isempty(par)
	return;
end

%--
% interrupt happens if slider has changed since waitbar was created
%--

slider = get_time_slider(par); 

pal = get(pal, 'userdata'); % NOTE: create function to get palette state in usable form

elapsed = etime(slider.modified, pal.created);

if (elapsed > 0)
	value = 1;
end
