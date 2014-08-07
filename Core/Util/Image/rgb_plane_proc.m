function [Y1,Y2,Y3] = rgb_plane_proc(f,X,SE,p1,p2,p3)

% rgb_plane_proc - plane by plane processing of rgb images
% --------------------------------------------------------
%
% [Y1,Y2,Y3] = rgb_plane_proc(f,X,SE,p1,p2,p3)
%
% Input:
% ------
%  f - operator to apply
%  X - input image
%  SE - structuring element
%  p1,p2,p3 - other parameters
%
% Output:
% -------
%  Y1,Y2,Y3 - image outputs of operator

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
% check image
%--

if ((ndims(X) ~= 3) & (size(X,3) ~= 3))
	error('Input image is not an RGB image.');
end

%--
% allocate output
%--

switch (nargout)

	case (1)
		Y1 = zeros(size(X));
		
	case (2)
		Y1 = zeros(size(X));
		Y2 = zeros(size(X));
	
	case (3)
		Y1 = zeros(size(X));
		Y2 = zeros(size(X));
		Y3 = zeros(size(X));
		
end

%--
% apply operator plane by plane
%--

switch (nargin)

	case (3)
	
		SE = arg2cell(SE);
		
		switch (nargout)

			case (1)
				for k = 1:3
					Y1(:,:,k) = feval(f,X(:,:,k),SE{k});
				end
				
			case (2)
				for k = 1:3
					[Y1(:,:,k),Y2(:,:,k)] = feval(f,X(:,:,k),SE{k});
				end
			
			case (3)
				for k = 1:3
					[Y1(:,:,k),Y2(:,:,k),Y3(:,:,k)] = feval(f,X(:,:,k),SE{k});
				end
				
		end
		
	case (4)
	
		SE = arg2cell(SE);
		p1 = arg2cell(p1);
		
		switch (nargout)

			case (1)
				for k = 1:3
					Y1(:,:,k) = feval(f,X(:,:,k),SE{k},p1{k});
				end
				
			case (2)
				for k = 1:3
					[Y1(:,:,k),Y2(:,:,k)] = feval(f,X(:,:,k),SE{k},p1{k});
				end
			
			case (3)
				for k = 1:3
					[Y1(:,:,k),Y2(:,:,k),Y3(:,:,k)] = feval(f,X(:,:,k),SE{k},p1{k});
				end
				
		end
		
	case (5)
	
		SE = arg2cell(SE);
		p1 = arg2cell(p1);
		p2 = arg2cell(p2);
		
		switch (nargout)

			case (1)
				for k = 1:3
					Y1(:,:,k) = feval(f,X(:,:,k),SE{k},p1{k},p2{k});
				end
				
			case (2)
				for k = 1:3
					[Y1(:,:,k),Y2(:,:,k)] = feval(f,X(:,:,k),SE{k},p1{k},p2{k});
				end
			
			case (3)
				for k = 1:3
					[Y1(:,:,k),Y2(:,:,k),Y3(:,:,k)] = feval(f,X(:,:,k),SE{k},p1{k},p2{k});
				end
				
		end
		
	case (6)
	
		SE = arg2cell(SE);
		p1 = arg2cell(p1);
		p2 = arg2cell(p2);
		p3 = arg2cell(p3);
		
		switch (nargout)

			case (1)
				for k = 1:3
					Y1(:,:,k) = feval(f,X(:,:,k),SE{k},p1{k},p2{k},p3{k});
				end
				
			case (2)
				for k = 1:3
					[Y1(:,:,k),Y2(:,:,k)] = feval(f,X(:,:,k),SE{k},p1{k},p2{k},p3{k});
				end
			
			case (3)
				for k = 1:3
					[Y1(:,:,k),Y2(:,:,k),Y3(:,:,k)] = feval(f,X(:,:,k),SE{k},p1{k},p2{k},p3{k});
				end
				
		end

end


function Y = arg2cell(X)

%
% arg2cell - put argument into a length 3 cell array
% --------------------------------------------------
% 
% Y = arg2cell(X)
% 
% Input:
% ------
%  X - input argument
% 
% Output:
% -------
%  Y - length 3 cell array with repeated X
%

if (~iscell(X))
	for k = 1:3
		Y{k} = X;
	end
else
	if (length(X) == 3)
		Y = X;
	else
		for k = 1:3
			Y{k} = X;
		end
	end
end



