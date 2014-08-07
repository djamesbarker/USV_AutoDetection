function model = model_site(site)

% MODEL_SITE compile site model
%
% model = model_site(site)

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
% create empty site model
%--

% NOTE: in this section we set the 'site' and 'root' fields

model = create_model(site);

if ~exist_site(site)
	return;
end

model.root = site_root(site);

% NOTE: in what follows we set the remaining 'fragments' and 'pages'

%--
% add fragments to model
%--

root = assets_root(site, 'fragments');

model.fragments = model_pages(root);

%--
% add pages to model
%--

root = pages_root(site);

model.pages = model_pages(root);


%---------------------------
% CREATE_MODEL
%---------------------------

function model = create_model(site)

%--
% site name and root
%--

model.site = site;

model.root = '';

%--
% site fragments and pages
%--

model.fragments = empty(create_page);

model.pages = empty(create_page);


%- PAGES ----------------------------------------------------


%---------------------------
% CREATE_PAGE
%---------------------------

function page = create_page(name, file)

if nargin < 2
	file = '';
end

if nargin < 1
	name = '';
end

page.name = name;

page.file = file;

page.id = [];

page.level = 0;

page.position = [];

page.parent = 0;

% NOTE: this will handle the list directory '@name'

page.list = [];

page.child = [];


%---------------------------
% MODEL_PAGES
%---------------------------

function pages = model_pages(root, par, pages)

% MODEL_PAGES compile pages model
%
% pages = model_pages(root, par, pages)

if nargin < 3
	pages = empty(create_page);
end

if nargin < 2
	par = [];
end

%--
% get root contents
%--

% NOTE: it seems like we could model other assets if we wanted to

ext = get_asset_extensions('pages');

content = get_extension_content(root, ext);

children = get_children(root);

order = get_order(root);

% TODO: put where it belongs and allow for partial specification

if isempty(order)
	order = sort(file_ext({content.name}));
end

%--
% model pages
%--

for k = 1:length(content)
	
	%--
	% create page
	%--
	
	% NOTE: create sets the page 'name' and 'file'
	
	name = file_ext(content(k).name);
	
	page = create_page(name, [root, filesep, content(k).name]);
	
	%--
	% add page
	%--
	
	% NOTE: add sets the page 'id', 'parent', and 'level'
	
	if isempty(par)
		pages = add_page(pages, page);
	else
		pages = add_page(pages, page, par);
	end
	
	% NOTE: in the remaining code we set the 'position' and 'child' fields
	
	%--
	% set page position
	%--
	
	pages(end).position = get_page_position(pages(end), order);
	
	%--
	% add list content
	%--
	
	% TODO: this will require improvements to order
	
	if ismember(['@', name], children)
		pages(end).list = model_list(pages(end));
	end
	
	%--
	% add children if we have any
	%--
	
	if ismember(name, children)
		pages = model_pages([root, filesep, name], length(pages), pages);
	end

end


%---------------------------
% ADD_PAGE
%---------------------------

function pages = add_page(pages, page, par)

%--
% compute new page id
%--

if isempty(pages)
	id = 1;
else
	id = pages(end).id + 1;
end

page.id = id;

%--
% add root page
%--

if nargin < 3
	pages(end + 1) = page; return;
end

%--
% add child page
%--

page.parent = par; page.level = pages(par).level + 1; 
	
pages(end + 1) = page;

pages(par).child(end + 1) = length(pages);


%---------------------------
% GET_CHILDREN
%---------------------------

function children = get_children(root)

children = get_folder_names(root);


%---------------------------
% GET_ORDER
%---------------------------

function order = get_order(root) 

file = [root, filesep, 'order.txt']; 

if exist(file, 'file')
	order = file_readlines(file); 
else
	order = {};
end


%---------------------------
% GET_PAGE_POSITION
%---------------------------

function pos = get_page_position(page, order)

pos = find(strcmp(page.name, order));


%- LIST PAGES ----------------------------------------------------


%---------------------------
% CREATE_LIST
%---------------------------

function list = create_list(page)

list.parent = page;

list.order = [];

list.transform = [];

list.elements = []; 


%---------------------------
% MODEL_LIST
%---------------------------

function list = model_list(page)

%--
% create list
%--

list = create_list(page);

%--
% get list order and possibly transform
%--

list.order = get_list_order(page);

list.options = get_list_options(page);

list.transform = get_list_transform(page);

%--
% get list elements
%--

list.elements = get_list_elements(page);


%---------------------------
% GET_LIST_ORDER
%---------------------------

function order = get_list_order(page)

%--
% check for order file
%--

file = [fileparts(page.file), filesep, '@', page.name, filesep, 'order.txt'];

if ~exist(file, 'file')
	order = []; return;
end

%--
% read order file
%--

lines = file_readlines(file); 

if isempty(lines)
	order = []; return;
end

% NOTE: get order type

tok = lower(str_split(lines{1}, ' ')); type = tok{1};

types = {'alpha', 'modified', 'custom'};

if ~ismember(type, types)
	order = []; return;
end

order.type = type;

% NOTE: get order details, or modifier (the default modifier is 'desc')

if strcmp(type, 'custom')

	order.list = lines(2:end);

else
	
	directions = {'ascend', 'descend'}; 
	
	if length(tok) > 1
		
		direction = tok{2};
	
		if ~ismember(direction, directions)
			order = []; return;
		end
	
		order.direction = direction;
		
	else
		
		order.direction = 'ascend';
	
	end

end
	
	
%---------------------------
% GET_LIST_TRANSFORM
%---------------------------

% NOTE: we are thinking here of xml elements and transformed using xslt

function transform = get_list_transform(page)

%--
% check for order file
%--

file = [fileparts(page.file), filesep, '@', page.name, filesep, 'transform.xsl'];

if ~exist(file, 'file')
	transform = '';
else
	transform = file;
end

%---------------------------
% GET_LIST_OPTIONS
%---------------------------

% NOTE: note the file contains a set of option lines

% TODO: consider making these field value pair lines, add a split and struct pack

function opt = get_list_options(page)

%--
% check for order file
%--

file = [fileparts(page.file), filesep, '@', page.name, filesep, 'options.txt'];

if ~exist(file, 'file')
	opt = {};
else
	opt = file_readlines(file);
end


%---------------------------
% GET_LIST_ELEMENTS
%---------------------------

function elements = get_list_elements(page)

source = [fileparts(page.file), filesep, '@', page.name];

elements = get_extension_content(source, get_asset_extensions('pages'));


