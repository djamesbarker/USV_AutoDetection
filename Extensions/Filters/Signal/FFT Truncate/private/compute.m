function [X, context] = compute(X, parameter, context)

% FFT_TRUNCATE - compute

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

%---------------------------------
% PARAMETER
%---------------------------------

n = 512;

p = 0.02; q = 1 - p;

%---------------------------------
% PROCESS
%---------------------------------

%--
% pad samples for framing
%--

[N, ch] = size(X);

if rem(N, n)
	X = [X; zeros(n - rem(N, n), ch)];
end

N2 = size(X, 1);

%--
% process channels
%--

Y = zeros(size(X));

for k = 1:ch
	
	%--
	% get frames and transform to frequency
	%--
	
	Z = fft(reshape(X(:, k), n, N2/n));
	
	%--
	% process frames
	%--
	
	for j = 1:(N2/n)
		Z(:,j) = truncate(Z(:, j), q);
	end
	
	%--
	% transform to samples and undo framing
	%--
	
	Y(:,k) = vec(ifft(Z));
	
end

%--
% remove pad samples
%--

X = Y(1:N, :);


%--------------------------------------
% TRUNCATE
%--------------------------------------

function X = truncate(X, q)

% NOTE: full complex sort is much slower, we don't need phase

[ignore, ix] = sort(abs(X));

% TODO: check for extreme index computations

n = ceil(q * length(X));

X(ix(1:n)) = 0; 


%--------------------------------------
% THRESHOLD
%--------------------------------------

function X = threshold(X, t)

X(abs(X) < t) = 0;


