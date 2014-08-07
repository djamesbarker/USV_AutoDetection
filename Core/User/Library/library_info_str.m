function S = library_info_str(lib)

% library_info_str - create string cell array with library info
% -------------------------------------------------------------
%
% S = library_info_str(lib,fields)
%
% Input:
% ------
%  lib - library to get info from
%
% Output:
% -------
%  S - cell array of info strings

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------

if length(lib) > 1
	S = '(Multiple libraries selected)'; return;
end

info = get_library_summary(lib);

S{1} = ['Library:  ', lib.name];

lib_fields = { ...
	'author', ... 
	'sounds', ...
	'created', ...
	'modified' ... 
};

for k = 1:length(lib_fields)

	field = lib_fields{k}; 
	
	if isfield(lib, field)
		value = lib.(field);
	end
	
	prefix = [title_caps(field), ':  '];
	
	switch (field)
		
		case ('author')
			
			% NOTE: this can throw an error when the author is no longer a user
			
			if (ischar(value))
				S{end + 1} = [prefix, value];
			else
				author = get_users('id',value); S{end + 1} = [prefix, author.name];
			end
				
		case 'created'
			
			if isempty(lib.created)
				continue;
			end
			
			S{end + 1} = [prefix, datestr(lib.created)];
			
		case 'modified'
			
			if isempty(lib.modified) || (abs(lib.modified - lib.created) < 1/86400)
				continue;
			end
			
			S{end + 1} = [prefix, datestr(lib.modified)];
			
		case 'sounds'
			
			S{end + 1} = [prefix, sound_info_str(get_library_sounds(lib), 'multiple')];
			
		otherwise
			
			switch (class(value))
				
				case ('char'), S{end + 1} = [prefix, value];
		
				otherwise

					% TODO: this would be easy if we had a global to string
					
			end
			
	end
	
end

S = S(:);
