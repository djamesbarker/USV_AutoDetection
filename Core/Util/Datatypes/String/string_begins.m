function value = string_begins(str, pat, n)

% string_begins - indicate if string begins with pattern
% ------------------------------------------------------
%
% value = string_begins(str, pat)
%
% Input:
% ------
%  str - string or string cell array
%  pat - pattern
%
% Output:
% -------
%  value - indicator
%
% See also: string_contains, string_ends

% NOTE: using this approach this function returns a logical vector rather than indices

% NOTE: we get length of pattern if needed to streamline iteration

if nargin < 3
	n = numel(pat);
end

%--
% check for occurence of pattern and indicate
%--

% NOTE: with cell arrays we handle multiple strings

% TODO: update to use 'strcmp' and selection like 'string_ends'

if iscell(str)
	value = false(size(str));
	
	for k = 1:numel(str)
		value(k) = strncmp(str{k}, pat, n);
	end	
else
	value = strncmp(pat, str, n);
end
