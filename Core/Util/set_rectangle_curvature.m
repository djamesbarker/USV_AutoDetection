function value = set_rectangle_curvature(handle, radius)

% set_rectangle_curvature - set rectangle curvature in pixels
% -----------------------------------------------------------
%
% value = set_rectangle_curvature(handle, radius)
%
% Input:
% ------
%  handle - rectangle handle
%  radius - curvature radius in pixels
%
% Output:
% -------
%  value - set indicator

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

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% set default radius
%--

% if nargin < 2
% 	radius = 10;
% end

radius = 0;

%--
% handle multiple handles recursively
%--

% NOTE: no errors are displayed when setting multiple handles

if numel(handle) > 1
	
	value = zeros(size(handle));
	
	for k = 1:numel(handle)
		try
			value(k) = set_rectangle_curvature(handle(k), radius);
		end
	end 
	
	return;

end

%--
% check handle input
%--

if ~ishandle(handle) || ~strcmp(get(handle, 'type'), 'rectangle')
	error('Input must be handle of type rectangle.');
end

%-----------------------
% SET CURVATURE
%-----------------------

% NOTE: when axes have non-trivial aspect we also need 'xlim', 'ylim', and 'dataspectratio'

%--
% get needed parent axes properties
%--

ax.handle = get(handle, 'parent'); 

ax.pos = get_size_in(ax.handle, 'pixels', 'pack');

%--
% get rectangle width and height in pixels
%--

pos = get(handle, 'position');

width = ax.pos.width * pos(3); height = ax.pos.height * pos(4);

%--
% compute curvature values to get desired result
%--

curvature = radius ./ [width, height];

set(handle, 'curvature', curvature);




