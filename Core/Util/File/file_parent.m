function par = file_parent(p,k)

% file_parent - get immediate parent directory
% --------------------------------------------
%
% par = file_parent(p,k)
%
% Input:
% ------
%  p - file path
%  k - levels to go up (def: 1)
%
% Output:
% -------
%  par - parent directory name

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
% $Revision: 698 $
% $Date: 2005-03-11 16:20:26 -0500 (Fri, 11 Mar 2005) $
%--------------------------------

%--
% set immediate parent default
%--

if (nargin < 2)
	k = 1;
end

%--
% compute parent directory
%--

% TODO: handle asking for too many levels, implement directly square complexity

for k = 1:k
	p = path_parts(p);
end

% NOTE: this gets the immediate parent

[ignore,par] = path_parts(p);
