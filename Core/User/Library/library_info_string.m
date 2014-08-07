function S = library_info_str(lib, fields)

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

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
% set fields if needed
%--

if (nargin < 2) || isempty(fields)
	
	fields = { ...
		'name', ...
		'sounds', ...
		'logs', ...
		'author', ...
		'created', ...
		'modified' ...
	};

end

%--
% set default library
%--

if ~nargin
	lib = get_active_library;
end

%-----------------------------------------------------
% CREATE STRING
%-----------------------------------------------------

S = cell(0); 

for k = 1:length(fields)
	
	prefix = [title_caps(fields{k}), ':  '];
	
	switch fields{k}
	
		case 'name'
			
			S{end + 1} = [prefix, lib.name];
			
		case 'sounds'
			
			S{end + 1} = [prefix sound_info_str(get_library_sounds(lib), 'multiple')];
			
		case 'logs'
			
			S{end + 1} = [prefix, log_info_str(get_library_logs('logs', lib), 'multiple')];
			
		case 'author'
			
			S{end + 1} = [prefix, lib.author];
				
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
			
	end
	
end
