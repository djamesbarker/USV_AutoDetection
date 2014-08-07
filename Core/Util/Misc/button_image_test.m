function b = button_image_test(x,y,d)

% button_image_test - use gradient image to set button color
% ----------------------------------------------------------

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
% set default size and padding
%--

if (nargin < 3)
	d = 25; 
end

if (nargin < 2)
	y = 50; 
end
	
if (nargin < 1)
	x = 4 * y;
end

%--
% create and position figure and button
%--

f = figure; b = uicontrol(f);

p = get(f,'position'); p(3:4) = [x,y] + 2*d; set(f,'position',p);

set(b,'position',[d,d,x,y]);

%--
% set button label and callback
%--

set(b, ...
	'string','PUSH ME', ...
	'callback',@update_button ...
);

%--
% set initial button image and tooltip using callback
%--

update_button(b,[]);


%---------------------------------------------------------------

function update_button(obj,eventdata)

%--
% create random color
%--

c = rand(1,3);

%--
% set button image and tooltip
%--

set(obj, ...
	'cdata',button_image(obj,c), ...
	'tooltip',['Base Color: ', mat2str(c,2)] ... 
);


%---------------------------------------------------------------

function im = button_image(b,c)

%--
% set default color
%--

if (nargin < 2)
	c = [0.75, 0.75, 1];
end

% NOTE: lighten button color to allow for black label text

c = (c + 2) ./ 3;

%--
% get button size in pixels
%--

% NOTE: there is a function to get size of object in pixels, look for it

par = ancestor(b,'figure'); units = get(par,'units'); set(par,'units','pixels');

p = get(b,'position');

set(par,'units',units);

%--
% create button image
%--

x = p(3); y = p(4);

temp = linspace(1,0.5,p(4))' * ones(1,p(3));

% TODO: make boundary thickness and color of boundary parameters

% TODO: make rounded corners

% NOTE: this sets a one pixel dark boundary

dark = 0.125;

temp(:,1) = dark; temp(:,end) = dark; temp(1,:) = dark; temp(end,:) = dark;

for k = 1:3
	im(:,:,k) = c(k) * temp;
end
