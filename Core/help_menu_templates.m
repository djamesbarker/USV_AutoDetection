function [menu,str,name] = help_menu_templates(h,mode)

% help_menu_templates - create help templates for menus
% -----------------------------------------------------
%
% help_menu_templates(h,'xml')
% help_menu_templates(h,'html')
%
% Input:
% ------
%  h - figure handle
%
% Output:
% -------
%  menu - menu structures
%  str - xml text strings
%  name - file names

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
% set mode
%--

if (nargin < 2)
	mode = 'xml';
end

%--
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% get root
%--

root = xbat_root;

%--
% get figure menus
%--

g = flipud(findobj(h,'type','uimenu','parent',h));

%--
% create menu help file templates
%--

for k = 1:length(g)
	
	%--
	% create name of xml menu help file
	%--
	
	name{k} = [root 'help' filesep lower(get(g(k),'label')) '_menu.xml'];
	
	%--
	% check whether file already exists
	%--
	
	if (exist(name{k},'file'))
		
		%--
		% check for html files if needed 
		%--
		
		if (strcmp(mode,'html'))
			
			tmp = [root 'help' filesep lower(get(g(k),'label')) '_menu.html'];
			
			if (exist(tmp,'file'))
				
				%--
				% required xml and html help files already exist
				%--
				
				disp(' ');
				warning(['Help files for menu ''' get(g(k),'label') ''' already exist.' ]);
				
			else
				
				%--
				% create html from xml
				%--
				
				style = [root 'help\xsl\menu_hierarchy.xsl'];
				msxsl(name{k},style,tmp);
				
				tmp = [root 'help' filesep lower(get(g(k),'label')) '_bar.html'];
				style = [root 'help\xsl\menu_bar.xsl'];
				msxsl(name{k},style,tmp);
				
				tmp = [root 'help' filesep lower(get(g(k),'label')) '_head.html'];
				str_table = head_table(g); 
				str_to_file(str_table,tmp);
				
				% generate frameset
			
				tmp = [root 'help' filesep lower(get(g(k),'label')) '_frame.html'];
				str_frame = nav_frameset(lower(get(g(k),'label')));
				xml_to_file(str_frame,tmp);
					
			end
			
		else
		
			%--
			% required xml help files already exist
			%--
			
			disp(' ');
			warning(['Help files for menu ''' get(g(k),'label') ''' already exist.' ]);
			
		end
		
	else
		
		%--
		% generate xml menu help file templates
		%--
		
		menu{k} = menu_to_struct(g(k));

		str{k} = struct_to_xml(menu{k},'menu','xsl/menu_hierarchy.xsl');
		xml_to_file(str{k},name{k});
		
		name{k} = [root 'help' filesep lower(get(g(k),'label')) '_menu_bar.xml'];
		str{k} = struct_to_xml(menu{k},'menu','xsl/menu_bar.xsl');
		xml_to_file(str{k},name{k});
		
		%--
		% generate html menu help files from xml
		%--
		
		if (strcmp(mode,'html'))
			
			tmp = [root 'help' filesep lower(get(g(k),'label')) '_menu.html'];
			style = [root 'help\xsl\menu_hierarchy.xsl'];
			msxsl(name{k},style,tmp);
			
			tmp = [root 'help' filesep lower(get(g(k),'label')) '_bar.html'];
			style = [root 'help\xsl\menu_bar.xsl'];
			msxsl(name{k},style,tmp);
			
			tmp = [root 'help' filesep lower(get(g(k),'label')) '_head.html'];
			str_table = head_table(g); 
			str_to_file(str_table,tmp);
			
			% generate frameset
			
			tmp = [root 'help' filesep lower(get(g(k),'label')) '_frame.html'];
			str_frame = nav_frameset(lower(get(g(k),'label')));
			xml_to_file(str_frame,tmp);
			
		end
		
	end
	
end

%--
% create navigation bar frameset documents string
%--

function str = nav_frameset(name)


str = file_to_str('frame_template.html');

tmp = [name '_head.html'];
str = strrep(str,'$HEAD',tmp);

tmp = [name '_bar.html'];
str = strrep(str,'$NAVIGATION',tmp);

tmp = [name '_menu.html'];
str = strrep(str,'$DISPLAY',tmp);

% str = '';
% str = [str '<HTML>\n'];
% str = [str '<HEAD>\n<TITLE>' name '</TITLE>\n</HEAD>\n'];
% str = [str '<FRAMESET> rows = "64,*" cols = "*">\n'];
% str = 
% str = [str '<FRAMESET rows = "*" cols = "256,*">\n'];
% str = [str '\t<FRAME name = "navigation_frame" src = "' name '_bar.html" scrolling = "yes">\n'];
% str = [str '\t<FRAME name = "display_frame" src = "' name '_menu.html" scrolling = "yes">\n'];
% str = [str '</FRAMESET>\n'];
% str = [str '</HTML>\n'];

function str = head_table(g)

str = ['<HTML>\n<BODY>\n'];
str = [str '<TABLE WIDTH = "*" BORDER = "1" CELLPADDING = "10" CELLSPACING = "2" STYLE = "{color: white; background-color: black;}">\n'];
str = [str '\t<TR>\n'];

for k = 1:length(g)
	tmp = get(g(k),'label');
	str = [str '\t<TD> ' tmp '</TD>\n'];
end

str = [str '\t</TR>\n'];
str = [str '</TABLE>\n'];
str = [str '</BODY>\n</HTML>'];
