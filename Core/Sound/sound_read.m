function [X, r] = sound_read(sound, mode, x, dx, ch)

% sound_read - read samples from sound file
% -----------------------------------------
%
% [X, r] = sound_read(sound, mode, x, dx, ch)
%
% Input:
% ------
%  sound - sound structure or sound type, 'File', 'File Stream'
%  mode - reading mode, 'samples' or 'time' (sec)
%  x - starting index or time (def: 0)
%  dx - number of samples or time duration (sec) (def: remaining sound data)
%  ch - channels to read (def: all available channels)
%
% Output:
% -------
%  X - samples from selected channels
%  r - rate of samples

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
% Author: Harold Figueroa
%--------------------------------
% $Revision: 7019 $
% $Date: 2006-10-13 16:38:44 -0400 (Fri, 13 Oct 2006) $
%--------------------------------

%---------------------------------------------------------------------
% HANDLE INPUT
%---------------------------------------------------------------------

%--
% set empty missing arguments
%--

if nargin < 5
	ch = [];
end

if nargin < 4
	dx = [];
end

if nargin < 3
	x = [];
end

if nargin < 2
	mode = [];
end

%--
% consider special reading cases
%--

% NOTE: we should probably produce some warning when this happens, it should not

if dx <= 0
	X = []; r = get_sound_rate(sound); return;
end

% NOTE: a stack of sounds can contain session sounds, hence it comes first

% NOTE: only single channel sounds can be stacked

if strcmpi(sound.type, 'stack')
	
	error('Reading sounds of type ''stack'' is not yet implemented.');
	
% 	[X, r] = stack_sound_read(sound, mode, x, dx, ch); return;
end

% NOTE: a session sound can output zeros during non-session periods

% TODO: perhaps give this test a name

if has_sessions_enabled(sound) && ~sound.time_stamp.collapse
	
	[X, r] = session_sound_read(sound, mode, x, dx, ch); return;
end

%--
% handle missing arguments using helper
%--

% NOTE: actual default value for missing arguments are done here

[ix, n, ch] = get_sound_extent(sound, mode, x, dx, ch);

%--
% output read samples rate
%--

r = get_sound_rate(sound);

% r = sound.output.rate;

%---------------------------------------------------------------------
% COMPUTE INDEXES THAT ARE INSIDE SOUND
%---------------------------------------------------------------------

if ~strcmpi(sound.type, 'file stream')
	nsamples = sound.samples;
else
	nsamples = sound.cumulative(end);
end
		
%--
% fast return in the case of ix outside sound
%--

if (ix > nsamples)

	X = zeros(n, numel(ch)); return;

elseif (ix + n) > nsamples
	
	%--
	% call sound_read
	%--
	
	nread = nsamples - ix;
	
	[X, r] = sound_read(sound, 'samples', ix, nread, ch);
	
	%--
	% pad with zeros
	%--
	
	Xz = zeros(n - nread, numel(ch));
	
	X = [X; Xz];
	
	return;
	
end

%---------------------------------------------------------------------
% READ SAMPLES
%---------------------------------------------------------------------

switch lower(sound.type)
	
	%-------------------------------------------------
	% FILE
	%-------------------------------------------------

	case 'file'

		%--
		% read samples from sound file
		%--

		X = get_samples([sound.path, sound.file], ix, n, sound.samples, ch, sound);

	%-------------------------------------------------
	% FILE STREAM
	%-------------------------------------------------

	case 'file stream'
		
		%--
		% rename variables for convenience
		%--
		
		s = sound.samples; c = sound.cumulative;
		
		%--
		% compute initial and final files needed
		%--

		f1 = min(find(c > ix)); f2 = min(find(c >= ix + n));
		
		%-------------------------------------------------
		% SAMPLES IN ONE FILE
		%-------------------------------------------------

		if (f1 == f2)

			%--
			% compute starting index
			%--
			
			ix1 = ix - c(f1) + s(f1);

			%--
			% read samples
			%--
			
			
			X = get_samples([sound.path, sound.file{f1}], ix1, n, s(f1), ch, sound, f1);

		%-------------------------------------------------
		% SAMPLES IN TWO FILES
		%-------------------------------------------------

		elseif ((f2 - f1) == 1)

			%--
			% compute starting index and numbers of samples
			%--

			ix1 = ix - c(f1) + s(f1);

			n1 = (s(f1) - ix1);

			n2 = n - n1;

			%--
			% read and concatenate samples from files
			%--

			X1 = get_samples([sound.path, sound.file{f1}], ix1, n1, s(f1), ch, sound, f1);

			X2 = get_samples([sound.path, sound.file{f2}], 0, n2, s(f2), ch, sound, f2);

			X = [X1; X2];

		%-------------------------------------------------
		% SAMPLES IN MORE THAN TWO FILES
		%-------------------------------------------------

		else

			%--
			% compute starting index and numbers of samples
			%--
			
			ix1 = ix - c(f1) + s(f1);
			
			n1 = (s(f1) - ix1);
			
			n2 = n - n1 - (c(f2 - 1) - c(f1));

			%--
			% read and concatenate samples from various files
			%--

			% NOTE: read from first interior and last files
			
			X = get_samples([sound.path, sound.file{f1}], ix1, n1, s(f1), ch, sound, f1);

			for k = (f1 + 1):(f2 - 1)
				X = [X; get_samples([sound.path, sound.file{k}], 0, s(k), s(k), ch, sound, k)];
			end

			X = [X; get_samples([sound.path, sound.file{f2}], 0, n2, s(f2), ch, sound, f2)];

		end
		
	%--
	% samples in a workspace variable
	%--
		
	case 'variable'
		
		X = get_samples_from_variable(sound.file, ix, n, ch);
		
	%--
	% samples generated from scratch
	%--
		
	case 'synthetic'
		
		ext = sound.input;
		
		time = ix / get_sound_rate(sound);
		
		duration = n / get_sound_rate(sound);
		
		X = get_source_samples(ext, time, duration, ch);
		
end

%------------------------------------------------
% PRE-PROCESS SAMPLES
%------------------------------------------------

if isfield(sound.output, 'source') && ~isempty(sound.output.source)
	
	context.page.time = ix / get_sound_rate(sound); 
	
	context.page.duration = n / get_sound_rate(sound);
	
	context.page.channels = unique(ch);
	
	context.sound = sound; 
	
	for k = 1:length(sound.output.source)
	
		N = get_source_samples(sound.output.source(k), context);
		
		if size(N) == size(X)
			X = X + N;
		end
	
	end
	
end

if isfield(sound.output, 'filter') && ~isempty(sound.output.filter)
	
	context.sound = sound; context.debug = []; 
	
	context.page.samples = X; context.page.channels = ch;
	
	X = apply_signal_filter(X, sound.output.filter, context);
	
end

%---------------------------------------------------------------------
% GET_SAMPLES
%---------------------------------------------------------------------

function X = get_samples(f, ix, n, N, ch, sound, fix)

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% set default file index
%--

if nargin < 7
	fix = 1;
end

%--
% get sound output options
%--

opt = sound.output;

%--
% pass file name or info to file reader
%--

% THIS IS WHERE THE FILE STREAM BUG IS !!!

% WHICH FILE STREAM BUG ???

if ~isempty(sound.info)	&& (length(sound.info) > 1)
	info = sound.info(fix);
else
	info = f;
end 

%--------------------------
% GET SAMPLES
%--------------------------

%--
% get static sound samples
%--

if isempty(sound.input)
	
	X = sound_file_read(info, ix, n, N, ch, opt); return;

%--
% get recordable sound samples
%--

else
	
	%--
	% read existing file
	%--
	
	if exist(f, 'file')
		X = sound_file_read(info, ix, n, N, ch, opt); return;
	end
	
	%--
	% get samples for missing file section
	%--
	
	% NOTE: get channels if needed
	
	if isempty(ch)
		ch = 1:sound.channels;
	end
	
	X = zeros(n, length(ch));
	
end

%---------------------------------------------------------------------
% GET_SAMPLES_FROM_VARIABLE
%---------------------------------------------------------------------

function X = get_samples_from_variable(varname, ix, n, ch)

X = evalin('base', varname);

[r,c] = size(X);

if c > r
	X = X.';
end

if isempty(ch)
	ch = 1:size(X,2);
end

X = X(ix+1:ix+n, ch);


%---------------------------------------------------------------------
% SESSION_SOUND_READ
%---------------------------------------------------------------------

function [X, rate] = session_sound_read(sound, mode, t, dt, ch)

%-------------------------
% HANDLE INPUT
%-------------------------

if nargin < 5 || isempty(ch)
	ch = 1:sound.channels;
end

%--
% convert samples mode into time mode
%--

if strcmpi(mode,'samples')	
	
	dt = dt / sound.samplerate; 
	
	t = map_time(sound, 'real', 'slider', t / sound.samplerate);
	
	mode = 'time';
	
end

%-------------------------------------------
% SETUP
%-------------------------------------------

page.start = t; page.end = t + dt; page.duration = dt;

%--
% duck sound (remove time-stamps) for recursive call to sound_read
%--

duck_sound = sound; duck_sound.time_stamp.enable = 0; duck_sound.time_stamp.table = [];

%--
% get number of channels and rate
%--

nch = length(ch); rate = get_sound_rate(sound);

%--
% get sounds sessions
%--

collapsed = get_sound_sessions(sound, 1); expanded = get_sound_sessions(sound, 0);

%--
% find in-bounds sessions indexes
%--

ix = find(([expanded.end] > page.start) & ([expanded.start] <= page.end));

%-------------------------------------------
% GET SAMPLES
%-------------------------------------------

%--
% no sessions (in between), just dump zeros
%--

if isempty(ix)
	X = zeros(round(page.duration * rate),nch); return;
end

%--
% one or more sessions
%--

X = {};

%--
% leading zeros
%--

if expanded(ix(1)).start > page.start	
	X{end + 1} = zeros(round((expanded(ix(1)).start - page.start) * rate), nch); 
end

%--
% get the rest of the samples by looping over in-bounds sessions
%--

for k = ix
	
	last_session = (k + 1 > ix(end));
	
	%--
	% read samples for intersection of page and session
	%--
	
	read_start = max(collapsed(k).start, map_time(sound, 'record', 'real', page.start)); 
	
	read_dur = min(collapsed(k).end, map_time(sound, 'record', 'real', page.end)) - read_start;
	
	X{end + 1} = sound_read(duck_sound, 'time', read_start, read_dur, ch);
	
	%--
	% get zeros between this session and the next or between this session
	% and the end of the page
	%--
	
	if ~last_session	
		zero_dur = min(expanded(k + 1).start, page.end) - expanded(k).end;
	else	
		zero_dur = page.end - expanded(k).end;	
	end
	
	%--
	% write zeros
	%--
	
	if zero_dur > 0
		X{end + 1} = zeros(round(zero_dur * rate), nch);			
	end
		
end

%--
% concatenate samples and file boundaries
%--

X = vertcat(X{:});


%---------------------------------------------------------------------
% STACK_SOUND_READ
%---------------------------------------------------------------------

function [X,r] = stack_sound_read(sound,mode,x,dx,ch)

X = cell(1,numel(ch));

%--
% need to get appropriate index bounds for all sound "channels"
%--

sounds = sound.info;

%--
% get time start and duration
%--

t = ix / sound.samplerate; dt = n / sound.samplerate;

%--
% sound read
%--

for k = 1:length(ch)
	X{k} = sound_read(sounds(k), 'time', t, dt, []);
end

%--
% stack channels
%--

% NOTE: we have to make sure they stack properly, stretch not pad

L = cellfun('length', X);

if any(diff(L))

	longest = max(L);

	for k = 1:size(X, 1)
		X{k} = [X{k} ; zeros(longest - length(X{k}), sounds(k).channels)];
	end

end

X = [X{:}];



