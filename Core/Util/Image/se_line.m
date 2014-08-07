function SE = se_line(v,n)

% se_line - line structuring element
% ----------------------------------
% 
% SE = se_line(v)
%    = se_line(v,n)
%
% Input:
% ------
%  v - direction vector
%  n - periodic length 
%
% Output:
% -------
%  SE - structuring element

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
% compute according to type
%--

switch (nargin)

	%--
	% bressenham line
	%--
	
	case (1)
	
		v = v(:)';
		s = round([linspace(0,v(1))' linspace(0,v(2))']);
		SE = unique(s,'rows');
	
	%--
	% periodic line
	%--
	
	case (2)
	
		v = v(:)';
		SE = [0 0; diag(1:(n - 1))*repmat(v,(n - 1),1)];
		
end
