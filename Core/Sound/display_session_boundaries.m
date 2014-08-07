function handles = display_session_boundaries(ax,times,start,names,data)

% display_session_boundaries - display given sound session boundaries
% -------------------------------------------------------------
%
% handles = display_session_boundaries(ax,times,start,names,data)
%
% Input:
% ------
%  ax - display axes
%  times - boundary times
%  start - start indicator for boundaries
%  names - session names
%  data - parent browser state
%
% Output:
% -------
%  handles - handles to created objects

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

%---------------------------------
% SETUP
%---------------------------------

%--
% declare tag for file boundaries and clean display axes
%--

tag = 'session_boundaries';

delete_labelled_lines(ax,tag); 

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% get relevant state from data
%--

sound = data.browser.sound; grid = data.browser.grid;

%--
% return if there is nothing or too much to display
%--

% NOTE: there is a problem cleaning up previous displays when we exit here

if ~grid.session.on || (numel(times) < 1) || (numel(times) > 50)
	handles = []; return;
end

%--
% set empty names
%--

if isempty(names)
	names = {};
end 

%--
% check names and times match if needed
%--

if ~isempty(names) && (numel(times) ~= numel(names))
	error('Boundary times and names do not match.');
end

%---------------------------------
% GET BOUNDARY TIMES AND LABELS
%---------------------------------

%--
% convert to session time if needed
%--
	
display_times = times;

% TODO: consider integrating this hack into 'get_session_time'

% HACK: this resolves a session boundary time mapping problem

end_times = times(~start) - 0.005; display_times(~start) = end_times;

display_times = map_time(sound, 'real', 'slider', display_times);

end_times = display_times(~start); display_times(~start) = end_times + 0.005;

%--
% use grid and sound to produce time position strings
%--

% TODO: consider adding session time duration to strings

labels = get_grid_time_string(grid, display_times, sound.realtime);

if (ischar(labels))
	labels = {labels};
end 

%--
% create multi-line labels if needed
%--

if (~isempty(names))
	for k = 1:numel(times)
		labels{k} = {names{k}; labels{k}};
	end
end

%--
% add session duration to start time labels
%--

sessions = get_sound_sessions(sound);

for k = 1:numel(times)
	
	if (start(k))
		
		session = sessions([sessions.start] == times(k)); duration = session.end - session.start;
		
		string =  strcat('(', get_grid_time_string(grid, duration), ')');
		
		temp = labels{k};
		
		if (ischar(temp))
			temp = {temp};
		end
		
		labels{k} = {temp{:}, string}';
		
	end 
	
end
	
%--
% set options and draw lines
%--

opt = labelled_lines; 

opt.color = grid.color; opt.style = '-.'; opt.tag = tag; 

opt.enable = grid.session.labels; 

% NOTE: if we display sessions at bottom we flip labels

% opt.vertical = 'bottom';

% session starts

handles = labelled_lines(ax, times(start > 0), labels(start > 0), opt);

% session ends

opt.horizontal = 'right';

handles = labelled_lines(ax, times(~start), labels(~start), opt);
