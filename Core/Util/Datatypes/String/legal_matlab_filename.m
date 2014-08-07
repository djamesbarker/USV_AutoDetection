function lfile = legal_matlab_filename(file, replacement)

% legal_matlab_filename - replaces illegal file
%     name characters with an underscore.
%     We are mostly concerned with '@' and '#'.
% --------------------------------------------
%
% lf = legal_matlab_filename(filename)
%
% Input:
% ------
%  file - candidate filename
%  replacement - replacement charater, default '_';
%
% Output:
% -------
%  lfile - legal filename

% Default replacement
if nargin < 2, replacement = '_'; end

% These characters are allowed
legalchars = 'a-zA-Z0-9\-\ \_\.' ;

% Replace every illegal character
lfile = regexprep(file,['[^' legalchars ']'], replacement)
