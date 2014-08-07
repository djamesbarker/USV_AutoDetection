function [pat,cap] = split_pattern(str)

% split_pattern - split pattern string into tokens
% ------------------------------------------------
%
% [pat,cap] = split_pattern(str)
%
% Input:
% ------
%  str - pattern string
%
% Output:
% -------
%  pat - pattern token array
%  cap - pattern capitalization

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% NOTE: the string is broken into quoted and space separated tokens

%-----------------------------------
% CHECK PATTERN STRING
%-----------------------------------

%--
% remove insignificant whitespace
%--

str = strtrim(str);

% NOTE: return empty if there is not pattern string

if (isempty(str))	
	pat = cell(0); cap = []; return;
end

%--
% check for quoted segments
%--

ix = findstr(str,'"');

% NOTE: return empty for misquoted string or if we contain '$'

% NOTE: '$' is not allowed, it is used to join quoted segments

if (mod(numel(ix),2) || ~isempty(findstr(str,'$')))
	pat = cell(0); cap = []; return;
end

%-----------------------------------
% SPLIT STRING INTO PATTERNS
%-----------------------------------

%--
% modify quoted segments so that we can perform space based split
%--

for k = 1:2:numel(ix) - 1
	str(ix(k):ix(k + 1)) = strrep(str(ix(k):ix(k + 1)),' ','$');
end

%--
% split pattern into simple patterns
%--

ix = findstr(str,' ');

if (isempty(ix))
	
	%--
	% put atomic pattern in cell
	%--
	
	pat = {str};
	
else
	
	%--
	% split pattern into atomic patterns
	%--
	
	ix = [0, ix, length(str) + 1];

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

%--
% clean up quoted patterns
%--

% NOTE: we simply remove the quotes and convert the '$' back to space

for k = 1:length(pat)
	
	if (pat{k}(1) == '"')
		pat{k} = strrep(pat{k}(2:end - 1),'$',' ');
	end
	
end

%--
% report on pattern capitalization
%--

if (nargout > 1)
	
	cap = zeros(size(pat));
	
	for k = 1:length(pat)
		cap(k) = ~strcmp(pat{k},lower(pat{k}));
	end
	
end
