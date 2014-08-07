function test_selection

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

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
% create axes
%--

ax = axes( ...
	'parent', fig, ...
	'units', 'normalized', ...
	'position', [0, 0, 1, 1], ...
	'color', 'none', ...
	'xlim', [0, 1], ...
	'ylim', [0, 1], ...
	'xtick', [], ...
	'ytick', [] ...
);

hold(ax, 'on');

%--
% configure selection
%--

opt = selection_axes;

opt.linestyle = ':';

opt.grid.on = 1;

opt.grid.x.on = 1; opt.grid.y.on = 1;

opt.callback.patch.double_click = @patch_callback;

%--
% add selection to axes
%--

selection_axes(ax, 'TEST_SELECTION', opt);


%----------------------------------------
% CALLBACKS
%----------------------------------------

% NOTE: the signature combines the matlab callback framework with our convention

%--
% patch_callback
%--

function patch_callback(obj, eventdata, sel, opt)

set(obj, ...
	'facecolor', 0.5 * (rand(1,3) + 1) ...
);


%--
% edit_start_callback
%--

function edit_start_callback(obj, eventdata, sel, opt)


%--
% edit_move_callback
%--

function edit_move_callback(obj, eventdata, sel, opt)


%--
% edit_stop_callback
%--

function edit_stop_callback(obj, eventdata, sel, opt)

