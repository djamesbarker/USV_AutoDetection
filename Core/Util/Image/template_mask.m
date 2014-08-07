function [Y,Z] = template_mask(X,opt)

% template_mask - mask template
% -----------------------------
%
% [Y,Z] = template_mask(X,opt)
%
% Input:
% ------
%  X - input template
%  opt - masking options
%
% Output:
% -------
%  Y - masked template
%  Z - computed mask

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
% $Revision: 516 $
% $Date: 2005-02-10 19:49:33 -0500 (Thu, 10 Feb 2005) $
%--------------------------------

%----------------------------
% HANDLE INPUT
%----------------------------

if ((nargin < 2) || isempty(opt))
	
	%--
	% set default options
	%--
	
	opt.blur = 3;			% length of binomial filter used for smoothing
	
	opt.percentile = 0.75;	% percentile value to use as threshold
	
	opt.open = 2.1;			% radius of opening structuring element
	
	%--
	% output default options
	%--
	
	if (~nargin)
		Y = opt;
		return;
	end
	
end

%----------------------------
% MASK TEMPLATE
%----------------------------

%--
% blur image using binomial filter
%--

% NOTE: non-linear blurring could also be used

if (opt.blur)
	Y = linear_filter(X,filt_binomial(opt.blur,opt.blur));
else
	Y = X;
end

%--
% compute percentile threshold and mask
%--

if (opt.percentile > 0)
	T = fast_rank(Y,opt.percentile);
else
	T = Y;
end

Z = uint8(Y > T);

%--
% close resulting mask
%--

if (opt.open)
	Z = morph_open(Z,se_ball(opt.open));
end

%--
% mask template
%--

Z = double(Z);

Y = X .* Z;

%----------------------------
% DISPLAY RESULTS
%----------------------------

if (~nargout)

	fig; image_view(Y);
	
	fig; image_view(Z);
	
end
