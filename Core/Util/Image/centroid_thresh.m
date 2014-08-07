function T = centroid_thresh(X,tol)

% centroid_thresh - iterative centroid computation threshold
% ----------------------------------------------------------
%
% T = centroid_thresh(X,tol)
%
% Input:
% ------
%  X - image to compute threshold for
%  tol - convergence tolerance
%
% Output:
% -------
%  T - threshold

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

% NOTE: this is a specialized implementation of K-means for K = 2

%--
% set default tolerance
%--

if ((nargin < 2) || isempty(tol))
	tol = 0.5;
end

%--
% initial estimate is midrange
%--

T = 0.5 * sum(fast_min_max(X));

%--
% iterate until convergence
%--

done = false;

while (~done)
	
	%--
	% update threshold estimate
	%--
	
	Z = (X >= T);
	Tn = 0.5 * (mean(X(Z)) + mean(X(~Z)));

	%--
	% test for convergence
	%--
	
	done = (abs(T - Tn) < tol);
	T = Tn;

end

%--
% display results
%--

if (~nargout)
	
	%--
	% compute otsu's threshold for comparison
	%--
	
	TO = graythresh(X);
		
	%--
	% compute histogram
	%--
	
	[h,c] = hist_1d(X,101);
	
	%--
	% display results on top of semilogy histogram
	%--
	
	fig;

	plot(c,h,'b-o');
	hold on;
	plot([T, T],fast_min_max(h) + 1,'r-o');
	plot([TO, TO],fast_min_max(h) + 1,'g-o');
	
	set(gca,'yscale','log');
	
	%--
	% display image results
	%--
	
	% NOTE: the hypothesis that the two methods typically provide similar results is false
	
	if (ndims(X) == 2)
	
		fig; 
		image_view(X > T);
		image_view(X .* double(X > T));
		title('Centroid Threshold');
		refresh;
		
		fig; 
		image_view(X > TO);
		image_view(X .* double(X > TO));
		title('Otsu''s Threshold');
		refresh;
		
	end
	
end
