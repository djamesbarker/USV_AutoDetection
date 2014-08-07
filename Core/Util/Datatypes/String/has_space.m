function result = has_space(str)

% has_space - test for presence of space in string
% ------------------------------------------------
%
% result = has_space(str)
%
% Input:
% ------
%  str - string or cell array of strings
%
% Output:
% -------
%  result - of test

result = has_character(str, ' ');
