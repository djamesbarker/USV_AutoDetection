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

if ~string_is_member(op, ops)
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

	discard = zeros(1, length(str));

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
					discard(k) = 1;
				else
					score(k) = score(k) + length(ix);
				end

		end

	end

	str(logical(discard)) = [];

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
