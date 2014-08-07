function H = hist_entropy(A,d)

% hist_entropy - compute entropy of histogram
% -------------------------------------------
%
% H = hist_entropy(A,d)
%
% Input:
% ------
%  A - distribution matrix
%  d - dimension to compute entropy along
%
% Output:
% -------
%  H - matrix entropy

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
% $Date: 2005-12-15 13:52:40 -0500 (Thu, 15 Dec 2005) $
% $Revision: 2304 $
%--------------------------------

%--
% consider for the moment vectors and matrices
%--

[m,n] = size(A);

%--
% vector computation
%--

if ((m == 1) | (n == 1))
	
	%--
	% normalize histogram if needed
	%--
	
	S = sum(A(:));
	if (s ~= 1)
		A = A / S;
	end
	
	%--
	% ensure vector is positive
	%--
	
	low = min(A(:));
	
	if (low < 0)
		A = A - low;
	end
	
	%--
	% remove zero bins
	%--
	
	A = A(find(A > 0));
	
	%--
	% compute entropy
	%--
	
	H = -1 * sum(A.*log2(A));
	
%--
% matrix computation
%--

else
	
	%--
	% set dimension if needed
	%--
	
	% default is compute along columns
	
	if ((nargin < 2) | isempty(d))
		d = 1; 
	end
	
	%--
	% ensure matrix is positive
	%--
	
	low = min(A(:));
	
	if (low < 0)
		A = A - low;
	end
	
	%--
	% compute according to dimension
	%--
	
	switch (d)
		
		case (1)
			
			%--
			% normalize columns if needed
			%--
			
			S = sum(A,1);
			
			if (any(S) ~= 1)
				A = A * diag(S);
			end
			
			%--
			% compute entropy (handle zero bins)
			%--
			
			B = A;
			B(find(B == 0)) = 1;
			
			H = -1 * sum(A .* log2(B),1);
			
		case (2)
			
			%--
			% normalize rows if needed
			%--
			
			S = sum(A,2);
			
			if (any(S ~= 1))
				A = diag(S) * A;
			end
			
			%--
			% compute entropy (handle zero bins)
			%--
			
			B = A;
			B(find(B == 0)) = 1;
			
			H = -1 * sum(A .* log2(B),2);
			
	end
	
end

% it would be interesting to make the concentration of energy at higher
% frequencies more surprising, and hence give it more value in the
% computation of the 


