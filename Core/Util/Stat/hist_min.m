function ix = hist_min(h,t)

% hist_min - find local minima of sequence
% -----------------------------------------
%
% ix = hist_min(h,t)
%
% Input:
% ------
%  h - histogram bin counts
%  t - threshold parameter
%
% Output:
% -------
%  ix - location of selected local minima

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
% $Date: 2003-09-16 01:32:06-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% get histogram length
%--

n = length(h);

%--
% compute minima
%--

% smaller than right and left condition

r = [h(1:n -1) < h(2:n), 0];
l = [0, h(1:n -1) > h(2:n)];

% locations where both conditions are met

ixm = find(r & l);

%--
% compute maxima
%--

% larger than right and left condition

r = [h(1:n -1) > h(2:n), 0];
l = [0, h(1:n -1) < h(2:n)];

% locations where both conditions are met

ixM = find(r & l);

%--
% remove spurious minima
%--

switch (length(ixm) - length(ixM))

	%--
	% more maxima
	%--
	
	case (-1)
	
		n = length(ixM);

		% small left and right difference of extreme values 
				
		r = (h(ixM(1:n - 1)) - h(ixm)) < t;
		l = (h(ixM(2:n)) - h(ixm)) < t;
		
		% locations where either condition is met
		
		ix = find(r | l);
		
		% delete minima
		
		ixm(ix) = [];

	%--
	% equal extrema
	%--
	
	case (0)

		% small left and right difference of extreme values
		
		r = (h(ixM(1:n - 1)) - h(ixm)) < t;
		l = (h(ixM(2:n)) - h(ixm)) < t
		
		% locations where either condition is met
		
		ix = find(r | l);
		
		% delete minima
		
		ixm(ix) = [];
		
	%--
	% more minima
	%--
	
	case (1)
	
		n = length(ixm);
		
		% small left and right difference of extreme values
				
		r = (h(ixM) - h(ixm(1:n - 1))) < t;
		l = (h(ixM) - h(ixm(2:n))) < t
		
		% locations where either condition is met
		
		ix = find(r | l);
		
		% delete minima
		
		ixm(ix) = [];

end

ix = ixm;
