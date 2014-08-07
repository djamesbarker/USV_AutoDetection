function [sel, opt] = set_axes_selections(ax, sel, opt, mode)

% set_axes_selections - set axes selections
% -----------------------------------------
%
% [sel, opt] = set_axes_selections(ax)
%
% Input:
% ------
%  ax - parent axes
%
% Output:
% -------
%  sel - selections
%  opt - selection options

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

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% check target axes
%--

if ~is_selection_axes(ax)
	error('Target axes are not selection axes.');
end

%--
% set and check mode
%--

if (nargin < 4) || isempty(mode)
	mode = 'set';
end

modes = {'add', 'set'};

if ~ismember(mode, modes)
	error('Unrecognized set selection mode.');
end

%--
% set default options
%--

if nargin < 3
	opt = []; 
end

%--
% set default selections
%--

if nargin < 2
	sel = [];
end

%---------------------------
% SET SELECTIONS
%---------------------------

%--
% clear selection if needed
%--

if strcmp(mode, 'set')
	selection_delete(ax);
end

%--
% set selections
%--

if isempty(sel)
	return;
end

% NOTE: we always draw from scratch when setting selections

if isempty(opt)
	
	for k = 1:length(sel)
		selection_draw(ax, sel(k), [], 0);
	end
	
else
	
	% NOTE: consider adding support for a single options struct
	
	for k = 1:length(sel)
		selection_draw(ax, sel(k), opt{k}, 0);
	end
	
end
