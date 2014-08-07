function [str,info] = generate_menu_reference(h)

% generate_menu_reference - generate menu commands reference
% ----------------------------------------------------------
%
% [str,info] = generate_menu_reference
%
% Output:
% -------
%  str - reference html string
%  info - info from menu commands

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

% eventually move to xml/xsl model for generation

% this is significantly more complex than the keys, since we have to keep
% track of the menu hierarchy. the current implementation is just a start

%--
% set parent figure
%--

if ((nargin < 1) | isempty(h))
	h = gcf;
end

%----------------------------------------------
% GET FIGURE MENUS
%----------------------------------------------

%--
% get figure menus
%--

g = findobj(h,'type','uimenu','parent',h);

g = flipud(g);

% get(g,'label') % display figure menu names

%--
% get menu callback function
%--

% this is an xbat specific function that relies on the various callbacks
% for the children menu objects to be contained in a single function

count = 1;

for k = 1:length(g)
	
	%--
	% get figure menu children
	%--
	
	ch = flipud(get(g(k),'children'));
	
% 	get(ch,'label') % display menu children names
	
	%--
	% get the first non-empty callback function
	%--
	
	callback = [];
	
	for j = 1:length(ch)
		
		tmp = get(ch(j),'callback');
		
		if (~isempty(tmp))
			callback = tmp;
			break
		end
		
	end
	
	%--
	% get callback function from callback
	%--
	
	% display callback function for menu
	
	if (~isempty(callback))
		
		if (isa(callback,'function_handle'))
			fun = callback;
		else
			fun = strtok(callback,'(');
		end
		
	else
		
		continue; 
		
	end 
	
	%--
	% get info for the child menu commands
	%--
	
	for j = 1:length(ch)
		
		try
						
			tmp = feval(fun,[],get(ch(j),'label'),1);
			
			if (~isempty(tmp))
				info(count) = feval(fun,[],get(ch(j),'label'),1);
				count = count + 1;
			end
			
		catch
				
			disp('failed for some menu ...');
			
		end
		
	end
	
	
end 

%----------------------------------------------
% GENERATE MENU REFERENCE (ALPHABETICAL)
%----------------------------------------------

%--
% sort by command name
%--

name = struct_field(info,'name');

[ignore,ix] = sort(name);

info = info(ix);

%--
% html file opening
%--

% consider adding the doctype

% <!DOCTYPE html
% PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
% "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

str = [ ...
	'<HTML>\n' ...
	'<HEAD>\n' ...
	'<TITLE>XBAT Menu Reference (Alphabetical)</TITLE>\n' ...
	'<LINK REL="stylesheet" TYPE="text/css" HREF="xbat-keys.css">\n' ...
	'</HEAD>\n' ...
	'<BODY>\n' ...
	'<H1>XBAT Menu Reference</BR>(Alphabetical)</H1>\n', ...
	'<TABLE CLASS="keys">\n' ...
	'<TR CLASS="header">\n<TH WIDTH="60%%">Command</TH>\n<TH WIDTH="40%%">Keyboard Shortcut</TH>\n</TR>\n' ...
];

%--
% keypress information
%--

for k = 1:length(info)
	
	%--
	% put together command string
	%--
	
	cmd_str = [ ...
		'<DIV CLASS="command">' info(k).name '</DIV>' ...
		'<DIV CLASS="description">' info(k).description '</DIV>' ...
	];
	
	%--
	% put together menu string
	%--
	
	% a single key is a string, a combination is a cell array
	
% 	if (isstr(info(k).category))
		
		key_str = [ ...
			'<SPAN CLASS="menu">' info(k).category '</SPAN> &lt;' ...
			'<SPAN CLASS="menu">' info(k).name '</SPAN>' ...
		];
		
% 	else
% 		
% 		key_str = '';
% 		
% 		for j = 1:(length(info(k).key) - 1)
% 			key_str = [key_str, '<SPAN CLASS="menu">' info(k).category{j} '</SPAN> + '];
% 		end
% 		
% 		key_str = [key_str, '<SPAN CLASS="menu">' info(k).category{end} '</SPAN>'];
% 		
% 	end
	
	%--
	% put row together
	%--
	
	row_str = ['<TR>\n\t<TD>' cmd_str '</TD>\n\t<TD>' key_str '</TD>\n</TR>\n'];
	
	%--
	% add row to output string
	%--
	
	str = [str, row_str];
	
end

str = [str, '</TABLE>\n'];
	
%--
% html file closing
%--

str = [str, ...
	'</BODY>\n' ...
	'</HTML>\n' ...
];

%----------------------------------------------
% CREATE FILE
%----------------------------------------------

out = [xbat_root 'Docs' filesep 'xbat-menus.html'];

fid = fopen(out,'wt');

fprintf(fid,str);

fclose(fid);

%----------------------------------------------
% GENERATE MENU REFERENCE (BY HIERARCHY)
%----------------------------------------------

%--
% sort by category
%--

% sort by name first, already done above

% name = struct_field(info,'name');
% 
% [ignore,ix] = sort(name);
% 
% info = info(ix);

category = struct_field(info,'category');

[ignore,ix] = sort(category);

info = info(ix);


return;

%--
% html file opening
%--

% consider adding the doctype

% <!DOCTYPE html
% PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
% "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

str = [ ...
	'<HTML>\n' ...
	'<HEAD>\n' ...
	'<TITLE>XBAT Menu Reference (by Category)</TITLE>\n' ...
	'<LINK REL="stylesheet" TYPE="text/css" HREF="xbat-keys.css">\n' ...
	'</HEAD>\n' ...
	'<BODY>\n' ...
	'<H1>XBAT Menu Reference</BR>(by Category)</H1>\n', ...
	'<TABLE CLASS="keys">\n' ...
	'<TR CLASS="header">\n<TH WIDTH="60%%">Command</TH>\n<TH WIDTH="40%%">Keyboard Shortcut</TH>\n</TR>\n' ...
];

%--
% keypress information
%--

curr_category = '';

for k = 1:length(info)
	
	%--
	% check for change in category
	%--
	
	if (~strcmp(curr_category,info(k).category))
		
		%--
		% update current category
		%--
		
		curr_category = info(k).category;
		
		%--
		% add category row
		%--
		
		str = [str, ...
			'<TR CLASS="category">\n<TH COLSPAN="2">' curr_category  '</TH>\n' ...
		];
		
	end
	
	%--
	% put together command string
	%--
	
	cmd_str = [ ...
		'<DIV CLASS="command">' info(k).name '</DIV>' ...
		'<DIV CLASS="description">' info(k).description '</DIV>' ...
	];
	
	%--
	% put together key string
	%--
	
	% a single key is a string, a combination is a cell array
	
	if (isstr(info(k).key))
		
		key_str = ['<SPAN CLASS="key">' info(k).key '</SPAN>'];
		
	else
		
		key_str = '';
		
		for j = 1:(length(info(k).key) - 1)
			key_str = [key_str, '<SPAN CLASS="key">' info(k).key{j} '</SPAN> + '];
		end
		
		key_str = [key_str, '<SPAN CLASS="key">' info(k).key{end} '</SPAN>'];
		
	end
	
	%--
	% put row together
	%--
	
	row_str = ['<TR>\n\t<TD>' cmd_str '</TD>\n\t<TD>' key_str '</TD>\n</TR>\n'];
	
	%--
	% add row to output string
	%--
	
	str = [str, row_str];
	
end

str = [str, '</TABLE>\n'];
	
%--
% html file closing
%--

str = [str, ...
	'</BODY>\n' ...
	'</HTML>\n' ...
];

%----------------------------------------------
% CREATE FILE
%----------------------------------------------

out = [xbat_root 'Docs' filesep 'xbat-menus-hierarchy.html'];

fid = fopen(out,'wt');

fprintf(fid,str);

fclose(fid);

