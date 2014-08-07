function flag = log_edit_menu(h,str,flag)

% log_edit_menu - log browser edit function menu
% ----------------------------------------------
%
% flag = log_edit_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag (def: '')
%
% Output:
% -------
%  flag - command execution flag

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'File'))
		set(get_menu(h,str),'enable',flag);
	end			
	return;			
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% perform command sequence
%--

if (iscell(str))
	for k = 1:length(str)
		try
			log_edit_menu(h,str{k}); 
		catch
			disp(' '); 
			warning(['Unable to execute command ''' str{k} '''.']);
		end
	end
	return;
end

%--
% set handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% main switch
%--

switch (str)

%--
% Initialize
%--

case ('Initialize')
	
	%--
	% check for existing menu
	%--

	%--
	% get userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% File
	%--
	
	L = { ...
		'Edit', ...
		'Undo Edit', ...	
		'Redo Edit', ...
		'Delete Selection' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	
	A = cell(1,n);
	A{2} = 'Z';
	A{3} = 'Y';
	
	tmp = menu_group(h,'log_edit_menu',L,S,A);
	data.browser.edit_menu.edit = tmp;
	
	set(tmp(2:end),'enable','off');
	
	set(tmp(1),'position',2);
	
	%--
	% save userdata
	%--
	
	set(gcf,'userdata',data);
	
	%--
	% update renderer mode and menus
	%--
	
	if ( ...
		(data.browser.selection.patch > 0) & ...
		(~strcmp(data.browser.renderer,'OpenGL') | ~strcmp(get(h,'RendererMode'),'manual')) ...
	)
		
		data.browser.renderer = 'OpenGL';
		
		tmp = data.browser.view_menu.renderer;
		set(tmp,'check','off');
		set(get_menu(tmp,'OpenGL'),'check','on');
		
		set(h,'RendererMode','manual');
		set(h,'Renderer','OpenGL');
		
	end
	
%--
% Undo Edit
%--

case ('Undo Edit')
	
%--
% Redo Edit
%--

case ('Redo Edit')
	
%--
% Delete Selection
%--

case ('Delete Selection')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata'); 
	
	%--
	% delete selection display
	%--
	
	if (all(ishandle(data.browser.selection.handle)))
		delete(data.browser.selection.handle);
	end
	
	refresh(h);
	
	%--
	% set empty selection
	%--
	
	data.browser.selection.event = event_create;
	data.browser.selection.handle = [];
	
	%--
	% disable selection options in edit menu
	%--

	tmp = data.browser.sound_menu.sound;
	
	set(get_menu(tmp,'Play Event'),'enable','off');
	set(get_menu(tmp,'Play Clip'),'enable','off'); 
	
	tmp = data.browser.edit_menu.edit;
	
	set(get_menu(tmp,'Delete Selection'),'enable','off'); 
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);

end
