function [y, val, flag] = spline_fit_image(X, n, tag)

%--
% setup objective computation
%--

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

[rows, cols] = size(X);

imx = linspace(1, n, cols); imy = 0:(rows - 1);

spline_y = ones(1, n + 2)*(rows / 2); 

% NOTE: normalizing image seems to help the optimization

X = X ./ (ones(size(X,1),1) * sum(X,1));

X = X ./ max(X(:));

%--
% fit spline
%--

[y, val, flag] = fminsearch(@(y) distance(X, imx, imy, y), spline_y);

%--
% display editable result if needed
%--

if ~nargout || (nargin > 2)
	
	im.x = imx; im.y = imy; im.c = X;
	
	spline_sandbox(y, im, tag);

end


%-------------------------------
% OBJECTIVE_FUN
%-------------------------------

% NOTE: this uses the component spectrogram image

function d = distance(X, imx, imy, spy)

N = length(imx);

%--
% evaluate spline
%--

[ignore, yp] = spline_eval(spy, [], N);

%--
% compute error function
%--

d = 0;

for j = 1:N
	d = d + sqrt(sum((yp(j) - imy).^2 .* X(:, j)'));
end


