function str = tukey_table(delta)

% tukey_table - create a table for the tukey biweight function
% ------------------------------------------------------------
%
% str = tukey_table(delta)
%
% Input:
% ------
%  delta - grid spacing for table
%
% Output:
% -------
%  str - string to be used as constant in C code

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
% $Revision: 1.0 $
% $Date: 2003-06-11 18:22:03-04 $
%--------------------------------

%--
% set default delta
%--

if ((nargin < 1) || isempty(delta))
	delta = 0.05;
end

%--
% compute function table values
%--

% NOTE: later compute error incurred from approximation

x = -1:delta:1;
y = (1 - x.^2).^2;
n = length(y);

%--
% convert table to string
%--

str = sprintf('double DELTA = %0.16f;\n\n',delta);
str = [str, sprintf('int OFFSET = %d;\n\n',floor(n/2))];
str = [str, sprintf(['double TUKEY_TABLE[' int2str(n) '] = {\n'])];
str = [str, sprintf('\t%0.16f,\n',y)];
str = [str, sprintf('};\n\n')];

