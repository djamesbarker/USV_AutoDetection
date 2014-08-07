function [Y,N] = image_noise(X,t,p)

% image_noise - add noise to image
% --------------------------------
%
% [Y,N] = image_noise(X,t,p)
%
% Input:
% ------
%  X - input image
%  t - type of noise
%  p - parameters for noise
%
%    'Gaussian' - additive Gaussian noise, standard deviation
%    'Exponential' or 'Laplacian' - additive exponential noise, mean
%    'Uniform' or 'Impulsive' - impulsive uniformly distributed noise, intensity
%
% Output:
% -------
%  Y - noise corrupted image
%  N - noise image

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

%    'salt_pepper' - impulsive min and max, p = intensity

%--
% output available noise types
%--

if (nargin < 1)
	
	Y = { ...
		'Gaussian', ...
		'Laplacian', ...
		'Uniform', ...
		'Salt and Pepper' ...
	};

	return;
	
end

%--
% coerce double image and get range
%--

X = double(X);

b = fast_min_max(X);

%--
% compute according to type
%--

switch (lower(t))

%--
% gaussian
%--

case ('Gaussian')

	%--
	% create noise
	%--
	
	N = p*randn(size(X));
	
	%--
	% add noise
	%--
	
	Y = X + N;

%--	
% exponential
%--

case ({'Laplacian'})

	%--
	% create noise
	%--
	
	N = -p * log(rand(size(X)));
	
	%--
	% add noise
	%--
	
	Y = X + N;

%--
% uniform
%--

case ({'Uniform'})

	%--
	% compute corrupt pixel indexes and values
	%--
	
	n = prod(size(X));
	f = round(p*n);
	ix = round(n*rand(1,f));
	
	b = fast_min_max(X);
	r = rand(1,f);
	x = b(1).*r + b(2).*(1 - r);

	%--
	% create noise
	%--
	
	N = zeros(size(X));
	N(ix) = x;
	
	%--
	% replace pixels
	%--
	
	Y = X;
	Y(ix) = x;
	
%--
% salt and pepper
%--

case ('Salt and Pepper')

	%--
	% compute corrupt pixel indexes and values
	%--
	
	n = prod(size(X));
	f = round(p*n);
	ix = round(n*rand(1,f));
	
	b = fast_min_max(X);
	r = round(rand(1,f));
	x = b(1).*r + b(2).*(1 - r);
	
	%--
	% create noise
	%--
	
	N = zeros(size(X));
	N(ix) = x;
	
	%--
	% replace pixels
	%--
	
	Y = X;
	Y(ix) = x;
	
%--
% unknown noise type
%--
	
otherwise
	
	disp(' ');
	error('Unknown noise type.');
		
end
		
%--
% clip noisy image values to initial range
%--

% this means that the distribution is not precisely gaussian or laplacian
% when that is the case depending on the distribution of values in the
% image

Y = image_clip(Y);
		

