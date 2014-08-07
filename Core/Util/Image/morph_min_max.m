function [YE,YD] = morph_min_max(X,SE,Z,b)

% morph_min_max - simultaneous erosion and dilation
% -------------------------------------------------
% 
% [YE,YD] = morph_min_max(X,SE,Z)
%
% Input:
% ------
%  X - input image
%  SE - structuring element
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  YE - eroded image
%  YD - dilated image

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
		[YE(:,:,k),YD(:,:,k)] = morph_min_max(X(:,:,k),SE,Z,b);
	end	
	
%--
% scalar image
%--

else
	
	%--
	% structuring element
	%--
		
	B = se_mat(SE);
	pq = se_supp(SE);
		
	%--
	% full operator
	%--
	
	if (isempty(Z))
	
		X = image_pad(X,pq,b);
		[YE,YD] = morph_min_max_(X,uint8(B));
		
	%--
	% masked operator
	%--
	
	else
	
		X = image_pad(X,pq,b);
		Z = image_pad(Z,pq,0);
		[YE,YD] = morph_min_max_(X,uint8(B),uint8(Z));
	
	end
	
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

%----------------------------------------------
% MIN_MAX_DECOMP
%----------------------------------------------

function [YE,YD] = min_max_decomp(X,SEQ,b,Z)

% min_max_decomp - erosion and dilation using decomposed structuring element
% --------------------------------------------------------------------------
%
% [YE,YD] = min_max_decomp(X,SEQ,b,Z)
%
% Input:
% ------
%  X - input image
%  SEQ - decomposed structuring element
%  b - boundary condition flag
%  Z - computation mask
%
% Output:
% -------
%  YE - eroded image
%  YD - dilated image

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%--
% compute according to mask
%--

if (isempty(Z))
	
	%--
	% erode and dilate with first line if needed
	%--
	
	% NOTE: this is the step that incurrs in the min max gain
	
	if (length(SEQ.line{1}) > 1)
		
		pq = se_supp(SEQ.line{1});
		
		[YE,YD] = morph_min_max_( ...
			image_pad(X,pq,b), ...
			uint8(SEQ.line{1}) ...
		);
	
	else
		
		YE = X;
		YD = X;
		
	end
	
	%--
	% erode and dilate with second line if needed
	%--
	
	if (length(SEQ.line{2}) > 1)
		
		pq = se_supp(SEQ.line{2});
		
		YE = morph_erode_( ...
			image_pad(YE,pq,b), ...
			uint8(SEQ.line{2}) ...
		);
	
		YD = morph_dilate_( ...
			image_pad(YD,pq,b), ...
			uint8(SEQ.line{2}) ...
		);
	
	end
	
	%--
	% apply residual and compute minimum and maximum if needed
	%--
	
	if (~isempty(SEQ.rest))
		
		% NOTE: the min and max functions is defined for relevant input classes

		pq = se_supp(SEQ.rest);
		
		YE = min( ...
			YE, ...
			morph_erode_( ...
				image_pad(X,pq,b), ...
				uint8(SEQ.rest) ...
			) ...
		);
	
		YD = max( ...
			YD, ...
			morph_dilate_( ...
				image_pad(X,pq,b), ...
				uint8(SEQ.rest) ...
			) ...
		);
	
	end

else
	
	%--
	% erode with first line if needed
	%--
	
	if (length(SEQ.line{1}) > 1)
	
		pq = se_supp(SEQ.line{1});
		
		Y = morph_erode_( ...
			image_pad(X,pq,b), ...
			uint8(SEQ.line{1}), ...
			uint8(image_pad(Z,pq,0)) ...
		);
	
	else
		
		Y = X;
		
	end
	
	%--
	% erode with second line if needed
	%--
	
	if (length(SEQ.line{2}) > 1)
	
		pq = se_supp(SEQ.line{2});
		
		Y = morph_erode_( ...
			image_pad(Y,pq,b), ...
			uint8(SEQ.line{2}), ...
			uint8(image_pad(Z,pq,0)) ...
		);
	
	end
	
	%--
	% apply residual and compute minimum if needed
	%-- 
	
	if (~isempty(SEQ.rest))
		
		% the minimum function is deined for relevant input classes
		
		pq = se_supp(SEQ.rest);
		
		Y = min( ...
			Y, ...
			morph_erode_( ...
				image_pad(X,pq,b), ...
				uint8(SEQ.rest), ...
				uint8(image_pad(Z,pq,0)) ...
			) ...
		);
	
	end

end
	
