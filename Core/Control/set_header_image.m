function g = set_header_image(ax,color)

% set_header_image - set image in header axes
% -------------------------------------------
%
% g = set_header_image(ax,color)
%
% Input:
% ------
%  ax - axes to parent image
%  color - base color for image
%
% Output:
% -------
%  g - handle to header image

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
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

%--
% get gradient image display state
%--

state = get_env('palette_gradient');

if (isempty(state))
	state = 'off'; set_env('palette_gradient',state);
end

%--
% return if gradient display is off
%--

if (strcmp(state,'off'))
	delete(findall(ax,'tag','header_image')); return;
end

%--
% create gradient image data
%--

for k = 1:3
	X(:,1,k) = (5 * color(k) + linspace(0.1,1,64)') / 6;
end

%--
% get image handle
%--

g = findall(ax,'tag','header_image');

% NOTE: create image if needed

if (isempty(g))
	g = image('parent',ax); set(ax,'layer','top');
end

%--
% update image properties
%--

set(g, ...
	'tag','header_image', ...
	'cdata',X, ...
	'xdata',[0,1], ...
	'ydata',[0,1], ...
	'hittest','off', ...
	'handlevisibility','off' ...
);
