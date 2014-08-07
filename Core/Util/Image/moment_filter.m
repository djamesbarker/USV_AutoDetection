function [M,S2,G1,G2] = moment_filter(X,SE,Z,b)

% moment_filter - local moments and shape parameters
% --------------------------------------------------
% 
% [M,S2,G1,G2] = moment_filter(X,SE,Z,b)
%
% Input:
% ------
%  X - input image or handle to parent figure
%  SE - structuring element
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  M - mean image
%  S2 - variance image
%  G1 - skewness image
%  G2 - kurtosis image

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
% image or handle
%--

flag = 0;

if (ishandle(X))
    h = X;
    hi = get_image_handles(h);
    if (length(hi) == 1)
        X = get(hi,'cdata');
        flag = 1;
    else
        warning('Figure has more than one image. No computation performed.');
        return;
    end 
end

%--
% set boundary behavior
%--

if (nargin < 4)
	b = -1;
end

%--
% set mask
%--

if (nargin < 3)
	Z = [];
end

%--
% color image
%--

if (ndims(X) > 2)
	
	[r,c,s] = size(X);
	
	for k = 1:s
		[M(:,:,k),S2(:,:,k),G1(:,:,k),G2(:,:,k)] = moment_filter(X(:,:,k),SE,Z,b);
	end	
	
%--
% scalar image
%--

else

	%--
	% structuring element as matrix
	%--
		
	B = se_mat(SE);
	pq = se_supp(SE);
	
	%--
	% compute moment filter
	%--
	
	X = image_pad(X,pq,b);
	
	if (~isempty(Z))
		Z = image_pad(Z,pq,0);
	end
	
	[M,S2,G1,G2] = moment_filter_(X,uint8(B),uint8(Z));
	
end

% %--
% % display output
% %--
% 
% if (flag & view_output)
% 	switch(view_output)
% 	case (1)
%         figure(h);
%         set(hi,'cdata',Y);
% 		set(gca,'clim',fast_min_max(Y));
% 	otherwise
% 		fig;
% 		image_view(Y);
% 	end
% end
