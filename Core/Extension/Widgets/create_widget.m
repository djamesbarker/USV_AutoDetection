function widget = create_widget(par, ext, context, pos)

% create_widget - create widget figure
% ------------------------------------
%
% widget = create_widget(par, ext, context, pos)
%
% Input:
% ------
%  par - parent figure
%  ext - widget extension
%  context - context
%  pos - initial widget position with respect to parent
%
% Output:
% -------
%  widget - widget figure

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

% TODO: ensure singleton condition for widget

%-------------------
% HANDLE INPUT
%-------------------

%--
% set default position relative to parent
%--

if (nargin < 4) || isempty(pos)
	pos = 'bottom right';
end

%--
% get context (and updated extension) if needed
%--

% NOTE: it is not clear that we want to overwrite the extension?

if (nargin < 3) || isempty(context)
	[ext, ignore, context] = get_browser_extension('widget', par, ext.name);
end

%-------------------
% CREATE WIDGET
%-------------------

%--
% create figure, name and tag
%--

widget = figure;

tag = build_widget_tag(par, ext);

set(widget, ...
	'name', ext.name, 'numbertitle', 'off', ...
	'tag', tag ...
);

%--
% store extension state in figure
%--

% NOTE: this is compatible with control palette extensions (this is a duck)

data.opt.ext = ext;

data.parent = par;

% NOTE: this could become stale! context should be used carefully in widgets

data.context = context;

data.created = clock;

set(widget, ...
	'userdata', data, ...
	'closerequestfcn', {@widget_close, par} ...
);

%--
% add extension menus
%--

extension_menus(widget);

% NOTE: we need to restore tag clobbered during menu creation

set(widget, 'tag', tag);

%--
% set widget size
%--

% NOTE: we size widget using parent as reference

par_pos = get(par, 'position'); widget_pos = get(widget, 'position');

widget_pos(3:4) = [0.6 * par_pos(3), par_pos(4)]; 

set(widget, 'position', widget_pos);

%--
% position widget
%--

position_palette(widget, par, pos);

%-------------------
% UPDATE WIDGET
%-------------------

% NOTE: relevant events may have occured before widget was created 

% NOTE: widget data depends on parent and event, it is different for each update

%--
% page update
%--

% NOTE: surely we are on some page, also the last argument forces layout

widget_update(par, widget, 'page', [], 1); 

%--
% selection update
%--

% NOTE: we may have missed when a selection was made

[ignore, count] = get_browser_selection(par);

if count
	widget_update(par, widget, 'selection__create');
end

%--
% play started update
%--

% NOTE: we may have missed when a current player started

if ~isempty(get_player_buffer)
	widget_update(par, widget, 'play__start');
end



