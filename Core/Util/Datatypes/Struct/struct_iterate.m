function out = struct_iterate(varargin)

% struct_iterate - iterate over fields of struct and struct array
% ---------------------------------------------------------------
%
% out = struct_iterate(value, fun)
%
% Input:
% ------
%  value - struct array
%  fun - callback function
%
% Output:
% -------
%  out - result of calling function on every struct field

out = iterate_struct(varargin{:});
