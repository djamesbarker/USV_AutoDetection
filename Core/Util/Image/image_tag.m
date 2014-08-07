function tag = image_tag(X)

% image_tag - create image tag string
% -----------------------------------
%
% tag = image_tag(X)
%
% Input:
% ------
%  X - image to tag
%
% Output:
% -------
%  tag - image tag string

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% check for stack of images and handle separately
%--

% NOTE: the stack, based on a cell array, may be heterogenous in its content

if (is_stack(X))
	tag = 'IMAGE_STACK';
	return;
end

%--
% create tag for image based on size and class
%--

[m,n,d] = size(X);

switch (d)

	%--
	% scalar image
	%--
	
	case (1)

		if (isa(X,'double'))
			tag = 'IMAGE_GRAY';
		else
			tag = ['IMAGE_GRAY_', class_tag(X)];
		end

	%--
	% color image
	%--

	case (3)

		if (isa(X,'double'))
			tag = 'IMAGE_RGB';
		else
			tag = ['IMAGE_RGB_', class_tag(X)];
		end

	%--
	% generic multiple plane image
	%--
	
	otherwise

		if (isa(X,'double'))
			tag = 'IMAGE_NDIM';
		else
			tag = ['IMAGE_NDIM_', class_tag(X)];
		end

end

%----------------------------------------------
% CLASS_TAG
%----------------------------------------------

function tag = class_tag(X)

% class_tag - create tag string for class
% ---------------------------------------
%
% tag = class_tag(X)
%
% Input:
% ------
%  X - input object
%
% Output:
% -------
%  tag - class tag string

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

% NOTE: this function may have other uses, however the simplification of
% the class tags versus using the actual class strings is mostly for
% backward compatibility

%--
% uppercase class name
%--

tag = upper(class(X));

%--
% handle integer tags differently
%--

if (strncmp(tag,'INT',3))
	tag = tag(4:end);
	return;
end

if (strncmp(tag,'UINT',4))
	tag = ['U', tag(5:end)];
	return;
end


