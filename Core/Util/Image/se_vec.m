function SE = se_vec(SE)

% se_vec - displacement vector representation of structuring element
% ------------------------------------------------------------------
% 
% V = se_vec(SE)
%
% Input:
% ------
%  SE - structuring element
%
% Output:
% -------
%  V - displacement vector representation

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
% check input representation type
%--

rep = se_rep(SE);

if isempty(rep)
	error('Input is not a structuring element.');
end

%--
% return if no conversion is needed
%--

if strcmp(rep, 'vec')
	return;
end

%----------------------------
% CONVERT
%----------------------------

% NOTE: structuring element is represented as matrix

%--
% compute center
%--

c = se_supp(SE) + 1;

%--
% compute displacement vectors
%--

[i, j] = find(SE); 

SE = [(i(:) - c(1)), (j(:) - c(2))];






