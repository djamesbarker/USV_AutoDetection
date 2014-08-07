function F = filt_gauss_der(s,t,d,tol)

% filt_gauss_der - create gaussian derivative filters
% ---------------------------------------------------
%
% F = filt_gauss_der(s,t,d,tol)
%
% Input:
% ------
%  s - standard deviation (def: 1)
%  t - orientation angle (def: 0)
%  d - derivative type (def: 'x')
%  tol - filter value tolerance (def: 10^-1)
%
% Output:
% -------
%  F - gaussian derivative filter

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% set tolerance
%--

if (nargin < 4)
	tol = 10^-1;
end

%--
% set derivative type
%--

if ((nargin < 3) | isempty(d))
	d = 'x';
end

%--
% set orientation angle
%--

if ((nargin < 2) | isempty(t))
    t = 0;
end     

%--
% set standard deviation
%--
 
if ((nargin < 1) | isempty(s))
    s = 1;
end

%--
% compute according to type of deviation
%--

% separate deviation for x and y

if (length(s) == 2)
	
	%--
	% create normal grid
	%--
	
	if (~t)
		
		% create grid
			
		px = -3*ceil(s(1)):3*ceil(s(1));
		py = -3*ceil(s(2)):3*ceil(s(2));
		
		[X,Y] = meshgrid(px,py);

	%--
	% create rotated grid
	%--
	
	else
		
		% create grid
			
		tmp = max(s(1),s(2));
		
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
	
	% compute depending on derivative type
	
	switch (d)
		
	case ('x')
		F = -X .* (exp(-((X.^2 ./ (2*s(1)^2)) + (Y.^2 ./ (2*s(2)^2)))));
		
	case ('y')
		F = -Y .* (exp(-((X.^2 ./ (2*s(1)^2)) + (Y.^2 ./ (2*s(2)^2)))));
		
	case ('xy')
		F = Y.* X .* (exp(-((X.^2 ./ (2*s(1)^2)) + (Y.^2 ./ (2*s(2)^2)))));
		
	end
	
	% normalize so that largest absolute value is one, this makes the
	% tight support clipping operate on relative element values
		
	F = F / max(abs(F(:)));
	
% single deviation for x and y

else
	
	%--
	% create normal grid
	%--
		
	if (~t)
		
		% create grid
		
		p = -3*ceil(s):3*ceil(s);
		
		[X,Y] = meshgrid(p,p);

	%--
	% create rotated grid
	%--
	
	else
		
		% create grid
		
		p = -4*ceil(s):4*ceil(s);
		
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

	% compute denpending on derivative type
	
	switch (d)
		
	case ('x')
		F = -X .* (exp(-(X.^2 + Y.^2) ./ (2 * s^2)));
		
	case ('y')
		F = -Y .* (exp(-(X.^2 + Y.^2) ./ (2 * s^2)));
		
	case ('xy')
		F = Y .* X .* (exp(-(X.^2 + Y.^2) ./ (2 * s^2)));
		
	end 
	
	% normalize so that largest absolute value is one, this makes the
	% tight support clipping operate on relative element values
	
	F = F / max(abs(F(:)));
	
end
	
%--
% compute value based tight support filter
%--

F = filt_tight(F,tol);

%--
% euclidean normalization
%--

F = F / sqrt(sum(F(:).^2));
