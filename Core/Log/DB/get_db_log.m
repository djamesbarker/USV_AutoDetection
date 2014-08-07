function db_log = get_db_log(root)

% get_db_log - build log struct from root directory
% -------------------------------------------------
%
% db_log = get_db_log(root)
%
% Input:
% ------
%  root - directory
%
% Output:
% -------
%  db_log - from root

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

% TODO: this should probably be private, also consider redundancy in store

%--
% create struct with empty fields
%--

db_log = db_log_create;

%--
% check and scan for log contents
%--

db_log.root = root;

events = [root, filesep, 'Events.db'];

db_log.events = events;

%--
% get measure and annotation databases
%--

% NOTE: we may get the name of the available measures and annotations with fileparts

measures = create_dir([root, filesep, 'Measures']);

if ~isempty(measures)

	content = what_ext(measures, 'db'); content = content.db;

	if ~isempty(content)
		db_log.measures = strcat(measures, filesep, content.db);
	end

end

annotations = create_dir([root, filesep, 'Annotations']);

if ~isempty(annotations)

	content = what_ext(annotations, 'db'); content = content.db;

	if ~isempty(content)
		db_log.annotations = strcat(annotations, filesep, content.db);
	end

end
