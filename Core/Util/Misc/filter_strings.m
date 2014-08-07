function [str, pat, score] = filter_strings(str, pat, logic)

% filter_strings - filter strings based on a pattern
% --------------------------------------------------
%
% [str, pat, score] = filter_strings(str, pat, logic)
%
% Input:
% ------
%  str - strings to filter
%  pat - patterns used to filter strings
%  logic - logic used to combine patterns 'and' or 'or' (def: 'and')
%
% Output:
% -------
%  str - filtered strings
%  pat - deblanked pattern string, useful in testing for empty pattern
%  score - string scores

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
% $Revision: 6184 $
% $Date: 2006-08-16 19:53:20 -0400 (Wed, 16 Aug 2006) $
%--------------------------------

% TODO: refactor so that we may output indices

%-----------------------------------
% HANDLE INPUT
%-----------------------------------
 
%--
% set default logic for multiple patterns
%--

if (nargin < 3) || isempty(logic)
	logic = 'and';
end

%--
% check default logic
%--

% NOTE: consider whether 'xor' would be useful or intuitive

ops = {'and', 'or'}; op = lower(logic);

if ~ismember(op, ops)
	error(['Unrecognized logic ''', op, ''' for pattern combination.']);
end

%--
% return if there is nothing to filter
%--

if isempty(str)
	score = []; return;
end

%-----------------------------------
% FILTER STRINGS USING PATTERN
%-----------------------------------

%--
% split pattern and get capitalization of patterns
%--

[pat, cap] = split_pattern(pat);

%--
% parse pattern tokens if possible
%--

% NOTE: this may not go into this function, but a more specific function

% TODO: allow for a mini-language for selection

% NOTE: compute a simple match score which may be used by other applications

%--
% initialize filter scores
%--

score = zeros(1, length(str));

%--
% filter strings while looping over patterns
%--

for i = 1:length(pat)

	%--
	% loop over strings in reverse
	%--

	for k = length(str):-1:1

		%--
		% check string for pattern ocurrences
		%--
		
		% NOTE: consider capitalization if the pattern contains capitals

		if cap(i)
			ix = strfind(str{k}, pat{i});
		else
			ix = strfind(lower(str{k}), pat{i});
		end
						
		%--
		% update score and possibly strings depending on logic
		%--
		
		% NOTE: ocurrences add up, discard under 'and' if we miss pattern
		
		switch op

			case 'or'	
				
				score(k) = score(k) + length(ix);
			
			case 'and'
				
				if isempty(ix)
					str(k) = [];
				else
					score(k) = score(k) + length(ix);
				end
				
		end

	end

end

%--
% select strings based on score
%--

% NOTE: this is only needed in the 'or' case

if strcmpi(op, 'or')

	for k = length(str):-1:1
		if (score(k) == 0)
			str(k) = [];
		end
	end

end

% NOTE: sorting of strings using score is not done here
