function SE = se_comp(varargin)

% se_comp - compose structuring element
% -------------------------------------
% 
% SE = se_comp(SE1,SE2,..., SEn) 
%    = se_comp(SE1,n)
%
% Input:
% ------
%  SE1, ... ,SEn - structuring elements
%  n - iterations
%
% Output:
% -------
%  SE - composed structuring element

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
% compose structuring elements
%--

SE = varargin{1};
n = length(varargin);

for k = 2:n
	SE = se_comp_two(SE,varargin{k});			
end


%--
% SUBFUNCTION
%--

function SE = se_comp_two(SE1,SE2)

%--
% second argument is iterations
%--

if ((numel(SE2) == 1) && (SE2 > 1))
		
	SE = SE1;
	n = SE2;
		
	for k = 1:n-1
		SE = se_comp_two(SE,SE1);
	end

%--
% compose two structuring elements
%--

else
		
	SE1 = se_loose(SE1,se_supp(SE2));
	
	SE = morph_dilate(SE1,se_tr(SE2));
	
end

%--
% set output representation as SE1
%--

if (strcmp(se_rep(SE1),'vec'))
	SE = se_vec(SE);
end

