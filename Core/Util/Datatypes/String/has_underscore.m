function result = has_underscore(str)

% has_underscore - test for underscore in string
% ----------------------------------------------
%
% result = has_underscore(str)
%
% Input:
% ------
%  str - string or cell array
%
% Output:
% -------
%  result - of test
%
% See also: has_space

result = has_character(str, '_');
