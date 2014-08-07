function SE1 = se_loose(SE,d)

% se_loose - increase support of structuring element
% --------------------------------------------------
%
% SE1 = se_loose(SE,d)
%
% Input:
% ------
%  SE - structuring element
%  d - support increment
%
% Output:
% -------
%  SE1 - larger support structuring element 

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
% set increment
%--

if (length(d) == 1)
	d = [d d];
end

%--
% get support of input SE
%--

[p,q] = se_supp(SE);

%--
% create SE with larger support
%--

Zr = zeros(d(1),2*q + 1 + 2*d(2));
Zc = zeros(2*p + 1,d(2));

SE1 = [Zr; Zc, se_mat(SE), Zc; Zr];
	
