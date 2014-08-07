function str = strip_punctuation(str)

% strip_punctuation - strip punctuation from string
% -------------------------------------------------
% 
% str = strip_punctuation(str);
%
% Input:
% ------
%  str - input string
% 
% Output:
% -------
%  str - output string

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

% TODO: consider implementing this using regular expressions

if iscellstr(str)
	
	for k = 1:length(str)
		str{k} = strip_punctuation(str{k});
	end

	return;

end

%--
% create array of punctuation
%--

punct = double('`~!@#$%^&*()-=+[{]}\|;:''",<.>/?');

%--
% remove punctuation from string
%--

str = double(str);

for k = 1:length(punct)
	str(str == punct(k)) = [];
end

str = char(str);

%--
% convert spaces to underscore
%--

% TODO: check whether this is used by calling functions, it does not fit semantics

str = strrep(str, ' ', '_');
