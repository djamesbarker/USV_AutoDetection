function [value, exts] = has_children(ext)

% has_children - check if extension has children
% ----------------------------------------------
%
% [value, exts] = has_children(ext)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  value - indicator
%  exts - children array

exts = get_extension_children(ext);

value = ~isempty(exts);

