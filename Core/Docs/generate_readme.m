function files = generate_readme(types)

% generate_readme - generate readme files for special directories
% ---------------------------------------------------------------
%
% files = generate_readme(types)
%
% Input:
% ------
%  types - readme types to generate (def: 'all')
%
% Output:
% -------
%  files - readme files generated

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

%-----------------------
% SETUP
%-----------------------

%--
% declare readme types
%--

known_types = { ...
	'users', ...
	'user', ...
	'libraries', ...
	'library', ...
	'extensions', ...
	'extension' ...
};

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% set and check readme type
%--

if nargin < 1
	
	types = {'all'};
	
else
	
	% NOTE: check structure of input
	
	if ischar(types)
		types = {types};
	end
	
	if ~iscellstr(types)
		error('Type input must be a string or string cell array.');
	end
	
	types = unique(types);
	
end

% NOTE: check content of input

if any(strcmpi(types, 'all'))
	
	types = known_types;

else
	
	for k = 1:length(types)
		
		if ~ismember(types{k}, known_types)
			error(['Unrecognized README type ''', types{k}, '''.']);
		end
		
	end 
	
end

%-----------------------
% CREATE FILES
%-----------------------

files = {};

for j = 1:length(types)
	
	%--
	% get source file for type
	%--
	
	type = types{j};
	
	source = get_readme_source(type);
	
	%--
	% get destination README file
	%--
	
	switch type

		%--
		% user directories
		%--
		
		case 'users'
			
			output = get_readme_destination(type);
	
		case {'user', 'libraries'}
			
			user = get_users; output = cell(size(user));
			 
			for k = 1:length(user)
				output{k} = get_readme_destination(type, user(k));
			end
		
		%--
		% library directories
		%--
		 
		case 'library'
			
			lib = get_unique_libraries; output = cell(size(lib));

			for k = 1:length(lib)
				output{k} = get_readme_destination(type, lib(k));
			end
			
		%--
		% extension directories
		%--
		
		case 'extensions'
			
			output = get_readme_destination(type);
			
		case 'extension'

			ext = get_extensions('!'); output = cell(size(ext));

			for k = 1:length(ext)
				output{k} = get_readme_destination(type, ext(k));
			end
			
			
	end
	
	%--
	% create README file
	%--
	
	lines = file_readlines(source);
	
	% TODO: add file to top of file, add two lines at top file and space
	
	if ischar(output)
		output = {output};
	end 
	
	for k = 1:length(output)
		file_writelines(output{k}, lines); files{end + 1} = output{k};
	end
	
end


%-----------------------------------
% GET_README_SOURCE
%-----------------------------------

function file = get_readme_source(type)

%--
% build filename
%--

file = [fileparts(mfilename('fullpath')), filesep, 'README', filesep, type, '.txt'];

%--
% check for existence and create default if needed
%--

% NOTE: by default we use the contents of the 'managed.txt' readme
	
if ~exist(file, 'file')
	file_process(file, get_readme_source('managed'));
end


%-----------------------------------
% GET_README_DESTINATION
%-----------------------------------

function file = get_readme_destination(type, varargin)

%--
% get destination directory
%--

switch type
	
	%--
	% user directories
	%--
	
	% NOTE: input should contain user
	
	case 'users', base = users_root;
		
	case 'user', base = user_root(varargin{1});
		
	case 'libraries', base = user_root(varargin{1}, 'libraries');
		
	%--
	% library directories
	%--
	
	% NOTE: input should contain library
	
	case 'library', base = varargin{1}.path;
		
	%--
	% extension directories
	%--
	
	% NOTE: input should contain extension
	
	case 'extensions', base = extensions_root;
		
	case 'extension', base = extension_root(varargin{1});
		
end

%--
% add file name
%--

file = fullfile(base, 'README.txt');

disp(file);

