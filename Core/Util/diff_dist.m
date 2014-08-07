function d = diff_dist(A, type, parameter)

% diff_dist - distance of adjacent columns
% ----------------------------------------
%
% d = diff_dist(A, type, parameter)
%
% Input:
% ------
%  A - array to compute distances for
%  type - n
%  param - parameters for distance

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
% handle input
%--

if (nargin < 2) || isempty(type)
	type = 2;
end

%--
% compute distance based on type
%--

if ~ischar(type)
	
	%-------------------------
	% P-NORM
	%-------------------------
	
	% TODO: consider the infinity norm separately
	
	d = sum(abs(diff(A, 1, 2)).^type, 1).^(1 / type);
	
else
	
	disp(type); 
	
	switch type
	
		case 'subspace', d = subspace(A);
			
		case 'pearson', d = pearson(A);
			
		%-------------------------
		% MAHALANOBIS
		%-------------------------
	
		% NOTE: this is euclidean with non-trivial covariance
		
		case 'mahalanobis'
			
			if trivial(parameter)
				d = diff_dist(A, 2); return;
			end
		
		%-------------------------
		% PEARSON AND FOOTE
		%-------------------------
		
		% NOTE: these are based on normalized correlation with and without centering of the vectors
	
		case {'pearson', 'foote'}
			
			%--
			% normalize dimension
			%--
			
			rows = size(A, 1); 
			
			if strcmp(type, 'pearson')
				A = A - repmat(sum(A, 1) / rows, rows, 1);
			end
			
			A = A ./ repmat(sqrt(sum(A.^2, 1)), rows, 1);
			
			%--
			% compute distance
			%--
			
			d = abs(sum(A(:, 1:end - 1) .* A(:, 2:end), 1));
		
		%-------------------------
		% KL AND MODIFIED-KL
		%-------------------------
	
		% NOTE: the following two are based on more or less on information divergence
		
		% NOTE: these are not symmetric in time!
		
		case {'kl','kullback', 'mkl', 'modified-kullback'}
			
			%--
			% check for positive input
			%--
			
			if any(A < 0)
				error('To use information distance, input array must be positive.');
			end
			
			%--
			% normalize dimension
			%--
			
			rows = size(A, 1);
			
			A = A ./ repmat(sum(A, 1), rows, 1);
			
			%--
			% compute log odds, also known as surprise
			%--
			
			surprise = log2(A(:, 2:end) ./ A(:, 1:end - 1));
			
			%--
			% combine log odds based on type
			%--
			
			switch type
				
				case {'kl','kullback'}
					d = sum(A(:, 2:end) .* surprise, 1);
						
				case {'mkl', 'modified-kullback'}
					d = sum(surprise .* (surprise > 0), 1);
			end
			
	end
	
end


%-------------------------------
% DISTANCE FUNCTIONS
%-------------------------------

%---------------
% SUBSPACE
%---------------

function d = subspace(X)

N = sqrt(sum(X.^2, 1)); C = sum(X(:, 1:end - 1) .* X(:, 2:end), 1) ./ (N(1:end - 1) .* N(2:end));

D = X(:, 2:end) - X(:, 1:end - 1) * diag(C);

d = sqrt(sum(D.^2, 1));


%---------------
% EUCLIDEAN
%---------------

function d = euclidean(X)

d = sqrt(sum((X(2:end) - X(1:end - 1)).^2, 1));


%---------------
% PNORM
%---------------

function d = pnorm(X, p)

if nargin < 2
	p = 1;
end

d = sum(abs(X(:,2:end) - X(1:end - 1)).^p, 1).^(1 / p);


%---------------
% PEARSON
%---------------

function d = pearson(X)

X = normalize(X);

d = 1 - abs(sum(X(:, 1:end - 1) .* X(:, 2:end), 1));


%-------------------------------
% HELPERS
%-------------------------------

%---------------
% NORMALIZE
%---------------

function X = normalize(X, d)

if nargin < 2
	d = 1;
end

count = size(X, d); repeat = [1, 1]; repeat(d) = count;

X = X - repmat(sum(X, d) / count, repeat);

X = X * diag(1 ./ sqrt(sum(X.^2, 1)));


%---------------
% PROJECT
%---------------

function [X, R, Q] = project(X, Q, orthogonal)

if nargin < 3
	orthogonal = 0;
end

% NOTE: this function performs rank reduction

if ~orthogonal
	Q = orth(Q);
end 
	
if nargout < 2
	X = Q * (Q' * X);
else
	Y = Q * (Q' * X); R = X - Y; X = Y;
end


