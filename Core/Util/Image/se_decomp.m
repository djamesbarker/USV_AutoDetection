function SEQ = se_decomp(SE)

% se_decomp - support and difference decomposition
% ------------------------------------------------
%
% SEQ = se_decomp(SE)
%
% Input:
% ------
%  SE - structuring element
%
% Output:
% -------
%  SEQ - decomposition structure

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
% get max inscribed rectangle 
%--

[p,q] = max_rectangle(SE);

%--
% decompose structuring element
%--

% rectangle is further decomposed as lines

% NOTE: output the longest line first for efficiency in min max computation

if (p > q)
	S = {ones(2*p + 1,1), ones(1,2*q + 1)};
else
	S = {ones(1,2*q + 1), ones(2*p + 1,1)};
end

% the residual is considered arbitrary

R = se_diff(SE,ones(2*p + 1,2*q + 1));

%--
% evaluate cost of decomposition
%--

% the cost of two morphological operations

cost = (2*p + 1) + (2*q + 1);

% the cost of an additional morphological operation with a comparison

if (~isempty(R))
	cost = cost + se_size(R) + 1;
end

speed = se_size(SE) / cost;

%--
% pack output into structure
%--

SEQ.SE = SE;

SEQ.line = S;
SEQ.rest = R;

SEQ.cost = cost;
SEQ.ratio = speed;

%------------------------------------------------
% MAX_RECTANGLE
%------------------------------------------------

function [p,q] = max_rectangle(SE)

%--
% get support of structuring element
%--

[pi,qi] = se_supp(SE);

%--
% consider line input
%--

if (pi == 0)
	p = 0;
else
	p = pi;
end

if (qi == 0)
	q = 0;
else
	q = qi;
end

if (min(pi,qi) == 0)
	return;
end
	
%--
% create rectangle matrix
%--

A = 0;
r = pi + 1; c = qi + 1;

for k = 1:qi
for j = 1:pi
	
	%--
	% check that all entries in this rectangle are filled
	%--
	
	if (all(SE((r - j):(r + j),(c - k):(c + k))))
		
		% compute the area of the rectangle
		
		a = (2*j + 1) * (2*k + 1);
			
		% update the max support rectangle if the area is larger
		
		if (a > A)
			A = a;
			p = j; q = k;
		end
		
	end
	
end 
end
