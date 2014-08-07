function html = build_nav(model, k, fun)

% BUILD_NAV build top of page navigation
% 
% html = build_nav(model, k, fun)

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
% set default label fun
%--

% TODO: this should allow for cell callbacks

if nargin < 3
	fun = @prepare_label;
end 

%--
% get page and family
%--

page = model.pages(k);

family = get_family(model, page);

%--
% create multiple level navigation
%--

html = ''; member = [];

for level = 0:min(page.level + 1, max([model.pages.level]))

	%--
	% get all visible pages from this level and ancestor
	%--

	if isempty(member)
		pages = model.pages([model.pages.level] == level);
	else
		ix = intersect(member.child, find([model.pages.level] == level)); pages = model.pages(ix);
	end 
	
	if isempty(pages)
		continue;
	end 
	
	pages([pages.position]) = pages;
	
	member = family([family.level] == level);
	
	%--
	% build level navigation list
	%--
	
	html = [html, '<div id="nav-', int2str(level), '">\n<ul>\n'];

	prefix = [pages_root(model.site), filesep];
	
	for k = 1:length(pages)
		
		href = strrep(pages(k).file, prefix, '');
		
		href = [level_prefix(page.level), strrep(href, filesep, '/')];
		
		if isempty(member)
			html = [html, '\t<li><a href="', href, '">', fun(pages(k).name), '</a></li>\n'];
		else
			if ~strcmp(pages(k).name, member.name)
				html = [html, '\t<li><a href="', href,'">', fun(pages(k).name), '</a></li>\n'];
			else
				html = [html, '\t<li class="here"><a href="', href, '">', fun(pages(k).name), '</a></li>\n'];
			end
		end

	end

	html = [html, '</ul>\n</div>\n'];

end

html = sprintf(html);


%--------------------------------
% GET_FAMILY
%--------------------------------

function family = get_family(model, page)

%--
% add self to family
%--

family = page;

%--
% move up the ancestor tree
%--

while page.parent
	ancestor = model.pages(page.parent); family(end + 1) = ancestor; page = ancestor;
end


%--------------------------------
% GET_CHILDREN
%--------------------------------

function pages = get_children(model, page)

%--
% return if there are no children
%--

if isempty(page.child)
	pages = []; return; 
end 

%--
% get children, and possibly order them
%--

pages = model.pages(page.child);

% NOTE: we get the children in position order

pos = [pages.position]; 

if ~isempty(pos)
	pages(pos) = pages;
end




