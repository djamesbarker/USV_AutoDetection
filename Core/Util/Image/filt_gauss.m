function [F,FD] = filt_gauss(sigma,theta,tol)

% filt_gauss - create gaussian filter masks
% -----------------------------------------
%
% [F,FD] = filt_gauss(sigma,theta,tol)
%
% Input:
% ------
%  sigma - standard deviation (def: 1)
%  theta - orientation angle (def: 0)
%  tol - relative filter value cutoff tolerance (def: 10^-1)
%
% Output:
% -------
%  F - normalized gaussian filter mask
%  FD - decomposed filter structure

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
% $Date: 2006-06-11 21:57:45 -0400 (Sun, 11 Jun 2006) $
% $Revision: 5223 $
%--------------------------------

% TODO: allow for simple generation of one dimensional filters

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set tolerance
%--

if ((nargin < 3) || isempty(tol))
	tol = 10^-1;
end

%--
% set orientation angle
%--

if ((nargin < 2) || isempty(theta))
    theta = 0;
end     

%--
% set standard deviation
%--

% NOTE: the units are pixels

if ((nargin < 1) || isempty(sigma))
    sigma = 1;
end

%--
% duplicate deviation
%--

if (length(sigma) == 1)
	sigma = [sigma, sigma]; 
end

%--------------------------------------------
% SEPARABLE FILTER MASK
%--------------------------------------------
	
% NOTE: create axis aligned evaluation grid

if ((~theta)  || (abs(diff(sigma)) < tol))
	
	%--
	% create grid
	%--
	
	px = (-4 * ceil(sigma(1))):(4 * ceil(sigma(1)));
	
	py = (-4 * ceil(sigma(2))):(4 * ceil(sigma(2)));
		
	%--
	% evaluate function separably
	%--
	
	Fx = exp(-(px.^2 ./ (2 * sigma(1)^2)));
	
	Fy = exp(-(py.^2 ./ (2 * sigma(2)^2)))';
	
	%--
	% tighten support
	%--
	
	% NOTE: compose, tighten, and normalize mask
	
	F = Fy * Fx; F = F ./ max(abs(F(:)));

	[m0,n0] = size(F);
	
	F = filt_tight(F,tol);
	
	F = F ./ sum(F(:));
	
	% NOTE: tighten and normalize separable filters
	
	[m,n] = size(F);
	
	xr = (m0 - m) / 2; yr = (n0 - n) / 2;
	
	Fx = Fx((1 + xr):(end - xr)); Fx = Fx ./ sum(Fx);
	
	Fy = Fy((1 + yr):(end - yr)); Fy = Fy ./ sum(Fy);
	
	%--
	% output filter pair
	%--
	
	% NOTE: could use filt_decomp, however this is more efficient
	
	FD.S = 1;
	
	FD.X = Fx;
	
	FD.Y = Fy;
	
	% NOTE: consider degenerate sigma values that lead to one dimensional filters
	
	if (isempty(Fx) || isempty(Fy))
		FD = [];
	end
	
%--------------------------------------------
% NON-SEPARABLE FILTER MASK
%--------------------------------------------

else
	
	%--
	% create axis-aligned grid
	%--
		
	% TODO: use trigonometry to tighten this
	
	N = ceil(max(sigma(1),sigma(2)));
	
	px = -(6 * N):(6 * N);
	
	py = -(6 * N):(6 * N);
	
	[X,Y] = meshgrid(px,py);
    
	%--
    % rotate grid
	%--
	
    A = [cos(theta), sin(theta); -sin(theta), cos(theta)];
    
    xy = [X(:)'; Y(:)'];
	
    xy = A * xy;
    
    X = reshape(xy(1,:), size(X));
	
    Y = reshape(xy(2,:), size(Y));

	%--
	% evaluate function on grid
	%--
	
	F = exp(-((X.^2 ./ (2*sigma(1)^2)) + (Y.^2 ./ (2*sigma(2)^2))));
	
	%--
	% tighten support
	%--
	
	% NOTE: largest absolute value is one. tight support operates on relative values
	
	F = F / max(abs(F(:)));
	
	F = filt_tight(F, tol);
		
	F = F / sum(F(:));
	
	% NOTE: output empty separable filter, could eventually use filt_decomp
	
	FD = [];

end 
