function s = string_plural(s)

% string_plural - attempt to pluralize a string
%-----------------------------------
%
% s = string_plural(s)
%
% Inputs:
% -------
%  s - string
%
% Outputs:
% --------
%  s - 'pluralized' string

%--------------------------------
% Author: Matt Robbins
%--------------------------------
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------

% TODO: there should be a way to re-factor this function to make it nice

%--
% handle multiple inputs recursively
%--

if iscell(s)
	s = iterate(mfilename, s); return;
end

if ~ischar(s)
	error('Input must be string.');
end

n = numel(s);

%--
% handle a few special cases
%--

switch s
	
    case {'KB', 'MB', 'GB', 'TB'}, return;
    
% 	case 'fish', return;
		
	case 'foot', s = 'feet'; return;
		
	case 'goose', s = 'geese'; return;
		
	case 'piano', s(end + 1) = 's'; return;
		
end

if (strfind(s, 'oof') == n - 2)
	s(end:end + 2) = 'ves'; return;
end
	
%--
% handle multi-syllable greek/latin words
%--

if num_syllables(s) > 1

	if (strfind(s, 'um') == n - 1)
		s(end) = ''; s(end) = 'a'; return;
	end
	
	if (strfind(s, 'ion') == n - 2)
		s(end + 1) = 's'; return;
	end
	
	if (strfind(s, 'on') == n - 1)
		s(end) = ''; s(end) = 'a'; return;
	end

	if (strfind(s, 'us') == n - 1)
		s(end) = ''; s(end) = 'i'; return;
	end
	
	if (strfind(s, 'is') == n - 1)
		s(end-1) = 'e'; return;
	end
	
	if s(end) == 'a'
		s(end + 1) = 'e'; return;
	end
	
	if (strfind(s, 'ix') == n - 1)
		s(end - 1:end + 2) = 'ices'; return;
	end
	
	if (strfind(s, 'ex') == n - 1)
		s(end - 1:end + 2) = 'ices'; return;
	end
	
	if (strfind(s, 'ies') == n - 2)
		return;
	end

end

%--
% simple rules
%--

if s(end) == 'y' && ~is_vowel(s(end - 1))
	s(end:end + 2) = 'ies'; return;
end

%--
% syllibant end
%--

if s(end) == 's' || s(end) == 'x' || (s(end) == 'o' && ~is_vowel(s(end - 1))) 
	s = [s, 'es']; return;
end

if strfind(s, 'sh') == n - 1
	s = [s, 'es']; return;
end

if strfind(s, 'ch') == n - 1
	s = [s, 'es']; return;
end

% NOTE: this would have been the germ of this function

s(end + 1) = 's';



