function SE = se_mat(SE)

% se_mat - matrix representation of structuring element
% -----------------------------------------------------
% 
% B = se_mat(SE)
%
% Input:
% ------
%  SE - structuring element
%
% Output:
% -------
%  B - matrix representation

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
% $Date: 2006-06-06 17:29:13 -0400 (Tue, 06 Jun 2006) $
% $Revision: 5169 $
%--------------------------------

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% check representation
%--

rep = se_rep(SE);

if isempty(rep)
	error('Input is not a structuring element.');
end

%--
% return if no conversion is needed
%--

if strcmp(rep, 'mat')
	return;
end

%----------------------------
% CONVERT
%----------------------------

% NOTE: structuring element is represented as displacement vectors

V = SE; 

%--
% get support and set center
%--

pq = se_supp(SE);

c = pq + 1;

%--
% fill structuring element matrix
%--

SE = zeros(2 * pq + 1);

for k = 1:size(V,1)
	SE(V(k,1) + c(1), V(k,2) + c(2)) = 1;
end


