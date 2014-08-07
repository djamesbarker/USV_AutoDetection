function [value, exts] = has_ancestors(ext)

% has_ancestors - check if extension has ancestors
% ------------------------------------------------
%
% [value, exts] = has_ancestors(ext)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  value - indicator
%  exts - ancestry array
%
% NOTE: the ancestry array starts with the input extension

exts = get_extension_ancestry(ext);

value = numel(exts) > 1;

