function dev(varargin)

% dev - shortcut for 'develop_extension'
% --------------------------------------
%
% dev(ext), dev type name
%
% Input:
% ------
%  ext - extension
%  type - type
%  name - name
%
% NOTE: this shortcut function also clears the screen before display

clc; develop_extension(varargin{:});
