function regenerate_main(ext)

% regenerate_main - generate main extension function
% --------------------------------------------------
%
% regenerate_main(ext)
%
% Input:
% ------
%  ext - extension to regenerate main for

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

%-------------------------
% SETUP
%-------------------------

%--
% get main name and file
%--

info = functions(ext.fun.main); file = info.file; main = info.function;

%--
% get parent and parent main if there is one
%--

parent = ext.parent;

if ~isempty(parent)
	parent = parent.main(); info = functions(parent.fun.main); parent_main = info.function;
end

%-------------------------
% WRITE MAIN
%-------------------------

%--
% open file
%--

fid = fopen(file, 'w');

%--
% write declaration
%--

if isempty(parent)
		
	fprintf(fid,'%s\n\n%s\n\n', ...
		['function ext = ', main], ...
		'ext = extension_create;' ...
	);

else
	
	fprintf(fid,'%s\n\n%s\n\n', ...
		['function ext = ', main], ...
		['ext = extension_inherit(', parent_main, ');'] ...
	);
	
end

%--
% write body
%--

fields = {'short_description', 'category', 'version', 'author', 'email', 'url'};

for k = 1:length(fields)

	%--
	% create field line
	%--
	
	field = fields{k};
	
	switch field

		case 'category'
			
			line = get_category_line(ext, parent);
	
		otherwise
			
			if ~isempty(parent) && isequal(ext.(field), parent.(field))
				
				% NOTE: most fields are inherited, you can edit this line to update
				
				line = ['% ext.', field, ' = '''';'];
				
				% NOTE: the short description is cleared for children
				
				if strcmp(field, 'short_description')
					line(1:2) = [];
				end
				
			else
				
				% NOTE: extensions without parent must explicitly set fields
				
				line = ['ext.', field, ' = ''', ext.(field), ''';'];
			
			end
				
	end
	
	%--
	% write line to file
	%--
	
	% NOTE: the file is double spaced
	
	fprintf(fid, '%s\n\n', line);
	
end 

%--
% close main
%--

fclose(fid);


%-------------------------
% GET_CATEGORY_LINE
%-------------------------

function line = get_category_line(ext, parent)

%--
% get explicit categories and inherit parent categories
%--

% NOTE: we refer to parent categories, only unique categories are explicit

if isempty(parent)
	line = ''; explicit = ext.category;
else
	line = 'ext.category{:}, '; explicit = setdiff(ext.category, parent.category);
end

%--
% build categories string
%--

if ischar(explicit)
	
	if isempty(explicit)
		explicit = {};
	else
		explicit = {explicit};
	end
	
end

for k = 1:length(explicit)
	
	if isempty(explicit{k})
		continue;
	end
	
	line = [line, '''', explicit{k}, ''', '];
	
end

if ~isempty(line)
	line(end - 1:end) = [];
end

%--
% finish declaration, comment if there are no explicit categories
%--

if isempty(explicit)
	pre = '% ';
else
	pre = '';
end

line = [pre, 'ext.category = {', line, '};'];


