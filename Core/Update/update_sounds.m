function update_sounds(lib)

% update_sounds - update sound structures
% ---------------------------------------
% 
% update_sounds(lib)
%
% Input:
% ------
%  lib - libraries to update (def: unique libraries)

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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%------------------------------------
% HANDLE INPUT
%------------------------------------

%--
% get all libraries as default
%--

if (nargin < 1)
	lib = get_unique_libraries;
end

if (isempty(lib))
	return;
end
	
%------------------------------------
% UPDATE SOUNDS
%------------------------------------

%--
% loop through linked libraries
%--

for k = 1:length(lib)
	
	%--
	% get library sounds
	%--
	
	% NOTE: the sound structures get updated here, this function mostly just saves these
	
	[sound,state] = get_library_sounds(lib(k));
	
	if (isempty(sound))
		continue;
	end
	
	%--
	% update sounds and save in library
	%--
	
	disp(' ')
	
	disp(lib(k).name);
	str_line(lib(k).name);
	disp(['(', lib(k).path, ')']);
	
	for j = 1:length(sound)
		
		% NOTE: states are stored in cell because some are empty
		
		sound_save(lib(k), ...
			sound(j), state{j}, 0 ...
		);
	
		disp(['  ', sound_name(sound(j))]);
	
	end
	
	disp(' ');
	
	%--
	% refresh library sounds
	%--
	
	get_library_sounds(lib(k),'refresh');
	
end
