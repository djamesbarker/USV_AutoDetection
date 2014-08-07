function flag = log_file_menu(h,str,flag)

% log_file_menu - browser file function menu
% ----------------------------------------------
%
% flag = log_file_menu(h,str,flag)
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
% $Date: 2005-12-06 08:24:51 -0500 (Tue, 06 Dec 2005) $
% $Revision: 2202 $
%--------------------------------

%----------------------------------------------------------------------
% SETUP
%----------------------------------------------------------------------

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
			log_file_menu(h,str{k}); 
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

%----------------------------------------------------------------------
% CREATE MENU
%----------------------------------------------------------------------

%------------------------------------------------
% Initialize
%------------------------------------------------

case ('Initialize')
	
	% add code to make sure menu is created. create while menu does not
	% exist

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
		'File', ...
		'Save Figure', ...
		'Save Figure As ...', ...
		'Export Figure ...', ...
		'Page Setup ...', ...
		'Print Preview ...', ...
		'Print ...', ...
		'Close' ...			
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	
	S{5} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	A{end - 1} = 'P';
	A{end} = 'W';
	
	tmp = menu_group(h,'log_file_menu',L,S,A);
	
	data.browser.file_menu.file = tmp;
	
	set(tmp(1),'position',1);
	
	set(get_menu(tmp,'View Settings'),'enable','off');
	
	set(get_menu(tmp,'Save View Settings ...'),'enable','off');
	
	%--
	% save userdata
	%--
	
	set(gcf,'userdata',data);
	
%----------------------------------------------------------------------
% MENU COMMANDS
%----------------------------------------------------------------------

%------------------------------------------------
% New Log ...
%------------------------------------------------

case ('New Log ...')
	
	%--
	% setup log palette
	%--
	
	out = browser_palettes(h,'Log');
	
	data = get(h,'userdata');
	
	palette_toggle(h,'Log','Active','open',data);
	
	palette_toggle(h,'Log','Display','close',data);
	
	palette_toggle(h,'Log','Options','close',data);
	
	%--
	% trigger open log state
	%--
	
	c = findobj(out,'tag','New Log');
	
	browser_controls(h,'New Log',c);
	
%------------------------------------------------
% Open Log ...
%------------------------------------------------

case ('Open Log ...')

	log_open(h);
	
%------------------------------------------------
% Page Setup ...
%------------------------------------------------

case ('Page Setup ...')
	
	pagesetupdlg(h);
	
%------------------------------------------------
% Print Preview ...
%------------------------------------------------

case ('Print Preview ...')
	
	printpreview(h); 
	
%------------------------------------------------
% Print ...
%------------------------------------------------

case ('Print ...')
	
	printdlg(h);
	
%------------------------------------------------
% Save Figure ...
%------------------------------------------------

case ('Save Figure')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% check for save location
	%--
	
	if (isempty(data.browser.save))
		
		log_file_menu(h,'Save Figure As ...');
		return;
		
	else
		
		fig_save(h,data.browser.save);
		
	end
	
%------------------------------------------------
% Save Figure As ...
%------------------------------------------------

case ('Save Figure As ...')
	
	%--
	% get location to save
	%--
	
	[fn,p] = uiputfile( ...
   		{ ...
			'*.fig', 'MATLAB Figure Files (*.fig)'; ...
			'*.*','All Files (*.*)' ...
		}, ...
		'Save Figure As ...' ...
	);

	%--
	% save file if put file completed
	%--
	
	if (fn)
		
		%--
		% update browser save
		%--
		
		tmp = [p filesep fn];
		
		data.browser.save = tmp;
		set(h,'userdata',data);
		
		%--
		% save figure
		%--
		
		fig_save(h,tmp);
		
	end
	
%------------------------------------------------
% Export Figure ...
%------------------------------------------------

case ('Export Figure ...')
	
	% add preference setting for printing with and without the uicontrols
	
	export_figure(h);
		
%------------------------------------------------
% Close
%------------------------------------------------

case ('Close')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% give option to save session and close browser figure
	%--
	
	name = get(h,'name');
	[tmp,name] = strtok(name,'-');
	name = name(4:end);
	
	ans = quest_dialog( ...
		['Close ''' name ''' log browser?'],' XBAT Question  -  Close');
	
	%--
	% exit browser or cancel
	%--
	
	if (isempty(ans) | strcmp(ans,'Cancel') | strcmp(ans,'No'))
		return;
	else
	
		%--
		% update parent list of children
		%--
		
		parent = get(data.browser.parent,'userdata');
		parent.browser.children = setdiff(parent.browser.children,h);
		set(data.browser.parent,'userdata',parent);
		
		%--
		% delete figure and update window menu
		%--
		
		delete(h);
		browser_window_menu;
		
	end
	
% %------------------------------------------------
% % Close
% %------------------------------------------------
% 
% case ('Close')
% 		
% 	%--
% 	% get userdata
% 	%--
% 	
% 	data = get(h,'userdata');
% 	
% 	%--
% 	% confirm and save updates to sound file
% 	%--
% 		
% 	browser_sound_save(h,data);
% 	
% 	%--
% 	% delete children and palettes
% 	%--
% 	
% 	try
% 		delete(data.browser.children);
% 	end
% 	
% 	try
% 		delete(data.browser.palettes);
% 	end
% 				
% 	%--
% 	% check for open logs and save before closing
% 	%--
% 		
% 	if (data.browser.log_active)
% 		
% 		%--
% 		% get logs
% 		%--
% 		
% 		log = data.browser.log;
% 		
% 		%--
% 		% update open state and save logs
% 		%--
% 		
% 		for k = 1:length(log)
% 			
% 			log(k).open = 0;
% 			
% 			log(k).sound = sound_update(data.browser.sound,data);
% 			
% 			log_save(log(k));
% 			
% 			%--
% 			% create backup of log
% 			%--
% 			
% 			log_backup(log(k));
% 			
% 		end
% 		
% 	end
% 		
% 	%--
% 	% delete parent
% 	%--
% 	
% 	% add fault tolerance to log saving, catch failure and abort closing 
% 	
% 	delete(h);
% 		
% 	%--
% 	% update window menu
% 	%--
% 	
% 	browser_window_menu;
	
end

%--------------------------------
% EXPORT_FIGURE
%--------------------------------

function export_figure(h,formats)

% export_file - export figure to file
% -----------------------------------
%
% export_figure(h,formats)
%
% Input:
% ------
%  h - figure handle
%  formats - available export formats

%--
% set default formats
%--

if ((nargin < 2) | isempty(formats))
	formats = { ...
		'*.emf', 'Enhanced Metafiles (*.emf)', 'meta'; ...
		'*.eps', 'Encapsulated PostScript (*.eps)', 'epsc2'; ...
		'*.tif', 'TIFF Images (*.tif)', 'tiff'; ...
		'*.jpg', 'JPEG Images (*.jpg)', 'jpeg'; ...
		'*.png', 'PNG Images (*.png)', 'png' ...
	};
end

% only the color EPS export is really useful
	
% BMP is low quality and the fonts are not right

% illustrator format file does not open in current versions

%--
% get raw extensions from formats
%--

for k = 1:size(formats,1)
	exts{k} = formats{k,1}(3:end); 
end

%--
% get file type and location interactively
%--

[fn,p,fix] = uiputfile(formats(:,1:2),['Export Figure ...']);

%--
% print figure to file according to export options
%--

if (fn)
	
	%--
	% handle filename
	%--
	
	ix = findstr(fn,'.'); % check for extension separator
	
	if (isempty(ix))
		
		%--
		% add extension using information from menu
		%--
				
		fn = [fn '.' exts{fix}];
		
	else
		
		%--
		% check that extension is available from available extensions
		%--
		
		tmp = fn((ix(end) + 1):end);
				
		ix = find(strcmp(exts,tmp));
		
		if (isempty(ix))
			
			fn = [fn '.' ext]; % append extension
			
		else
						
			fix = ix; % update file export option
			
		end

	end
	
	%--
	% print file based on extension
	%--
	
	mode = get(h,'paperpositionmode');
	
	set(h,'paperpositionmode','auto');
		
	print(['-f' int2str(h)],['-d' formats{fix,3}],[p fn]);
	
	set(h,'paperpositionmode',mode);
	
end
