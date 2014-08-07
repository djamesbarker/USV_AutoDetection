function Y = morph_dilate(X,SE,n,b)

% morph_dilate - morphological dilation
% -------------------------------------
% 
% Y = morph_dilate(X,SE,n,b)
%   = morph_dilate(X,SE,Z,b)
%
% Input:
% ------
%  X - input image or handle to parent figure
%  SE - structuring element
%  n - iterations of operation (def: 1)
%  Z - computation mask image (def: [])
%  b - boundary behavior (def: -1)
%
% Output:
% -------
%  Y - dilated image

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% check for handle input
%--

[X, N, tag, flag, g, h] = handle_input(X,inputname(1));

%--
% set boundary behavior
%--

if (nargin < 4)
	b = -1;
end

%--
% iteration or mask
%--

if ((nargin < 3) | isempty(n))
	
	n = 1;
	Z = [];
	
else
	
	Z = [];
	
	switch (tag)
		
	case ({'IMAGE_GRAY','IMAGE_GRAY_U8'})
		[r,c] = size(X);		
		
	case ({'IMAGE_RGB','IMAGE_RGB_U8','IMAGE_NDIM','IMAGE_NDIM_U8'})
		[r,c,s] = size(X);
		
	case ('IMAGE_STACK')
		[r,c] = size(X{1});
		
	end
		
	if (all(size(n) == [r,c]))
		Z = n;
		n = 1;
	end
	
end

%--
% check for trivial processing
%--

% convert structuring element to matrix and check for scalar

if (length(se_mat(SE)) == 1)
	Y = X;
	return;
end 

%--
% process depending on image type
%--

switch (tag)
	
%--
% color and multi dimensional images
%--

case ({'IMAGE_RGB','IMAGE_RGB_U8','IMAGE_NDIM','IMAGE_NDIM_U8'})
	
	%--
	% plane by plane processing
	%--
	
	for k = 1:size(X,3)
			
		if (isempty(Z))
			Y(:,:,k) = morph_dilate(X(:,:,k),SE,n,b);
		else
			Y(:,:,k) = morph_dilate(X(:,:,k),SE,Z,b);
		end
				
	end
	
%--
% image stack
%--

case ('IMAGE_STACK')

	%--
	% plane by plane processing
	%--
	
	for k = 1:size(X,3)
			
		if (isempty(Z))
			Y(:,:,k) = morph_dilate(X(:,:,k),SE,n,b);
		else
			Y(:,:,k) = morph_dilate(X(:,:,k),SE,Z,b);
		end
				
	end
	
%--
% scalar image
%--

case ({'IMAGE_GRAY','IMAGE_GRAY_U8'})
	
	%--
	% decompose structuring element5
	%--
	
	SEQ = se_decomp(SE);
	
% 	speed_up = SEQ.ratio
	
% 	SEQ.ratio = 0; % turn off decomposition
	
	%--
	% use decomposed computation if worthwhile
	%--
	
	if (SEQ.ratio > 1.5)

		%--
		% iterate operator
		%--
		
		if (isempty(Z))
		
			for j = 1:n
				Y = dilate_decomp(X,SEQ,b);
				X = Y;	
			end
		
		%--
		% mask operator
		%--
		
		else

			Y = dilate_decomp(X,uint8(B),b,uint8(Z));
		
		end
		
	else
		
		%--
		% structuring element as matrix
		%--
			
		B = se_mat(SE);
		
		pq = se_supp(SE);
		
		%--
		% iterate operator
		%--
		
		if (isempty(Z))
		
			for j = 1:n
				X = image_pad(X,pq,b);
				Y = morph_dilate_(X,uint8(B));
				X = Y;	
			end
		
		%--
		% mask operator
		%--
		
		else
		
			X = image_pad(X,pq,b);
			Z = image_pad(Z,pq,0);
			Y = morph_dilate_(X,uint8(B),uint8(Z));
		
		end
		
	end
	
end

%--
% display output
%--

if (flag & view_output)
	
	switch(view_output)
		
	case (1)
		
        figure(h);
        set(g,'cdata',Y);
		set(gca,'clim',fast_min_max(Y));
		title_edit(['\Er \pb{' N '}']);
		
	otherwise
		fig;
		image_view(Y);
		title_edit(['\Er \pb{' N '}']);
		
	end
	
end


%----------------------------------------------
% DILATE_DECOMP
%----------------------------------------------

function Y = dilate_decomp(X,SEQ,b,Z)

% dilate_decomp - dilation using decomposed structuring element
% -------------------------------------------------------------
%
% Y = dilate_decomp(X,SEQ,b,Z)
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
%  Y - dilated image

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
	% dilate with first line if needed
	%--
	
	if (length(SEQ.line{1}) > 1)
		
		pq = se_supp(SEQ.line{1});
		
		Y = morph_dilate_( ...
			image_pad(X,pq,b), ...
			uint8(SEQ.line{1}) ...
		);
	
	else
		
		Y = X;
		
	end
	
	%--
	% dilate with second line if needed
	%--
	
	if (length(SEQ.line{2}) > 1)
		
		pq = se_supp(SEQ.line{2});
		
		Y = morph_dilate_( ...
			image_pad(Y,pq,b), ...
			uint8(SEQ.line{2}) ...
		);
	
	end
	
	%--
	% apply residual and compute maximum if needed
	%--
	
	if (~isempty(SEQ.rest))
		
		% the maximum function is deined for relevant input classes

		pq = se_supp(SEQ.rest);
		
		Y = max( ...
			Y, ...
			morph_dilate_( ...
				image_pad(X,pq,b), ...
				uint8(SEQ.rest) ...
			) ...
		);
	
	end

else
	
	%--
	% dilate with first line if needed
	%--
	
	if (length(SEQ.line{1}) > 1)
	
		pq = se_supp(SEQ.line{1});
		
		Y = morph_dilate_( ...
			image_pad(X,pq,b), ...
			uint8(SEQ.line{1}), ...
			uint8(image_pad(Z,pq,0)) ...
		);
	
	else
		
		Y = X;
		
	end
	
	%--
	% dilate with second line if needed
	%--
	
	if (length(SEQ.line{2}) > 1)
	
		pq = se_supp(SEQ.line{2});
		
		Y = morph_dilate_( ...
			image_pad(Y,pq,b), ...
			uint8(SEQ.line{2}), ...
			uint8(image_pad(Z,pq,0)) ...
		);
	
	end
	
	%--
	% apply residual and compute maximum if needed
	%-- 
	
	if (~isempty(SEQ.rest))
		
		% the maximum function is deined for relevant input classes
		
		pq = se_supp(SEQ.rest);
		
		Y = max( ...
			Y, ...
			morph_dilate_( ...
				image_pad(X,pq,b), ...
				uint8(SEQ.rest), ...
				uint8(image_pad(Z,pq,0)) ...
			) ...
		);
	
	end

end
	
