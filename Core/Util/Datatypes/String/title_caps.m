function str = title_caps(str,pat)

% title_caps - capitalize strings as titles
% -----------------------------------------
%
% str = title_caps(str,pat)
%
% Input:
% ------
%  str - string or cell array
%  pat - space representation pattern (def: '_')
%
% Output:
% -------
%  str - title capitalized strings 

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1953 $
% $Date: 2005-10-19 20:22:46 -0400 (Wed, 19 Oct 2005) $
%--------------------------------

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

%--
% set space representation character
%--

if (nargin < 2)
	pat = '_';
end

%--
% handle cell array input recursively
%--

if iscell(str)
		
	for k = 1:numel(str)
		str{k} = title_caps(str{k}, pat);
	end

	return;
	
end

%--
% check for string input
%--

% NOTE: we do nothing is input is not string

if ~ischar(str)
	return;
end

%-----------------------------------------------------
% CAPITALIZE STRING
%-----------------------------------------------------

% NOTE: return quickly for empty strings

if isempty(str)
	return;
end

%--
% apply space replacement if needed
%--

if ~isempty(pat)
	str = strrep(str, pat, ' ');
end

% NOTE: trim spaces and return quickly if string is only space

str = strtrim(str);

if isempty(str)
	return;
end

%--
% capitalize string
%--

% NOTE: capitalize first character and characters following a space or hyphen

try
	
	ix = [1, findstr(str, ' ') + 1, findstr(str, '-') + 1];

	str(ix) = upper(str(ix));

end
	
