function sounds = migrate_sounds(source, lib)

% migrate_sounds - migrate library sounds
% ------------------------------------------
% 
% sounds = migrate_sounds(source, lib)
%
% Input:
% ------
%  source - source sounds root
%  lib - library to which to migrate sounds
%
% Output:
% -------
%  sounds - migrated sounds

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

%--
% get active library if needed
%--

if nargin < 2 || isempty(lib)
	lib = get_active_library;
end

%--
% setup
%--

names = get_folder_names(source);

if numel(names) == 0
	sounds = []; return;
end

%--
% waitbar update
%--

migrate_wait('Sounds', length(names), names{1});

%--
% migrate sounds
%--

sounds = {};

for k = 1:length(names)
	sounds{end + 1} = migrate_sound([source, filesep, names{k}], lib);
end

sounds = [sounds{:}];

%--
% refresh library cache
%--

get_library_sounds(lib, 'refresh');


