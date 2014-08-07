function SE = new_se_ball(r,p,t)


%------------------------------------------
% HANDLE INPUT 
%------------------------------------------

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
% set rotation angle
%--

if ((nargin < 3) | isempty(t))
	t = 0;
end

%--
% set exponent
%--

if ((nargin < 2) | isempty(p))
	p = 2;
end

%--
% set radius
%--

if ((nargin < 1) | isempty(r))
	r = [3,3];
else
	if (length(r) == 1)
		r = [r, r];
	end
end

%------------------------------------------
% EVALUATE BALL INDICATOR
%------------------------------------------

%--
% create evaluation grid
%--

R = 2*max(ceil(r));

n = 2*R + 1;

X = repmat(-R:R,[n,1]);

Y = flipud(X');

%--
% rotate grid if needed
%--

if (t ~= 0)
	
	A = [cos(-t) -sin(-t); sin(-t) cos(-t)];
	
	tmp = A * [X(:)'; Y(:)'];
	
	X = reshape(tmp(1,:),n,n);
	
	Y = reshape(tmp(2,:),n,n);
	
end

%--
% evalute axis aligned function
%--

SE = (abs(X./r(1)).^p + abs(Y./r(2)).^p).^(1/p) <= 1;

SE = double(SE);

%--
% tighten result
%--

SE = se_tight(SE);
