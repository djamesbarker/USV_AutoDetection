function [file, updated] = build_page(model, page)

% BUILD_PAGE build site page file
%
% [file, updated] = build_page(model, page)

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

%----------------------
% HANDLE INPUT
%----------------------

%--
% get page and index index from input
%--

% NOTE: we assume the page input is a page, name, or index

switch class(page)
	
	case 'struct'
		k = get_page_index(model.pages, page);
		
	case 'char'
		[page, k] = get_page_by_name(model.pages, page);
		
	otherwise
		k = page;
		
end

if isempty(k)
	error('Unable to find page in site model.');
end

if (k < 1) || (k ~= floor(k)) || (k > length(model.pages))
	error('Index must indicate a site model page.');
end

%----------------------
% BUILD PAGE
%----------------------

%--
% get output file handle
%--

file = page_file(model.site, model.pages(k));

[file, updated] = create_file(file);

out = get_fid(file, 'wt');

%--
% add header
%--

header = get_page_by_name(model.fragments, 'header');

if ~isempty(header)
	file_process(out.fid, header.file);
end

%--
% add navigation
%--

file_process(out.fid, build_nav(model, k));

%--
% add page content
%--

% NOTE: page names should not have spaces, these are bad for many reasons

file_process(out.fid, { ...
	' ', ...
	'<div id="content">', ...
	['<div id="', page.name, '">'] ...
});

% NOTE: this is the actual page content

lines = file_readlines(page.file);

if isempty(lines) && isempty(page.list)
	file_process(out.fid, which('empty_page_warning.html'));
else
	file_process(out.fid, page.file);
end

% NOTE: this happens if the page has list content

if ~isempty(page.list)
	
	%--
	% permute to order if needed
	%--
	
	if ~isempty(page.list.order)
		
		order = page.list.order;
		
		switch order.type
			
			case 'alpha'
				
				[ignore, ix] = sort({page.list.elements.name});
				
				if strcmp(order.direction, 'descend')
					ix = fliplr(ix);
				end
				
				page.list.elements = page.list.elements(ix);
				
			case 'modified'
				
				% NOTE: to do this we need to get the element file info
				
			case 'custom'
				
				% NOTE: in this case the order is provided by the order file
				
		end
		
	end
	
	%--
	% load list elements
	%--
	
	for k = 1:length(page.list.elements)
		
		element = page.list.elements(k);
		
		name = file_ext(element.name);
		
		file_process(out.fid, { ...
			' ', ...
			['<div class="section-content" id="', name, '">'], ...
			['<h3>', name, '</h3>'] ...
		});
		
		element_file = ...
			[fileparts(page.file), filesep, '@', page.name, filesep, element.name];
		
		lines = file_readlines(element_file);

		if isempty(lines)
% 			file_process(out.fid, which('empty_list_element_warning.html'));
		else
			file_process(out.fid, lines);
		end
	
		file_process(out.fid, { ...
			'</div>', ...
			' ' ...
		});

	end
	
end

file_process(out.fid, { ...
	'</div>', ...
	'</div>', ...
	' ' ...
});

%--
% add footer
%--

footer = get_page_by_name(model.fragments, 'footer');

if ~isempty(footer)
	file_process(out.fid, footer.file);
end 

%--
% close file
%--

fclose(out.fid);

%--
% process page file as template
%--

% NOTE: we get some basic data for template 

data.model = model;

data.theme = model.theme;

data.page = page;

data.date = datestr(now);

% TODO: consider some way of indicating debug in the filesystem

debug = 0;

process_page_file(file, data, debug);

%--
% tidy up page if we can
%--

% if ~isempty(tidy)
% 	tidy(file, 'config.txt');
% end
