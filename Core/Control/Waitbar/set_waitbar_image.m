function g = set_waitbar_image(ax,color,value)

% set_waitbar_image - set image in waitbar axes
% ---------------------------------------------
%
% g = set_waitbar_image(ax,color)
%
% Input:
% ------
%
% Output:
% -------
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
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set empty value and color
%--

if (nargin < 3)
	value = [];
end

if (nargin < 2)
	color = []; 
end

%--------------------------------------------
% SET WAITBAR IMAGE
%--------------------------------------------

%--
% create image if needed
%--

% NOTE: this also sets the color

g = findall(ax,'type','image');

if (isempty(g))
	
	if (isempty(color))
		error(['Color must be provided when creating a waitbar.']);
	end
	
	%--
	% create image and set initial properties
	%--
		
	g = image('parent',ax);
		
	set(g, ...
		'cdata',create_gradient(color), ...
		'xdata',[0,1], ...
		'ydata',[0,1], ...
		'handlevisibility','off', ...
		'hittest','off' ...
	);

	set(ax,'layer','top');
			
%--
% update the color if needed
%--

else
	
	create = 0; 
	
	if (~isempty(color))
		set(g,'cdata',create_gradient(color));
	end
	
end

%--
% update value if needed
%--

if (~isempty(value))
		
	% NOTE: it is not clear why the value must be halved ???
	
	if (value > 0)
		set(g,'xdata',[0, value/2],'visible','on'); 
	else
		set(g,'visible','off');
	end
	
end


%-----------------------------------------------------
% CREATE_GRADIENT
%-----------------------------------------------------

% TODO: develop a variety of gradients

% NOTE: this will eventually move to a separate function

function X = create_gradient(color,n)

%---------------------------------
% HANDLE INPUT
%---------------------------------

if (nargin < 2)
	n = 64;
end

%---------------------------------
% CREATE IMAGE
%---------------------------------

for k = 1:3
	X(:,1,k) = (5 * color(k) + linspace(0.1,1,n)') / 6;
end
