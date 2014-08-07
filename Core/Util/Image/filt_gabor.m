function F = filt_gabor(sigma, theta, omega, tol)

% filt_gabor - create gabor filters
% ---------------------------------
%
% F = filt_gabor(sigma, theta, omega, tol)
%
% Input:
% ------
%  sigma - standard deviation (def: 1)
%  theta - orientation angle (def: 0)
%  omega - normalized frequency
%  tol - relative filter value cutoff tolerance (def: 10^-1)
%
% Output:
% -------
%  F - normalized gabor filter mask

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
% $Revision: 5223 $
% $Date: 2006-06-11 21:57:45 -0400 (Sun, 11 Jun 2006) $
%--------------------------------

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set tolerance
%--

if ((nargin < 4) | isempty(tol))
	tol = 10^-1;
end

%--
% set orientation angle
%--

if ((nargin < 2) | isempty(theta))
    theta = 0;
end     

%--
% set standard deviation
%--
 
if ((nargin < 1) | isempty(sigma))
    sigma = 1;
end

%--
% duplicate deviation
%--

if (length(sigma) == 1)
	sigma = [sigma, sigma];
end

%--------------------------------------------
% COMPUTE FILTER MASK
%--------------------------------------------

%--
% create axis aligned evaluation grid
%--

if (~theta)
	
	%--
	% create grid
	%--
		
	px = -3*ceil(sigma(1)):3*ceil(sigma(1));
	
	py = -3*ceil(sigma(2)):3*ceil(sigma(2));
	
	[X,Y] = meshgrid(px, py);

%--
% create rotated evaluation grid
%--

else
	
	%--
	% create grid
	%--
		
	tmp = max(sigma(1), sigma(2));
	
	px = -4*tmp:4*tmp;
	
	py = -4*tmp:4*tmp;
	
	[X,Y] = meshgrid(px, py);
    
	%--
	% rotate grid
	%--
	
    % create rotation matrix

    A = [cos(theta), sin(theta); -sin(theta), cos(theta)];
    
    % vectorize positions and rotate
    
    xy = [X(:)'; Y(:)'];
	
    xy = A * xy;
    
    % reshape positions
    
    X = reshape(xy(1,:), size(X));
	
    Y = reshape(xy(2,:), size(Y));

end 

%--
% evaluate function on grid
%--

F = exp(-((X.^2 ./ (2*sigma(1)^2)) + (Y.^2 ./ (2*sigma(2)^2)))) .* cos((2*pi) * (omega / sigma(1)) * X);

%--
% normalize mask
%--

F = F / max(abs(F(:)));
	
%--
% tighten filter support
%--

F = filt_tight(F, tol);

%--
% euclidean normalization
%--

% is this the right normalization ?

F = F / sqrt(sum(F(:).^2));
