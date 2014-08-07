function str = replace_newlines(str, pat)

% replace_newlines - with specified string
% ----------------------------------------
%
% str = replace_newlines(str, pat)
%
% Input:
% ------
%  str - to consider
%  pat - to replace (def: '')
%
% Output:
% -------
%  str - result

if nargin < 2
	pat = '';
end

str = strrep(str, sprintf('\n'), pat);
