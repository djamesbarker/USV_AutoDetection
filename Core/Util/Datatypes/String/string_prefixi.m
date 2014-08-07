function prefix = string_prefixi(varargin)

% string_prefixi - computation case-insensitive
% ---------------------------------------------
%
% prefix = string_prefixi(str1, ... , strk)
%
% Input:
% ------
%  str1, ... , strk - strings
%
% Output:
% -------
%  prefix - string

varargin = lower(varargin);

prefix = string_prefix(varargin{:});
