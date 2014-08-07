function [view, created] = view_figure(par, ext, data)

% view_figure - create view figure
% --------------------------------
%
% [view, created] = view_figure(par, data)
%
% Input:
% ------
%  par - parent figure
%  ext - extension to view
%
% Output:
% -------
%  view - view figure
%  created - creation indicator

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

%----------------------------
% HANDLE INPUT
%----------------------------

view = [];

%--
% check browser input
%--

if ~is_browser(par)
	return;
end

%--
% get browser state if needed
%--

if nargin < 3 || isempty(data)
	data = get_browser(par);
end

%----------------------------
% BUILD TAG AND NAME
%----------------------------

% NOTE: consider passing the sound or getting sound name from parent tag

% NOTE: we may want to include the extension name in the figure name

%--
% get tag and name elements
%--

TAG_PREFIX = 'XBAT_VIEW_DISPLAY';

NAME_PREFIX = 'View';

% TODO: get these from the context, also do this in explain figure

user = get_active_user; 

lib = get_active_library(user); 

sound.name = sound_name(data.browser.sound);

%--
% put tag and name together
%--

% NOTE: this tag is sufficient for a single view figure, for multiple view add extension name

tag = [TAG_PREFIX, '::', user.name, '::', lib.name, '::', sound.name];

name = [' ', NAME_PREFIX, '  -  ', ext.name, '  -  ', sound.name];

%----------------------------
% CREATE FIGURE
%----------------------------

%--
% ensure singleton condition
%--

% NOTE: we may need a clear function for existing figure, or layout should do it

view = findobj('tag', tag);

if (view)
	created = 0; return;
end

%--
% compute view position based on parent
%--

% NOTE: we place view right under parent

MARGIN = 64;

position = get(par, 'position'); position(2) = position(2) - position(4) - MARGIN;

%--
% add parent to state
%--

clear data;

data.parent = par;

%--
% create new figure and set relevant properties
%--

view = figure( ...
	'tag', tag, ...
	'name', name, ...
	'userdata', data, ...
	'dockcontrols', 'off', ...
	'doublebuffer', 'on', ...
	'numbertitle', 'off', ...
	'position', position ...
);

created = 1;
