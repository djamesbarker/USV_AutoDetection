function [str,info] = generate_key_reference

% generate_key_reference - generate keyboard shortcut reference
% -------------------------------------------------------------
%
% [str,info] = generate_key_reference
%
% Output:
% -------
%  str - reference html string
%  info - info from keypress function

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
% $Revision: 629 $
% $Date: 2005-02-28 23:14:52 -0500 (Mon, 28 Feb 2005) $
%--------------------------------

% eventually move to xml/xsl model for generation

%----------------------------------------------
% GET KEYPRESS INFO
%----------------------------------------------

%--
% loop over subset of ascii codes
%--

j = 0;

for k = [8, 9, 13, 27:127];
	
	%--
	% get info for a specific ascii code
	%--
	
	tmp = browser_kpfun(k,1);
	
	%--
	% non-empty info means that the key is used in the keypress test
	%--
	
	if (~isempty(tmp))
		j = j + 1;
		info(j) = tmp;
	end
	
	%--
	% get info for a specific ascii code
	%--
	
	tmp = palette_kpfun(k,1);
	
	%--
	% non-empty info means that the key is used in the keypress test
	%--
	
	if (~isempty(tmp))
		j = j + 1;
		info(j) = tmp;
	end
	
end

%--
% consider the case there are no keys used in the keypress test
%--


if (j == 0)
	
	str = '';
	info = [];
	
	return;
	
end

%----------------------------------------------
% GENERATE KEY REFERENCE (ALPHABETICAL)
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

% '<LINK REL="stylesheet" TYPE="text/css" MEDIA="print" HREF="xbat-keys-print.css">\n' ...
	
str = [ ...
	'<HTML>\n' ...
	'<HEAD>\n' ...
	'<TITLE>XBAT Keyboard Shortcuts (Alphabetical)</TITLE>\n' ...
	'<LINK REL="stylesheet" TYPE="text/css" MEDIA="screen" HREF="xbat-keys.css">\n' ...
	'<LINK REL="stylesheet" TYPE="text/css" MEDIA="print" HREF="xbat-keys-print.css">\n' ...
	'</HEAD>\n' ...
	'<BODY>\n' ...
	'<A HREF="xbat-keys.html">Alphabetical</A>\n' ...
	'<A HREF="xbat-keys-category.html">Category</A>\n' ...
	'<H1>XBAT Keyboard Shortcuts (Alphabetical)</H1>\n' ...
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

out = [xbat_root 'Docs' filesep 'xbat-keys.html'];

fid = fopen(out,'wt');

fprintf(fid,str);

fclose(fid);

%----------------------------------------------
% GENERATE KEY REFERENCE (BY CATEGORY)
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

%--
% html file opening
%--

% consider adding the doctype

% <!DOCTYPE html
% PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
% "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

% '<LINK REL="stylesheet" TYPE="text/css" MEDIA="print" HREF="xbat-keys-print.css">\n' ...
	
str = [ ...
	'<HTML>\n' ...
	'<HEAD>\n' ...
	'<TITLE>XBAT Keyboard Shortcuts (Category)</TITLE>\n' ...
	'<LINK REL="stylesheet" TYPE="text/css" MEDIA="all" HREF="xbat-keys.css">\n' ...
	'</HEAD>\n' ...
	'<BODY>\n' ...
	'<A HREF="xbat-keys.html">Alphabetical</A>\n' ...
	'<A HREF="xbat-keys-category.html">Category</A>\n' ...
	'<H1>XBAT Keyboard Shortcuts (Category)</H1>\n', ...
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

out = [xbat_root 'Docs' filesep 'xbat-keys-category.html'];

fid = fopen(out,'wt');

fprintf(fid,str);

fclose(fid);

