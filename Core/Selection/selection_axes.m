function ax = selection_axes(ax, name, opt)

% selection_axes - create or make axes with selection
% ---------------------------------------------------
%
%  ax = selection_axes(ax, name, opt) 
%
% opt = selection_axes
%
% Input:
% ------
%  ax - axes handle
%  name - name for selection axes
%  opt - selection options
%
% Output:
% -------
%  ax - selection axes handle

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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

% TODO: name axes variables when setting selection axes

% TODO: consider some kind of flash on patch callback

% TODO: set double click callback as well

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% create possibly output default selection options
%--

if (nargin < 3) || isempty(opt)
	
	opt = selection_axes_options;
	
	if ~nargin
		ax = opt; return;
	end
	
end

%--
% set default name
%--

if (nargin < 2) || isempty(name)
	name = 'SELECTION_AXES';
end 

%--
% set default axes
%--

if (nargin < 1) || isempty(ax)
	ax = gca;
else
	if ~ishandle(ax) || ~strcmp(get(ax,'type'), 'axes')
		error('Input is not axes handle.');
	end
end 

%-------------------------
% CREATE SELECTION AXES
%-------------------------

% NOTE: at the moment this is the only store of the axes name

opt.name = name;

set(ax, 'buttondownfcn', {@selection_axes_callback, opt});


%--------------------------------------------
% SELECTION_AXES_OPTIONS
%--------------------------------------------

function opt = selection_axes_options

%--
% tag
%--

opt.name = '';

%--
% display
%--

% patch

opt.color = [1, 0, 0]; opt.alpha = 0;

opt.linestyle = '-'; opt.linewidth = 1;

% grid

opt.grid.on = 1;

opt.grid.x.on = 1; opt.grid.x.label = 1;

opt.grid.y.on = 1; opt.grid.y.label = 1;

opt.grid.color = 0.5 * ones(1, 3);

opt.grid.linestyle = ':'; opt.grid.linewidth = 1;

%--
% edit
%--

% controls

opt.control.on = 1; opt.control.marker = 's';

opt.center.on = 1; opt.center.marker = '+';

opt.markersize = 6;

% limit behavior

opt.limit.x = 1; opt.limit.y = 1;

%--
% callbacks
%--

% NOTE: these define rich behavior beyond simple axes limit bounding

opt.callback.keypress = [];

opt.callback.patch.click = [];

opt.callback.patch.double_click = [];

opt.callback.edit.start = [];

opt.callback.edit.move = [];

opt.callback.edit.stop = [];



