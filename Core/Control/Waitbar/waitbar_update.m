function [flag, handles] = waitbar_update(pal, name, varargin)

% waitbar_update - update waitbar in waitbar group
% ------------------------------------------------
%
% [flag, handles] = waitbar_update(pal, name, prop, value, ... )
%
% Input:
% ------
%  pal - waitbar handle
%  name - specific waitbar name
%  prop - waitbar property
%  value - property value
%
% Output:
% -------
%  flag - update indicator
%  handles - waitbar handles

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

%--
% sometimes we need to remind ourselves that ...
%--

% persistent KLIP_PATH;
% 
% if isempty(KLIP_PATH)
% 	KLIP_PATH = [path_parts(mfilename('fullpath')), filesep, 'private', filesep, 'klip.wav'];
% end

% NOTE: return quickly if we are unable to get basic handles

%--------------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------------

%--
% get waitbar figure
%--

if ischar(pal)
	
	pal = findobj(0, 'type', 'figure', 'tag', ['XBAT_WAITBAR::', pal]);
	
	if isempty(pal)
		flag = 0; return;
	end
	
else
	
	% NOTE: this and testing 'beingdeleted' don't always work, try wrapping get in an exception
	
	if ~ishandle(pal)
		flag = 0; return;
	end
	
end

%-------------------------------------
% WAITBAR VISIBILITY
%-------------------------------------

if strcmpi(get(pal, 'visible'), 'off')

	% NOTE: combine creation time with current time and 'show_after' waitbar property
	
	data = get(pal, 'userdata');
	
	elapsed = etime(clock, data.created);

	if elapsed > data.opt.show_after
		set(pal, 'visible', 'on');
	end
	
	% TODO: consider progress and whether we really need it now

end

% NOTE: return if there are no further updates

if length(varargin) < 1
	return;
end

%--------------------------------------------------------
% SETUP
%--------------------------------------------------------

% NOTE: access figure and control elements directly for speed

%--
% get all waitbar elements
%--

% NOTE: these are all name tagged

handles = findobj(pal, 'tag', name);

if isempty(handles)
	flag = 0; return;
end

%--
% get bar handle and stored data
%--

% NOTE: time estimation and update rate information is contained in bar

ax = findobj(handles, 'type', 'axes');

if isempty(ax)
	flag = 0; return;
end

bar = findall(ax, 'type', 'image');

data = get(bar, 'userdata');

%--------------------------------------------------------
% UPDATE WAITBAR
%--------------------------------------------------------

%-------------------------------------
% WAITBAR PROPERTIES
%-------------------------------------

%--
% get field value pairs
%--

% NOTE: the second input states allowed fields

[field, value] = get_field_value(varargin, {'value', 'message', 'color'});

%--
% loop over and update all properties
%--

for k = 1:length(field)
	
	switch lower(field{k})
		
		%-------------------------------------
		% COLOR
		%-------------------------------------
			
		case 'color'
				
			%--
			% update waitbar image to use new color
			%--
			
			set_waitbar_image(ax, value{k});
			
		%-------------------------------------
		% MESSAGE
		%-------------------------------------
			
		case 'message'
			
			%--
			% get message text
			%--
			
			txt = findobj(handles, 'flat', 'userdata', 'MESSAGE');
			
			% NOTE: return quickly if text is not found
			
			if isempty(txt)
				flag = 0; continue;
			end
			
			%--
			% update message
			%--
			
			set(txt, 'string', value{k});
			
		%-------------------------------------
		% VALUE
		%-------------------------------------
		
		case 'value'
			
% 			if rand > 0.99999
% 				wavplay(sound_file_read(KLIP_PATH), 44100, 'async');
% 			end
			
			%------------------------------------
			% UPDATE VALUE
			%------------------------------------
				
			if ~isempty(value{k})
				
				%--
				% check value is in bounds
				%--
				
				% TODO: consider enforcing bounds
				
				if (value{k} < 0) || (value{k} > 1)
					disp('WARNING: waitbar update value is out of range.'); continue;
				end
				
				%--
				% update bar
				%--
	
				set_waitbar_image(ax, [], value{k});
				
				%--
				% update progress header if available
				%--
				
				if strcmp(name, 'PROGRESS')
					
					%--
					% get handle to progress header text
					%--
					
					ax = findobj(pal, 'tag', 'Progress'); 
					
					head = findobj(ax, 'tag', 'header_text');
					
					%--
					% update progress header text if needed
					%--
					
					if ~isempty(head)
						set(head, ...
							'string', ['Progress (', int2str(round(value{k} * 100)), '%)'] ...
						);
					end
					
				end
				
			else
				
				% NOTE: does this ever happen, and should it?
				
				%--
				% get bar value
				%--
				
				xdata = get(bar, 'xdata');
				
				value{k} = xdata(2);
				
			end
			
			%------------------------------------
			% UPDATE SPEED AND TIMES
			%------------------------------------

			%--
			% update waitbar data
			%--
			
			data = bar_data_update(bar, value{k}, data);
			
			%--
			% display relative speed
			%--

			relative = findobj(handles, 'userdata', 'RELATIVE_SPEED');

			if ~isempty(relative)
				set(relative, 'string', [num2str(data.relative_speed), 'x']);
			end
			
			%--
			% display elapsed time
			%--

			elapsed = findobj(handles, 'userdata', 'ELAPSED_TIME');

			if ~isempty(elapsed)
				set(elapsed, 'string', sec_to_clock(data.elapsed_time));
			end
			
			%--
			% display remaining time
			%--
			
			remaining = findobj(handles, 'userdata', 'REMAINING_TIME');
			
			if ~isempty(remaining)
				
				if isempty(data.remaining_time)
					str = '(Not Available)';
				else
					
					if data.remaining_time > 2
						data.remaining_time = round(data.remaining_time);
					end					
					
					str = ['-', sec_to_clock(data.remaining_time)];
				end
				
				set(remaining, 'string', str);

			end
					
	end % property switch
	
end

%--
% output flag
%--

flag = 1;

%--
% update waitbar display consider update rate
%--

% NOTE: dropping drawnow calls, is not the same as dropping update requests

if isempty(data.update_rate)

	drawnow;
	
else
	
	%--
	% set last update and draw on first call
	%--
	
	if isempty(data.last_update)
		data.last_update = clock; set(bar, 'userdata', data);
	end
	
	%--
	% decide whether to request display
	%--
	
	% NOTE: drop the update event if the last update is too close
					
	if etime(clock, data.last_update) < data.update_rate
		return;
	end
			
	%--
	% update display and userdata
	%--
	
	drawnow;
	
	data.last_update = clock; set(bar, 'userdata', data);
	
end


%-----------------------------------------------
% BAR_DATA_UPDATE
%-----------------------------------------------

function data = bar_data_update(bar, value, data)

% bar_data_update - update bar time data
% --------------------------------------
%
% data = bar_data_update(bar, value, data)
%
% Input:
% ------
%  bar - bar handle
%  value - set value
%  data - bar data
%
% Output:
% -------
%  data - updated bar data

%-------------------------------
% UPDATE DATA
%-------------------------------

%--
% get time and compute elapsed time
%--

time = clock;

elapsed_time = etime(time, data.start_time);

if (elapsed_time > 5)
	elapsed_time = round(elapsed_time);
end

data.elapsed_time = elapsed_time;

%--
% compute value and time change
%--

dx = value - data.last_value;

dt = etime(time, data.last_time);

%--
% update speed estimate and remaining time
%--

if (dx > 0)

	%--
	% speed estimate
	%--
	
	% NOTE: epsilon avoids division by zero
	
	speed = dx / (dt + eps);
	
	if isempty(data.speed)
		data.speed = speed;
	else
		data.speed = ((9 * data.speed) + speed) / 10;
	end

	%--
	% relative speed estimate
	%--
	
	if ~isempty(data.duration)
		data.relative_speed = simplify(data.speed * data.duration);
	end
	
	%--
	% remaining time estimate
	%--
	
	data.remaining_time = (1 - value) / data.speed;
	
else
	
	data.remaining_time = data.remaining_time + dt;
	
end

%--
% update last update time and value
%--

data.last_time = time; 

data.last_value = value;

%--
% handle bar start, initialize, and end updates
%--

if (value == 0)
	
	data.start_time = time; data.end_time = [];

elseif (value > 0) && isempty(data.start_time)
	
	data.start_time = time;

elseif (value == 1) && isempty(data.end_time)
	
	data.end_time = time;
	
end

%--
% update bar data
%--

set(bar, 'userdata', data);


%-----------------------------------------------
% SIMPLIFY
%-----------------------------------------------

% TODO: make round to order function

function value = simplify(value)

digits = floor(log10(value));

if digits < 1
	return;
end

factor = 10^(digits - 1);

value = factor * round(value / factor);

