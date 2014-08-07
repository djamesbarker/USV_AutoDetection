function category = get_extension_categories(ext, menu)

% get_extension_categories - get category name and children list
% --------------------------------------------------------------
%
% category = get_extension_categories(ext, menu)
%
%          = get_extension_categories(type, menu)
%
% Input:
% ------
%  ext - extension array
%  type - extension type
%  menu - append menu categories
%
% Output:
% -------
%  category - category name and children list

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

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set default menu categories
%--

if nargin < 2
	menu = 1;
end

%--
% handle extension input
%--

% NOTE: get all available extensions 

if (nargin < 1) || isempty(ext)
	ext = get_extensions;
end
	
% NOTE: get extensions by type, if needed

if ischar(ext)
	
	% NOTE: we normalize the extension type
	
	types = get_extension_types; type = type_norm(ext);
	
	if ~ismember(type, types)
		error('Unrecognized extension type.');
	end
	
	ext = get_extensions(type);
	
end
	
%--
% return empty if there are no extensions
%--

if isempty(ext) 
	category = []; return;
end

%--------------------------------------------
% GET UNIQUE CATEGORY NAMES
%--------------------------------------------

% NOTE: each extension may belong to and contribute zero or more categories
	
%--
% get categories from all extensions
%--

name = cell(0); ext_other = empty(extension_create('widget'));

for k = 1:length(ext)
	
	%--
	% get unique non-empty category names from extension
	%--
	
	part = unique(ext(k).category);
	
	for j = length(part):-1:1
		
		if isempty(part{j})
			part(j) = [];
		end
		
	end

	%--
	% collect extension category names and extensions without categories
	%--
	
	if ~isempty(part)
		name = {name{:}, part{:}};
	else	
		ext_other(end + 1) = ext(k);
	end
	
end

%--
% create category list, adding two artificial categories for menu
%--

name = unique(name); 

if menu
	name = {'All', name{:}, 'Other'};
end

if isempty(name)
	category = []; return;
end

%--------------------------------------------
% CATEGORY EXTENSION LISTS
%--------------------------------------------
	
%--
% create all extension list
%--

children{1} = sort({ext.name}');

%--
% create actual category extension lists
%--

for k = 2:(length(name) - 1)

	ix = [];

	for j = 1:length(ext)
		
		if find(strcmp(name{k}, ext(j).category))
			ix(end + 1) = j;
		end
		
	end

	children{k} = sort({ext(ix).name}');

end

%--
% create other extension list
%--

if isempty(ext_other)
	children{length(name)} = cell(0);
else
	children{length(name)} = sort({ext_other.name}');
end

%--------------------------------------------
% PACK OUTPUT
%--------------------------------------------
	
for k = 1:length(name)
	
	category(k).name = name{k}; category(k).children = children{k};
	
end
		
