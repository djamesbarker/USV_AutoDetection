function F = filt_normalize(F,p)

% filt_normalize - update filter normalization
% --------------------------------------------
%
% F = filt_normalize(F,p)
%
% Input:
% ------
%  F - filter decomposition structure
%  p - norm index (def: 1)
%
% Output:
% -------
%  F - filter with updated normalization

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
% set default normalization
%--

if (nargin < 2)
	p = 1;
end

%--
% configure for no normalization
%--

if ((nargin > 1) && (p == 0))
	
	F.normalize = 0;
	F.c = 1;
	return;
	
end

%--
% update normalization and constant
%--

F.normalize = p;

Hk = filt_comp(F,F.rank);

switch (p)
	
	case (1)
		F.c = 1/sum(Hk(:));
		
	case (2)
		F.c = 1/sqrt(sum(Hk(:).^2));
		
	case (inf)
		F.c = 1/max(Hk(:));
		
	otherwise
		F.c = 1/norm(Hk(:),p);
		
end
		
		
