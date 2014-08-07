function scale = harray_scale(par, scale)

% harray_scale - set scale for harray layout
% ------------------------------------------
%
% scale = harray_scale(par, scale)
%
% Input:
% ------
%  par - parent figure
%  scale - desired layout scale (def: 1)
%
% Output:
% -------
%  scale - current layout scale

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

%-------------------------------------
% HANDLE INPUT
%-------------------------------------

%--
% set default scale
%--

if (nargin < 2) || isempty(scale)
	scale = 1;
end

%--
% set parent figure
%--

if (nargin < 1)
	par = gcf;
end

if isempty(par)
	scale = []; return;
end

%-------------------------------------
% UPDATE LAYOUT SCALE
%-------------------------------------

%--
% get harray data
%--

data = harray_data(par);

if isempty(data)
	scale = []; return;
end

%--
% scale layouts
%--

data.base = layout_scale(data.base, scale);

data.layout = layout_scale(data.layout, scale);

%--
% update harray data
%--

harray_data(par, data);
