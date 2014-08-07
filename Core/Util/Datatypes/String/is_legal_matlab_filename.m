function value = is_legal_matlab_filename(file)

% is_legal_matlab_filename - determine whether
%     candidate filename is legal in Matlab.
%     We are mostly concerned with '@' and '#'.
% --------------------------------------------
%
% value = is_legal_matlab_filename(file)
%
% Input:
% ------
%  file - candidate filename
%
% Output:
% -------
%  value - is legal or not

% These characters are allowed
legalchars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\-\ \_\.' ;

for k = 1:length(file)
	
	legal(k) = any((file(k) == legalchars));
	
end

value = all(legal);
