function str = str_line(n, marker)

% str_line - create a line using a marker string
% ----------------------------------------------
%
% str = str_line(n, marker)
%
% Input:
% ------
%  n - length of line
%  marker - character to use as marker (def: '-')
%
% Output:
% -------
%  str - marker line string

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

% TODO: modify this function to produce comment lines

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set default marker
%--

if (nargin < 2) || isempty(marker)
	marker = '-';
end

% NOTE: we only use the first character

marker = marker(1);

%--
% get length from string if needed
%--

if ischar(n)
	n = length(n);
end
	
%--
% handle multiple inputs recursively
%--

if numel(n) > 1

	str = cell(size(n)); 

	for k = 1:numel(n)
		str{k} = str_line(n(k), marker);
	end
	
	return;

end

%-----------------------------------
% CREATE MARKER LINE
%-----------------------------------

%--
% use char double conversion and matrix multiplication to create char line
%--

str = char(double(marker) * ones(1,n));

%--
% display string if no output requested
%--

if ~nargout
	disp(str);
end
