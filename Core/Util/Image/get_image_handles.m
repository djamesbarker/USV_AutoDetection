function [g,tag] = get_image_handles(h)

% get_image_handles - get image handles from figure
% -------------------------------------------------
%
% [g,tag] = get_image_handles(h)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%
% Output:
% -------
%  g - image handles (not colorbars)
%  tag - image tags

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
% $Date: 2003-07-06 13:36:52-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% get image handles
%--

g = findobj(h,'type','image');

%--
% remove colorbars if needed
%--

ix = find(strcmp(get(g,'tag'),'TMW_COLORBAR'));

if (~isempty(ix))
	g(ix) = [];
end

%--
% get tags of remaining images
%--

if (nargout > 1)
	tag = get(g,'tag');
end
