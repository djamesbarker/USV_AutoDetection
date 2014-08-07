function S = str_indent(T,n)

% str_indent - indent printf string
% ---------------------------------
%
% S = str_indent(T,n)
% 
% Input:
% ------
%  T - fprintf strings
%  n - number of levels to indent (def: 1)
% 
% Output:
% -------
%  S - indented fprintf strings

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
% $Date: 2003-07-06 13:36:09-04 $
%--------------------------------

%--
% set levels
%--

if (nargin < 2)
	n = 1;
end

%--
% put string in cell
%--

if (isstr(T))
	T = cellstr(T);
	flag = 1;
else
	flag = 0;
end

%--
% indent string using replace
%--

if (n > 1)

	s = [];
	for k = 1:n
		s = [s '\t'];
	end
	
	S = cell(size(T));
	for k = 1:length(T)
		S{k} = [s strrep(T{k},'\n',['\n' s])];
	end
	
else

	S = cell(size(T));
	for k = 1:length(T)
		S{k} = ['\t' strrep(T{k},'\n','\n\t')];
	end
	
end

%--
% output string
%--

if (flag)
	S = S{1};
end
