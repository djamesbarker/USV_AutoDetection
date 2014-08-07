function X = load_image

% load_image - load image from file
% ---------------------------------
%
% X = load_image
%
% Output:
% -------
%  X - image matrix

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
% $Revision: 229 $
% $Date: 2004-12-09 14:54:20 -0500 (Thu, 09 Dec 2004) $
%--------------------------------

%--
% get image file interactively
%--

[f,p] = uigetfile2( ...
	{ ...
		'*.gif;*.jpg;*.png;*.tif', 'All Image Files (*.gif, *.jpg, *.png, *.tif)';
        '*.gif',  'GIF Images (*.gif)'; ...
        '*.jpg','JPEG Images (*.jpg)'; ...
        '*.png','PNG Images (*.png)'; ...
        '*.tif','TIFF Images (*.tif)'; ...
        '*.*',  'All Files (*.*)' ...
	}, ...
	'Select an image file' ...
);

%--
% load image file
%--

% NOTE: return empty on cancel

if (f)
	X = imread([p,f]);
else
	X = [];
end
