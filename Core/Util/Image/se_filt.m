function F = se_filt(SE)

% se_filt - supported difference filters decomposition
% ----------------------------------------------------
%
% F = se_filt(SE)
%

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

% Input:
% ------
%  SE - structuring element
%
% Output:
% -------
%  F - difference filters supported by SE

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% get displacement vectors
%--

V = se_vec(SE);

%--
% create finite difference filters
%--

for k = 1:size(V,1)
	
	v = abs(V(k,:)) + 1;
	
	f = zeros(2*abs(V(k,:)) + 1);
	f(v(1),v(2)) = -1;
	f(v(1) + V(k,1),v(2) + V(k,2)) = 1;
	
	F{k} = f;
	
end

for k = size(V,1):-1:1
	if (sum(abs(F{k})) == 1)
		F{k} = [];
	end
end
	

