function C = image_corr(Y, X, opt)

% image_corr - correlation image computation
% ------------------------------------------
%
% opt = image_corr
%
%   C = image_corr(Y, X, opt)
%
% Input:
% ------
%  Y - template image
%  X - input image
%  opt - image correlation options
%
% Output:
% -------
%  opt - default image correlation options
%  C - correlation image

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

% TODO: check for opportunities to use sparse filtering or FFT filtering

% TODO: extend linear filter to handle multiple templates simultaneoulsly

%----------------------------------------------
% HANDLE INPUT
%----------------------------------------------

%--
% set or output default options
%--

if (nargin < 3) || isempty(opt)
	
	%--
	% create default options
	%--
	
	% NOTE: padding options are: row padding, column padding, and boudary behavior
	
	opt.pad_row = 1;
	
	opt.pad_col = 1;
	
	opt.pad_bnd = -1;
	
	% NOTE: correlation options are: normalization and template masking
	
	opt.norm = 1;
	
	opt.mask = 1;
	
	%--
	% output default options
	%--
	
	if ~nargin
		C = opt; return;
	end
	
end

%----------------------------------------------
% PAD INPUT IMAGE
%----------------------------------------------

%--
% compute row and column padding
%--

p = 0;

if opt.pad_row
	
	p = (size(Y,1) - 1) / 2;	

	if floor(p) ~= p
		error('Only odd sized templates are supported.');
	end
	
end

q = 0;

if opt.pad_col
	
	q = (size(Y,2) - 1) / 2;	

	if floor(q) ~= q
		error('Only odd sized templates are supported.');
	end
	
end

%--
% pad image if needed
%--

if (p || q)
	X = image_pad(X, [p, q], opt.pad_bnd);
end

%----------------------------------------------
% COMPUTE CORRELATION
%----------------------------------------------

%--
% center and normalize template image if normalized correlation
%--

if opt.norm
	
	%--
	% set mean to 0
	%--
	
	c = mean(Y(:));

	if c > eps
		Y = Y - c;
	end

	%--
	% set norm to 1
	%--
	
	s = sqrt(sum(Y(:).^2));

	if abs(s - 1) > eps
		Y = Y ./ s;
	end
	
end

%--
% compute correlation
%--

% NOTE: we use low level linear filter and padding was applied before

C = linear_filter_(X, Y);

%--
% normalize correlation
%--

if opt.norm
	
	% NOTE: fast box normalization does not work when masking

	%--
	% compute masked normalization
	%--
	
	if opt.mask
		
		% NOTE: only non-zero locations in template are used in normalization
		
		Y = double(abs(Y) > eps);  n = sum(Y(:));
		
		N = linear_filter_(X.^2, Y) - (1/n) * linear_filter_(X, Y);
		
	%--
	% compute box normalization
	%--
	
	else
		
		% NOTE: the rectangular support of the filter is used in normalization
		
		n = numel(Y);
		
		N = box_filter(X.^2, Y, 0, 0) - (1/n) * box_filter(X, Y, 0, 0);
		
	end

	N = sqrt(N);
	
	%--
	% normalize correlation
	%--
	
	C = C ./ N;
	
end




