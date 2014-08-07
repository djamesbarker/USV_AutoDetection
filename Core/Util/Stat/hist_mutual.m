function I = hist_mutual(H)

% hist_mutual - compute variable mutual information
% -------------------------------------------------
%
% I = hist_mutual(H)
%
% Input:
% ------
%  H - joint histogram
%
% Output:
% -------
%  I - mutual information

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
% compute marginals and product histogram
%--

N = sum(H(:));
H = H / N;
			
h1 = sum(H,2);
h2 = sum(H,1);
			
H12 = h1*h2;

%--
% compute divergence of joint and product histograms
%--

I = hist_divergence(H,H12);
