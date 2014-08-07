function out = browser_annotate_menu(h, str, flag)

% browser_annotate_menu - browser annotation function menu
% --------------------------------------------------------
%
% flag = browser_annotate_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%
% Output:
% -------
%  out - command dependent output

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
% $Date: 2005-08-25 10:08:47 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1668 $
%--------------------------------

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% set command
%--

if nargin < 2
	str = 'Initialize';
end

%--
% set parent
%--

if nargin < 1
	h = gcf;
end

%---------------------------
% SETUP
%---------------------------

%--
% set default output
%--

out = [];

%--
% get userdata
%--

data = get(h, 'userdata');

%--
% get annotation information
%--

ANNOT_NAME = data.browser.annotation.name;

ANNOT_VIEW = data.browser.annotation.view;

%---------------------------
% COMMANDS
%---------------------------

switch (str)
	
%---------------------------
% INITIALIZE
%---------------------------

case ('Initialize')
	
	%--
	% check for existing menu
	%--
		
	tmp = get(findobj(gcf,'type','uimenu','parent',gcf),'label');
	
	tmp = find(strcmp(tmp,'Annotate'));
	
	if (~isempty(tmp))
		return;
	end
	
	%--
	% Annotate
	%--
	
	L = strcat(ANNOT_NAME,' ...');
	
	L = { ...
		'Annotate', ...
		'Active', ...
		'Display', ...
		L{:} ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	
	mg = menu_group(h,'browser_annotate_menu',L,S);
	data.browser.annotate_menu.annotate = mg;
	
	set(mg(1),'position',9);
	
	% turn off annotations upon initialization, opening a log will
	% activate these
	
	set(mg(4:end),'enable','off');
	
	%--
	% Display
	%--
	
	L = { ...
		'No Display', ...
		ANNOT_NAME{:}, ...
		'Display All' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
	
	tmp = menu_group(get_menu(mg,'Display'),'browser_annotate_menu',L,S);
	data.browser.annotate_menu.display = tmp;
	
	for k = 1:length(ANNOT_VIEW)
		set(get_menu(tmp,ANNOT_VIEW{k}),'check','on');
	end
	
	%--
	% Active
	%--
	
	L = { ...
		'No Annotation', ...
		ANNOT_NAME{:} ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	
	tmp = menu_group(get_menu(mg,'Active'),'browser_annotate_menu',L,S);
	data.browser.annotate_menu.active = tmp;
	
	L{1} = '';
	
	if (isempty(data.browser.annotation.active))
		set(tmp(1),'check','on');
	else
		set(get_menu(tmp,data.browser.annotation.active),'check','on');
	end
	
	%--
	% save userdata
	%--
	
	set(h,'userdata',data);
	
%---------------------------
% ACTIVE AND DISPLAY
%---------------------------

case ('No Display')
	
	%--
	% update annotation display list
	%--
	
	data.browser.annotation.view = cell(0);
	
	set(h, 'userdata', data);
	
	%--
	% update display state menu
	%--
	
	tmp = data.browser.annotate_menu.display;
	
	set(tmp, 'check', 'off');	
	
	%--
	% update display
	%--
	
	browser_display(h, 'events', data);

case ('Display All')
	
	%--
	% update annotation display list
	%--
	
	data.browser.annotation.view = ANNOT_NAME;
	
	set(h, 'userdata', data);
	
	%--
	% update display state menu
	%--
	
	tmp = data.browser.annotate_menu.display;
	
	set(tmp(2:(end - 1)), 'check', 'on');	
	
	%--
	% update display
	%--
	
	browser_display(h, 'events', data);

case ('No Annotation')
	
	%--
	% update active annotation
	%--
	
	data.browser.annotation.active = '';
	
	set(h, 'userdata', data);
	
	%--
	% update active annotation menus
	%--
	
	set(data.browser.annotate_menu.active, 'check', 'off');
	
	set(get_menu(data.browser.annotate_menu.active, 'No Annotation'), 'check', 'on');

case (ANNOT_NAME)

	%--
	% get parent menu of command
	%--
	
	mode = get(get(gcbo, 'parent'), 'label');
	
	% NOTE: default mode is to alter active annotation
	
	if isempty(mode)
		mode = 'Active';
	end

	%--
	% update display state of annotation or active annotation based on mode
	%--
	
	switch (mode)
		
	%--
	% Toggle Annotation Display
	%--
	
	case ('Display')
		
		%--
		% update display state for annotation
		%--
		
		ixa = find(strcmp(ANNOT_VIEW,str));
		
		if (isempty(ixa))
			ANNOT_VIEW = sort({ANNOT_VIEW{:}, str});
			state = 'on';
		else
			ANNOT_VIEW(ixa) = [];
			state = 'off';
		end
		
		data.browser.annotation.view = ANNOT_VIEW;
		
		set(h,'userdata',data);
		
		%--
		% update display state menu
		%--
		
		set(get_menu(data.browser.annotate_menu.display,str),'check',state);
		
		%--
		% update display
		%--
		
		browser_display(h,'events',data);
		
	%--
	% Set Annotation Active
	%-
	
	case ('Active')
		
		%--
		% update active annotation
		%--
		
		data.browser.annotation.active = str;
		
		set(h,'userdata',data);
		
		%--
		% update active annotation menus
		%--
		
		set(data.browser.annotate_menu.active,'check','off');
		
		set(get_menu(data.browser.annotate_menu.active,str),'check','on');
		
	end
	
%---------------------------
% ANNOTATE
%---------------------------

% NOTE: at the moment this initiates the annotation dialog, eventually just opens palette

case strcat(ANNOT_NAME, ' ...')
	
	% TEST CODE
	
	%--
	% batch annotation of active log
	%--
	
	%--
	% call annotation in interactive batch mode
	%--
	
	ANNOT = data.browser.annotation.annotation;
	
	ixa = find(strcmp(ANNOT_NAME, str(1:end - 4)));
	
	%--
	% compute measurement for active log
	%--
	
	m = data.browser.log_active; ix = 1:data.browser.log(m).length;
	
	feval(ANNOT(ixa).fun, 'events', h, m, ix);
	
	%--
	% update display
	%--
	
	browser_display(h, 'events');
	
	%--
	% update event palette
	%--
	
	update_find_events(h);
	
end
