function [P,x,y,A] = gmm_image(mix,x,y)

% gmm_image - evaluate mixture model on a grid
% --------------------------------------------
%
% [P,x,y,A] = gmm_image(mix,x,y)
%
% Input:
% ------
%  mix - mixture model to evaluate 
%  x - grid points in x
%  y - grid points in y
%
% Output:
% -------
%  P - mixture model values
%  x - grid points in x
%  y - grid points in y
%  A - component activations

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%--------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------

%--
% set y grid if needed
%--

if ((nargin < 3) || isempty(y))
	
	%--
	% compute required grid points based on covariance type
	%--

	% NOTE: look at the gaussian filter function for the rotation code

	switch (mix.covar_type)

		%--
		% spherical covariance
		%--
		
		case ('spherical')
			y = [ ...
				min(mix.centres(:,2) - 4 * mix.covars'), ...
				max(mix.centres(:,2) + 4 * mix.covars') ...
			];

		%--
		% diagonal covariance
		%--
		
		case ('diag')
			y = [ ...
				min(mix.centres(:,2) - 4 * mix.covars(:,2)), ...
				max(mix.centres(:,2) + 4 * mix.covars(:,2)) ...
			];

		%--
		% full covariance
		%--
		
		case ('full')
			
			% NOTE: currently this computes a largest simple estimate
			
			for k = 1:mix.ncentres
				D(:,k) = eig(mix.covars(:,:,k));
			end
			
			d = max(D,[],1)'; % note the transpose
						
			y = [ ...
				min(mix.centres(:,2) - 4 * d), ...
				max(mix.centres(:,2) + 4 * d) ...
			];
			
		case ('ppca')

		otherwise

	end

	%--
	% compute grid based on default resolution
	%--

	y = y(1):0.025:y(2);
	
end

ny = length(y);

%--
% set x grid if needed
%--

if ((nargin < 2) || isempty(x))
	
	%--
	% compute required grid points based on covariance type
	%--

	switch (mix.covar_type)

		%--
		% spherical covariance
		%--
		
		case ('spherical')
			
			x = [ ...
				min(mix.centres(:,1) - 4 * mix.covars'), ...
				max(mix.centres(:,1) + 4 * mix.covars') ...
			];
		
		%--
		% diagonal covariance
		%--
		
		case ('diag')
			
			x = [ ...
				min(mix.centres(:,1) - 4 * mix.covars(:,1)), ...
				max(mix.centres(:,1) + 4 * mix.covars(:,1)) ...
			];

		%--
		% full covariance
		%--
		
		case ('full')

			% NOTE: currently this computes a largest simple estimate
			
			for k = 1:mix.ncentres
				D(:,k) = eig(mix.covars(:,:,k));
			end
			
			d = max(D,[],1)'; % note the transpose
						
			x = [ ...
				min(mix.centres(:,1) - 4 * d), ...
				max(mix.centres(:,1) + 4 * d) ...
			];
			
		case ('ppca')

		otherwise

	end

	%--
	% compute grid based on default resolution
	%--

	x = x(1):0.025:x(2);

end
	
nx = length(x);
	
%--------------------------------------------------
% EVALUATE MIXTURE MODEL
%--------------------------------------------------

%--
% create and pack grid
%--

[X,Y] = meshgrid(x,y);

X = [X(:),Y(:)];

%--
% evaluate mixture on grid
%--

if (nargout < 4)
	P = gmmprob(mix,X);
else
	[P,B] = gmmprob(mix,X);
end

%--
% reshape mixture probabilities
%--

P = reshape(P,ny,nx);

%--
% reshape activations if needed
%--

if (nargout > 3)
	
	% NOTE: 'n' is simply the number of components

	n = size(B,2); 
	
	A = zeros(ny,nx,n);

	for k = 1:size(B,2)
		A(:,:,k) = reshape(B(:,k),ny,nx); 
	end
	
end

