function [code, total, functions] = lines_of_code(file)

% lines_of_code - count total lines and lines of code in an M-file
% ----------------------------------------------------------------
%
% [code, total, functions] = lines_of_code(file)
%
% Input:
% ------
%  file - file
%
% Output:
% -------
%  code - lines of code
%  total - total lines
%  functions - number of functions

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

% TODO: we should not need to read the file twice

%--
% configure readers
%--

opt1 = file_readlines; opt1.skip = 1;

opt2 = opt1; opt2.pre = '%';

%--
% get lines of code
%--

total = file_readlines(file, @strtrim, opt1);
	
code = file_readlines(total, @strtrim, opt2);

functions = 0;

% NOTE: handle extended lines to avoid multiple count

for k = length(code):-1:1
	
	% NOTE: this should not be required
	
	if isempty(code{k})
		code(k) = [];
	end
	
	if ~isempty(strmatch('function ', code{k}))
		functions = functions + 1;
	end 
	
	if (length(code{k}) > 3) && strcmp(code{k}(end - 2:end), '...')
		code(k) = [];
	end

end

%--
% reduce to count
%--

code = length(code); total = length(total); 
