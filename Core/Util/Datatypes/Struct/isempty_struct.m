function [value, n] = isempty_struct(in)

% isempty_struct - check that a struct is empty or has no fields
% --------------------------------------------------------------
%
% [value, n] = isempty_struct(in)
%
% Input:
% ------
%  in - input struct
%
% Output:
% -------
%  value - result of test
%  n - number of elements in struct as array

value = isempty(in) || isempty(fieldnames(in));

if nargout > 1
	n = numel(in);
end
