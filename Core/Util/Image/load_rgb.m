function [X,d] = load_rgb(f);

% load_rgb - load a color image
% -----------------------------
%
% [X,d] = load_rgb(f);
%
% Input:
% ------
%  f - image filename (def: open file dialog)
% 
% Output:
% -------
%  X - rgb image
%  d - image file info

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
% get path if filename is provided
%--

if (nargin)
	pi = pwd;
	cd(image_path);
	p = get_path(f);
end

%--
% get filename and path if not provided
%--

if (~nargin)

	pi = pwd;
	
	try
		cd(image_path);
	end
	
	[f,p] = uigetfile2('*','Select Image File:');

	if (~f)
		
		disp(' ');
		warning('No image was loaded because uigetfile was cancelled.');
		disp(' ');
		
		X = [];
		return;
		
	end

end

%--
% move to p
%--

cd(p);

% update image path

image_path(p);

%--
% read image
%--

X = imread(f);

%--
% convert to rgb if needed
%--

if (is_gray(X))

	t = uint8(lut_range(X));
	
	[m,n] = size(t);
	
	X = zeros(m,n,3);
	
	for k = 1:3
		X(:,:,k) = t;
	end

end

%--
% image file info
%--

if (nargout > 1)
	d = imfinfo(f);
elseif (~nargout)
	disp(' ');
	info = imfinfo(f);
	disp(info);
	fig; image_view(X);
	title_edit(info.Filename);
end

%--
% return to initial directory
%--

cd(pi);

%--
% FUNCTION
%--

function p = get_path(f)

% get_path - get path from filename
% ---------------------------------
% 
% p = get_path(f)
%
% Input:
% ------
%  f - filename
%
% Output:
% -------
%  p - path for directory where file is located
%

%--
% get full path using which
%--

p = which(f);

%--
% remove filename from full path
%--

p = p(1:findstr(p,f)-1);





