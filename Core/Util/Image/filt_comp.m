function H = filt_comp(F,k)

% filt_comp - compose filter from decomposition
% ---------------------------------------------
%
% H = filt_comp(F,k)
%
% Input:
% ------
%  F - filter decomposition structure
%  k - order of approximation (def: 0, full composition)
%
% Output:
% -------
%  H - filter mask

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
% $Revision: 335 $
% $Date: 2004-12-21 19:10:44 -0500 (Tue, 21 Dec 2004) $
%--------------------------------

%--
% set rank of approximation
%--

if (nargin < 2)
	k = 0;
end

%--
% check rank of approximation
%--

if (k > 0)
	if (k > length(F.S))
		k = 0;
	end
end

%--
% compute full or partial synthesis
%--

% NOTE: there is no need to compose full filter since the mask is stored

if (k == 0)
	H = F.H;
% 	H = F.Y * diag(F.S) * F.X';
else
	H = F.Y(:,1:k) * diag(F.S(1:k)) * F.X(:,1:k)';	
end
