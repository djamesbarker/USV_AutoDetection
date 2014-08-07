function [X,g] = get_image_data(h)

% get_image_data - get image cdata
% --------------------------------
%
% [X,g] = get_image_data(h)
%
% Input:
% ------
%  h - handle to parent figure or axes (def: gcf)
%
% Output:
% ------
%  X - image data
%  g - handle to image

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
% set parent handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% get image handle
%--

[g,t] = get_image_handles(h);

if (length(g) >  1)
		
	tmp = findobj(gca,'type','image');
	
	if (~isempty(find(g == tmp)))
		g = tmp;
	else
		g = g(1);
		disp(' ');
		warning('Parent h contains multiple images, first image selected.');
		disp(' ');
	end
	
end

%--
% get image data
%--

X = get(g,'CData');

%--
% ensure image data type
%--

% t = t(end - 1:end);

% if (strcmp(t,'U8'))
% 	X = uint8(X);
% end
