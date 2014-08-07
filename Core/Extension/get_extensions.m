function ext = get_extensions(type, varargin)
 
% get_extensions - get available extensions
% -----------------------------------------
%
% ext = get_extensions(type, 'field', value, ... )
%
% Input:
% ------
%  type - extension type 
%  field - extension field name
%  value - extension field value
%
% Output:
% -------
%  ext - extensions

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
% $Revision: 6946 $
% $Date: 2006-10-06 15:28:35 -0400 (Fri, 06 Oct 2006) $
%--------------------------------

% TODO: perform checks on the availability of toolboxes

% TODO: make extensions application specific, application identifier is input

%----------------------------------
% HANDLE INPUT
%----------------------------------

% NOTE: the default behavior of this function is to get all extensions from cache

%--
% check for selection criteria
%--

if isempty(varargin)
	select = 0;
else
	select = 1;
end 

%--
% set default type, check for refresh
%--

if nargin < 1
	type = '';
end

refresh = 0; verb = 0;

if ~isempty(type)

	% NOTE: we refresh on 'refresh' command or when the type is prefixed by '!'

	if type(1) == '!'
		refresh = 1; type = type(2:end);
	end
	
	if strcmpi(type, 'refresh')
		refresh = 1; verb = 1; type = '';
	end 
	
	% NOTE: we normalize type string after removing potential prefix
	
	if ~isempty(type)
		
		type = type_norm(type);
		
		if isempty(type)
			error('Unrecognized extension type.');
		end
		
	end
	
end

%----------------------------------
% CREATE PERSISTENT STORE 
%----------------------------------

persistent PERSISTENT_EXTENSION_CACHE;

if isempty(PERSISTENT_EXTENSION_CACHE) || refresh
	
	%--
	% get all extensions 
	%--

	% NOTE: this refreshes extension types as well
	
	types = get_extension_types(1); ext = [];
	
	for k = 1:length(types)

		%--
		% get extensions of type
		%--
		
		ext_k = get_type_extensions(types{k});
	
		if isempty(ext_k)
			continue;
		end
		
		%--
		% append extensions to list
		%--
					
		if isempty(ext)
			ext = ext_k;
		else
			ext = [ext, ext_k];
		end
					
	end
	
	%--
	% update persistent extnsion stores
	%--
	
	PERSISTENT_EXTENSION_CACHE = ext;
		
else
	
	%--
	% copy persistent extension cache
	%--
	
	ext = PERSISTENT_EXTENSION_CACHE;
	
end

%----------------------------------
% SELECT EXTENSIONS
%----------------------------------

%--
% return quickly for no selection
%--

if verb && (nargout < 1) && ~select
	display_results(ext); return;
end

%--
% select extensions by type
%--

if ~isempty(type)

	%--
	% compare input type with extension types
	%--
	
	% NOTE: there is the stupid misnomer again 'subtype'
	
	ix = find(strcmp({ext.subtype}', type));
	
	if isempty(ix)
		ext = [];
	end
	
	ext = ext(ix);
	
end

%--
% select using field value pairs
%--

if select
	ext = select_extensions(ext, varargin{:});
end

%--
% display results if needed
%--

if verb && (nargout < 1)
	display_results(ext);
end


%---------------------------------------------------------------
% DISPLAY_RESULTS
%---------------------------------------------------------------

% TODO: develop this into something more flexible and factor out

function display_results(ext)

if isempty(ext)
	return;
end

str = strcat(upper({ext.subtype}'),{': '},{ext.name}',{' '},{ext.version}');

disp(' ');

for k = 1:length(str)
	disp([int2str(k), '. ', str{k}]);
end

disp(' ');


%---------------------------------------------------------------
% GET_TYPE_EXTENSIONS
%---------------------------------------------------------------

function ext = get_type_extensions(type)

% get_type_extensions - get extensions of a given type
% ----------------------------------------------------
%
% ext = get_type_extensions(type)
%
% Input:
% ------
%  type - type of extensions
%
% Output:
% -------
%  ext - extensions of specified type

%--------------------------------
% GET EXTENSION DIRECTORIES
%--------------------------------

%--
% get root directory for extensions of given type
%--

% TODO: handle multiple extension roots when this becomes available

type_dir = extensions_root(type);

%--
% get root directory contents info
%--

% NOTE: we return empty if the parent is not in the path

if isempty(what(type_dir))
	ext = []; return;
end

%--
% get individual extension directories
%--

ext_dir = get_field(what_ext(type_dir), 'dir');
	
% NOTE: remove known non-extension directories 

for k = length(ext_dir):-1:1
	
	% NOTE: 'get_extension_names' currently fails to ignore 'CVS'
	
	if ( ...
		strcmp(ext_dir{k}, 'CVS') || ...
		strcmp(ext_dir{k}, 'private') || ...
		strcmp(ext_dir{k}, '__IGNORE') || ...
		strcmp(ext_dir{k}, '.svn') ...
	)
		ext_dir(k) = [];
	end
	
end

%--
% return empty if there are no extension directories
%--

if (length(ext_dir) == 0)
	ext = []; return;
end

%--------------------------------
% GET EXTENSIONS
%--------------------------------
	
%--
% keep current directory
%--

curr_dir = pwd;

%--
% loop over extension directories
%--

j = 0; splash = get_splash;

for k = 1:length(ext_dir)

	%--
	% get extension file
	%--

	% NOTE: we are looking for a single M or then P code file in the extension directory

	files = what_ext([type_dir, filesep, ext_dir{k}], 'm', 'p');

	ext_file = get_field(files, 'm');

	if isempty(ext_file)
		ext_file = get_field(files, 'p');
	end

	% NOTE: this is where we enforce the single file condition

	if (length(ext_file) > 1)

		disp(' ');
		warning( ...
			['Extension directory ''', ext_dir{k}, ''' must contain a single M-file or P-file.'] ...
		);

		continue;

	end

	%--
	% try to create extension structure
	%--

	% TODO: improve this exception handler block to provide an informative display

	try

		splash_wait_update(splash, ['loading ''', ext_dir{k}, ''' ', strrep(type, '_', ' '), ' ...']);
		
		cd([type_dir, filesep, ext_dir{k}]); 
		
		fun = file_ext(ext_file{1});
				
		extension = feval(fun);

	catch

		warning(['Failed to get extension from ''', ext_dir{k}, '''.']); continue;

	end

	%--
	% update extension registry array
	%--

	j = j + 1;

	if (j == 1)
		ext = extension;
	else
		ext(j) = extension;
	end

end

%--
% output results, empty on empty and in sorted order otherwise
%--

if (j == 0)
	ext = []; return;
end

if (j > 1)
	[ignore, ix] = sort(struct_field(ext, 'name')); ext = ext(ix);
end

%--
% return to current directory
%--

cd(curr_dir);


%---------------------------------------------------------------
% SELECT_EXTENSIONS
%---------------------------------------------------------------

function ext = select_extensions(ext, varargin)

% select_extensions - select extensions from list
% -----------------------------------------------
%
% out = select_extensions(in, field, value, ... )
%
% Input:
% ------
%  ext - list of extensions
%  field - field name
%  value - field value
%
% Output:
% -------
%  ext - selected extensions

%----------------------
% HANDLE INPUT
%----------------------

%--
% return quickly for trivial selections
%--

if (length(varargin) == 0) || isempty(ext)
	return;
end

%----------------------
% SELECT
%----------------------

%--
% get field value pairs from input
%--

[field, value] = get_field_value(varargin);

%--
% loop over fields
%--

for j = 1:length(field)

	%--
	% select on available fields
	%--

	if isfield(ext(1), field{j})

		for k = length(ext):-1:1

			if ~isequal(ext(k).(field{j}), value{j})
				ext(k) = [];
			end

		end

	end

end

%--
% return simple empty on empty
%--

if isempty(ext)
	ext = []; return;
end
	
