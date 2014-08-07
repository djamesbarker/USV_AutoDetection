function pat = parse_pattern(str)

% parse_pattern - parse pattern search string
% -------------------------------------------
%
% pat = parse_pattern(str)
%
% Input:
% ------
%  str - pattern string
%  
% Output:
% -------
%  pat - parsed pattern array

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
% $Revision: 1131 $
% $Date: 2005-06-20 12:26:20 -0400 (Mon, 20 Jun 2005) $
%--------------------------------

% NOTE: another possible thing to consider is parentheses

% NOTE: another possible thing to consider is the parsing of units

%---------------------------------------------------
% PRE-PROCESS PATTERN STRING
%---------------------------------------------------
 
%--
% remove leading and trailing blanks
%--

str = fliplr(deblank(fliplr(deblank(str))));

% NOTE: check for empty pattern for quick return

if (isempty(str))
	pat = cell(0);
	return;
end

%--
% convert comparison operators to token form
%--

% NOTE: here we generate the atomic interval strings

str = regexprep(str,'\s<\s','__LT__');
str = regexprep(str,'\s>\s','__GT__');

str = regexprep(str,'\s<=\s','__LE__');
str = regexprep(str,'\s>=\s','__GE__');

%--
% convert logical connectives to token form
%--

% NOTE: the space that permits later tokenization

str = regexprep(str,'\s*,\s*',' __AND__ ');
str = regexprep(str,'\s*&\s*',' __AND__ ')

%---------------------------------------------------
% SPLIT INTO ATOMIC PATTERNS AND CONNECTIVES
%---------------------------------------------------

ix = findstr(str,' ');

if (isempty(ix))
	
	%--
	% put atomic pattern in cell
	%--
	
	pat = {str};
	
else
	
	%--
	% check for all blank pattern
	%--
	
	if (length(ix) == length(str))
		return;
	end
	
	%--
	% split pattern into atomic patterns
	%--
	
	ix = [0 ix length(str) + 1];

	for k = 1:length(ix) - 1
		pat{k} = str((ix(k) + 1):(ix(k + 1) - 1));
	end
	
	%--
	% remove empty patterns corresponding to blanks
	%--
	
	for k = length(pat):-1:1
		if (isempty(pat{k}))
			pat(k) = [];
		end
	end
	
end
