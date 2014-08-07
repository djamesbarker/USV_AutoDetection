function Y = mask_gray_color(X,Z,opt)

% mask_gray_color - create colored grayscale mask
% -----------------------------------------------
%
% opt = mask_gray_color
%
%   Y = mask_gray_color(X,Z,opt)
%
% Input:
% ------
%  X - input image
%  Z - mask image
%  opt - mask display options
%
% Output:
% -------
%  opt - default mask display options
%  Y - masked image for display

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

%--------------------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------------------

%--
% set default display options
%--

if ((nargin < 3) || isempty(opt))
	
	%--
	% color and alpha for mask
	%--
		
	opt.color = [0, 1, 1];
	
	opt.mode = 'normal';

	opt.alpha = 0.2;

	%--
	% boundary display options
	%--
	
	opt.boundary.on = 1;			% values are {-1, 0, 1}, meaning 'dark', 'off', and 'bright'

	opt.boundary.type = 1;			% values are {-1, 0, 1}, meaning 'inner', 'symmetric', and 'outer'
		
	opt.boundary.anti_alias = 1;	% this is a binary flag
	
	%--
	% output options if needed
	%--
	
	if (~nargin)
		Y = opt; return;
	end
	
end

%--------------------------------------------------------------
% CREATE COLOR MASK IMAGE
%--------------------------------------------------------------

%-------------------------------------
% GRAYSCALE INPUT
%-------------------------------------

% NOTE: this is old code and it's on the way out

if (ndims(X) < 3)

	%--
	% convert mask color to HSV
	%--

	h = rgb_to_hsv(opt.color);
	
	%--
	% allocate HSV image
	%--
	
	[m,n] = size(X);
	
	H = zeros(m,n,3);
	
	%--
	% set hue
	%--
	
	H(:,:,1) = h(1) * double(Z);
	
	%--
	% set saturation
	%--
	
	% TODO: is this a reasonable use of alpha or should it be renamed?
	
	H(:,:,2) = opt.alpha * h(2) * double(Z);
	
	%--
	% set value
	%--
	
	if (opt.boundary.on)
		X = create_mask_border(X,Z,opt);
	end
	
	H(:,:,3) = X;
	
	%--
	% convert to RGB
	%--

	Y = hsv_to_rgb(H);

	Y = lut_range(Y,[0,1]);

%-------------------------------------
% RGB INPUT
%-------------------------------------

else

	%--
	% set output as rescaled input
	%--
	
	Y = lut_range(X,[0,1]);
		
	%--
	% select mask indices
	%--
	
	if (opt.alpha)
		ix = find(Z); 
	else
		ix = [];
	end
	
	%--
	% select boundary indices
	%--
	
	if (opt.boundary.on)

% 		B = morph_gradient(Z,ones(3),opt.boundary.type);
		
		B = fast_boundary(Z,opt.boundary.type);
		
		
		if (opt.boundary.anti_alias)
			
			alpha = 0.065;
			F = alpha * ones(3); F(2,2) = 1 - 8 * alpha;
			
			B = linear_filter(B,F);
			
		end

		ixb = find(B); W = double(B(ixb));
	
	else
		
		ixb = [];
		
	end
	
	%--
	% return input if there are no indices to update
	%--
	
	if (isempty(ix) && isempty(ixb))
		return;
	end
		
	%--
	% select plane mask values to modify
	%--
		
	% NOTE: the problem here is related to the 'info_mp3' function not
	% reporting the right number of frames, this needs to be fixed
	
	for k = 1:3	
		
% 		disp(' ');
% 		disp(['k = ', int2str(k)]); 
% 		disp(['|ix| = ', int2str(numel(ix))]);
% 		disp(['|ixb| = ', int2str(numel(ixb))]);
		
		Yk = Y(:,:,k);
		
		if (~isempty(ix))
			U(:,k) = Yk(ix);
		end
		
		if (~isempty(ixb))
			UB(:,k) = Yk(ixb);
		end
		
	end
	
	%--
	% update mask values according to mode
	%--
	
	if (~isempty(ix))
		
		switch (opt.mode)

			%--
			% darken or lighten
			%--

			% NOTE: update mask locations when the masking color is darker or brighter

			case ({'darken','lighten'})

				%--
				% select mask pixels to udpate
				%--

				if (strcmp(mode,'lighten'))
					ixu = sum(U,2) <= sum(opt.color);
				else 
					ixu = sum(U,2) >= sum(opt.color);
				end

				ixu = find(ixu);

				%--
				% update mask pixels if needed
				%--

				% NOTE: how the mode and the alpha are used independently

				n = length(ixu);

				if (n)
					a = opt.alpha;
					U(ixu,:) = (1 - a) * U(ixu,:) + repmat(a * opt.color,n,1);
				end	

			%--
			% dissolve
			%--

			% NOTE: mask pixels are subselected, the mask is thinned

			% TODO: add a parameter for the dissolve mode

			case ('dissolve')

				ixu = find(rand(length(ix),1) > 0.1);

				n = length(ixu);

				if (n)
					a = opt.alpha;
					U(ixu,:) = (1 - a) * U(ixu,:) + repmat(a * opt.color,n,1);
				end	

			%--
			% normal
			%--

			% NOTE: update all mask pixels, only the alpha value is used

			case ('normal')

				n = length(ix);

				a = opt.alpha;

				U = (1 - a) * U + repmat(a * opt.color,n,1);

		end
		
	end
	
	%--
	% update planes
	%--
	
	for k = 1:3	
		
		Yk = Y(:,:,k);
		
		if (~isempty(ix))
			Yk(ix) = U(:,k);
		end
	
		% TODO: add a boundary color parameter
		
		if (~isempty(ixb))
			
			% NOTE: this produces 'glowing edges'
			
			Yk(ixb) = (1 - W) .* Yk(ixb) + W .* repmat((3 + opt.color(k)) / 4,length(ixb),1);
			
			% NOTE: this produces a full opacity boundary in the mask color
			
% 			Yk(ixb) = (1 - W) .* Yk(ixb) + W .* repmat(opt.color(k),length(ixb),1);
			
		end
		
		Y(:,:,k) = Yk;	
		
	end
		
end

%--
% display results
%--

if (~nargout)

	fig; image_view(Y); 
	
	title(['MODE: ', upper(opt.mode) ', ALPHA: ' num2str(opt.alpha)]);
	
end

%----------------------------------------------------------
% CREATE_MASK
%----------------------------------------------------------

function B = create_mask_border(X,Z,opt)

% create_mask_border
% ------------------

if (opt.highlight)
		
	%--
	% compute mask boundary pixels and scale
	%--

	if (opt.highlight > 0)
		s = 225;
	else
		s = 30;
	end

	B = s * morph_gradient(Z,ones(3),opt.bound);

	%--
	% anti-alias mask
	%--

	if (opt.anti_alias)		
		B = linear_filter(B,filt_binomial(3,3));
	end

	%--
	% overlay mask
	%--

	% NOTE: applying the max operation globaly does not seem correct 
	
	X = lut_range(X);
	
end



%----------------------------------------------------------
% FAST_BOUNDARY
%----------------------------------------------------------

function B = fast_boundary(Z,type);

%--
% get rectangle corners
%--

[i,j] = find(Z);

i = fast_min_max(i);

j = fast_min_max(j);

%--
% create boundary image
%--

B = zeros(size(Z));

% switch (type)
% 	
% 	% internal boundary
% 	
% 	case (-1) 
		
		% vertical lines
		B(i(1) + 1:i(2) - 1,j(1) + 1) = 1;
		B(i(1) + 1:i(2) - 1,j(2) - 1) = 1;
		
		% horizontal lines
		B(i(1) + 1,j(1):j(1) + 1) = 1;
		B(i(2) - 1,j(1):j(2) - 1) = 1;
% 		
% 	case (0)
% 		
% 	case (1)
% 		
% end
