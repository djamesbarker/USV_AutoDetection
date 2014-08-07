function value = is_scalar_struct(X)

% is_scalar_struct - check for scalar struct input
% ------------------------------------------------
%
% value = is_scalar_struct(X)
%
% Input:
% ------
%  X - candidate
%
% Output:
% -------
%  value - scalar struct indicator

value = isstruct(X) && (numel(X) == 1);
