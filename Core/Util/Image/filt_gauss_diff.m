function F = filt_gauss_diff(s,t,d,tol)

% filt_gauss_diff - create difference of gaussians filters
% --------------------------------------------------------
%
% F = filt_gauss_diff(s,t,d,tol)
%
% Input:
% ------
%  s - standard deviation (def: 1)
%  t - orientation angle (def: 0)
%  d - displacement in x (def: 4 times deviation)
%  tol - filter value tolerance (def: 10^-4)
%
% Output:
% -------
%  F - gaussian filter

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
% $Date: 2004-12-21 19:10:44 -0500 (Tue, 21 Dec 2004) $
% $Revision: 335 $
%--------------------------------

%--
% set tolerance
%--

if (nargin < 4)
	tol = 10^-4;
end

%--
% set orientation angle
%--

if ((nargin < 2) || isempty(t))
    t = 0;
end         

%--
% set standard deviation
%--
 
if ((nargin < 1) || isempty(s))
    s = 1;
end

%--
% set displacement
%--

if ((nargin < 3) || isempty(d))
	if (isstruct(s))
		d = 4*s.x;
	else
		d = 4*s;
	end
end

%--
% compute according to type of deviation
%--

% separate deviation for x and y

if (isstruct(s))
	
	%--
	% create normal grid
	%--
	
	if (~t)
		
		% create grid
			
		px = -(3*ceil(s.x) + d):3*ceil(s.x);
		py = -3*ceil(s.y):3*ceil(s.y);
		
		[X,Y] = meshgrid(px,py);

	%--
	% create rotated grid
	%--
	
	else
		
		% create grid
			
		tmp = max(s.x + d,s.y);
		
		px = -4*tmp:4*tmp;
		py = -4*tmp:4*tmp;
		
		[X,Y] = meshgrid(px,py);
        
        % create rotation matrix

        A = [cos(t), sin(t); -sin(t), cos(t)];
        
        % vectorize positions and rotate
        
        xy = [X(:)'; Y(:)'];
        xy = A*xy;
        
        % reshape positions
        
        X = reshape(xy(1,:),size(X));
        Y = reshape(xy(2,:),size(Y));

	end 
	
	%--
	% evaluate function on grid
	%--
	
	% consider using other normalization
	
	% F = -(1 / (sqrt(2*pi) * sqrt(s.x*s.y) * s.x^2)) * X .* (exp(-((X.^2 ./ (2*s.x^2)) + (Y.^2 ./ (2*s.y^2)))));
	
	F = (1 / (sqrt(2*pi) * sqrt(s.x*s.y))) * ...
		(exp(-((X.^2 ./ (2*s.x^2)) + (Y.^2 ./ (2*s.y^2)))) - exp(-(((X + d).^2 ./ (2*s.x^2)) + (Y.^2 ./ (2*s.y^2)))));
	
% single deviation for x and y

else
	
	%--
	% create normal grid
	%--
		
	if (~t)
		
		% create grid
		
		p = -(3*ceil(s) + d):3*ceil(s);
		
		[X,Y] = meshgrid(p,p);

	%--
	% create rotated grid
	%--
	
	else
		
		% create grid

		p = -(4*ceil(s) + d):(4*ceil(s) + d);
		
		[X,Y] = meshgrid(p,p);
		
        % create rotation matrix

		A = [cos(t), sin(t); -sin(t), cos(t)];
        
        % vectorize positions and rotate
        
        xy = [X(:)'; Y(:)'];
        xy = A*xy;
        
        % reshape positions
        
        X = reshape(xy(1,:),size(X));
        Y = reshape(xy(2,:),size(Y));
		
	end 
	
	%--
	% evaluate function on grid
	%--

	% consider using other normalization
	
	% F = -(1 / (sqrt(2*pi) * s^3)) * X .* (exp(-(X.^2 + Y.^2) ./ (2 * s^2)));
	
	F = (1 / (sqrt(2*pi) * s)) * ...
		(exp(-(X.^2 + Y.^2) ./ (2*s^2)) - exp(-((X + d).^2 + Y.^2) ./ (2*s^2)));
	
end
	
%--
% compute value based tight support filter
%--

F = filt_tight(F,tol);
