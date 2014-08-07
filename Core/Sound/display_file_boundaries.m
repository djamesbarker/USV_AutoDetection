function handles = display_file_boundaries(ax,times,files,data)

% display_file_boundaries - display given sound file boundaries
% -------------------------------------------------------------
%
% handles = display_file_boundaries(ax,times,files,data)
%
% Input:
% ------
%  ax - display axes
%  times - boundary times
%  files - boundary files
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

% NOTE: declare tag for file boundaries and clean display axes

tag = 'file_boundaries';

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

if (~grid.file.on || (numel(times) < 1) || (numel(times) > 50))
	handles = []; return;
end

%--
% set empty files
%--

if (nargin < 2) 
	files = {};
end 

if (ischar(files))
	files = {files};
end

%--
% check files and times match if needed
%--

if (~isempty(files) && (numel(times) ~= numel(files)))
	error('Boundary times and files do not match.');
end

%---------------------------------
% GET BOUNDARY TIMES AND LABELS
%---------------------------------

%--
% use grid and sound to produce time position strings
%--

display_times = map_time(sound, 'real', 'slider', times);

labels = get_grid_time_string(grid,display_times,sound.realtime);

if (ischar(labels))
	labels = {labels};
end 

%--
% get duration strings
%--

[ignore,duration] = get_file_times(sound,files);

durations = strcat('(', get_grid_time_string(grid,duration), ')');

if (ischar(durations))
	durations = {durations};
end

%--
% create multi-line labels if needed
%--

if (isempty(files))
	for k = 1:numel(times)
		labels{k} = {labels{k}; durations{k}};
	end
else
	for k = 1:numel(times)
		labels{k} = {files{k}; labels{k}; durations{k}};
	end
end

%--
% set options and draw lines
%--

opt = labelled_lines;

opt.tag = tag;

opt.color = grid.color;

opt.style = '--';

opt.enable = grid.file.labels;

handles = labelled_lines(ax,times,labels,opt);
