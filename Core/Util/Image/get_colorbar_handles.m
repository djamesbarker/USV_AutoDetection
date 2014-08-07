function h = get_colorbar_handles(g)

% get_colorbar_handles - get colorbar axes handles
% ------------------------------------------------
%
% h = get_colorbar_handles(g)
%
% Input:
% ------
%  g - figure handle (def: gcf)
%
% Output:
% -------
%  h - handles to colorbar axes

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
% $Date: 2003-02-18 17:43:20-05 $
% $Revision: 1.24 $
%--------------------------------

%--
% set figure
%--

if (nargin < 1)
	g = gcf;
end

%--
% get colorbar axes handles
%--

h = findobj(g,'type','axes','tag','Colorbar');
