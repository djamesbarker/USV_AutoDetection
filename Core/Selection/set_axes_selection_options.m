function opt = set_axes_selection_options(ax, opt)

% set_axes_selection_options - set default selection options for axes
% -------------------------------------------------------------------
%
% opt = set_axes_selection_options(ax)
%
% Input:
% ------
%  ax - axes handles
%
% Output:
% -------
%  opt - selection options set

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

if (nargin < 2) || isempty(opt)
	opt = selection_axes;
end

selection_axes(ax, opt.name, opt);

refresh_axes_selections(ax);
