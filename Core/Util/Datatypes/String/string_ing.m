function str = string_ing(str)

% string_ing - attempt to 'ing' a verb
%-------------------------------------
%
% str = string_ing(str)
%
% Inputs:
% -------
%  str - string
%
% Outputs:
% --------
%  str - conjugated string

%--------------------------------
% Author: Matt Robbins, Harold Figueroa
%--------------------------------
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------

%-------------------------
% HANDLE INPUT
%-------------------------

if ~isstr(str)
	error('Input must be string.');
end

n = numel(str);

%-------------------------
% CONJUGATE
%-------------------------

if ~is_vowel(str(end)) && is_vowel(str(end - 1)) && (str(end - 1) ~= 'e') && ~is_vowel(str(end - 2))
	str(end:end + 1) = str(end); str = [str, 'ing']; return;
end

if str(end) == 'e' && str(end - 1) ~= 'e' && ~strcmpi(str, 'be')
	str(end) = [];
end

str = [str, 'ing'];

