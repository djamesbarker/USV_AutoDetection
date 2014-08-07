function [names, roots] = get_extension_names(type)

% get_extension_names - quickly get names of extensions
% -----------------------------------------------------
%
% [names, roots] = get_extension_names(type)
%
% Input:
% ------
%  type - type of extensions to scan for (def: '', scan for all)
%
% Output:
% -------
%  names - names
%  roots - roots

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

% NOTE: reuse this in 'get_extensions'

%-------------------
% HANDLE INPUT
%-------------------

%--
% set all extensions default
%--

if ~nargin
	type = get_extension_types;
end

%--
% handle multiple types recursively
%--

if iscellstr(type)
	
	names = {}; roots = {};
	
	for k = 1:length(type)
		
		[part_names, part_roots] = get_extension_names(type{k}); 
		
		names = {names{:}, part_names{:}}; roots = {roots{:}, part_roots{:}};
		
	end
	
	if ~nargout
		display_results(names, roots);
	end
	
	return;
	
end

%--
% check type after normalization
%--

names = {}; roots = {};

type = type_norm(type);

if ~is_extension_type(type)
	return;
end

%-------------------
% GET NAMES
%-------------------

root = extensions_root(type);

if ~exist_dir(root)
	return; 
end

content = dir(root);

for k = 1:length(content)
	
	if ~content(k).isdir
		continue;
	end
	
	name = content(k).name;
	
	% TODO: 'is_punct' function
	
	% NOTE: the name must start with a capital letter
	
	if ~ismember(name(1), '._') && (name(1) == upper(name(1)))
		
		names{end + 1} = name; roots{end + 1} = [root, filesep, name];
		
	end
	
end

if ~nargout
	display_results(names, roots);
end
	

%-----------------------------------
% DISPLAY_RESULTS
%-----------------------------------

% TODO: generalize and factor this tabular display

function display_results(names, roots)
	
disp(' ');
disp('EXTENSIONS');
disp('----------');

cols = max(cellfun(@length, names));

for k = 1:length(names)
	disp([ ...
		names{k}, ...
		spaces(cols - length(names{k})), ...
		' (', strrep(roots{k}, xbat_root, '$XBAT_ROOT'), ')' ...
	]);
end

disp(' ');


%-----------------------------------
% SPACES
%-----------------------------------

function str = spaces(n)

str = char(32 * ones(1, n));

