function out = browser_file_menu(h,str,flag)

% browser_file_menu - browser file function menu
% ----------------------------------------------
%
% out = browser_file_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - info flag (def: 0)
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
% $Date: 2005-12-06 08:24:51 -0500 (Tue, 06 Dec 2005) $
% $Revision: 2202 $
%--------------------------------

%----------------------------------------------------------------------
% SETUP
%----------------------------------------------------------------------

%--
% set info output flag
%--

if ((nargin < 3) | isempty(flag))
	flag = 0;
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

% a cell array of strings as input performs a sequence of commands

if (iscell(str))
	
	for k = 1:length(str)
		try
			browser_file_menu(h,str{k}); 
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
% set default output
%--

out = [];

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
		'New Log ...', ...		
		'Open Log ...', ...		
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
	
	S{4} = 'on';
	S{7} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	A{2} = 'N';
	A{3} = 'O';
	A{end - 1} = 'P';
	A{end} = 'W';
	
	tmp = menu_group(h,'browser_file_menu',L,S,A);
	
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
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
		
	new_log_dialog;
	
%------------------------------------------------
% Open Log ...
%------------------------------------------------

case ('Open Log ...')

	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
		
	log_open(h);
	
%------------------------------------------------
% Page Setup ...
%------------------------------------------------

case ('Page Setup ...')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
	
		return;
		
	end
		
	pagesetupdlg(h);
	
%------------------------------------------------
% Print Preview ...
%------------------------------------------------

case ('Print Preview ...')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = 'Play Page';
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
		
	printpreview(h); 
	
%------------------------------------------------
% Print ...
%------------------------------------------------

case ('Print ...')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
		
	printdlg(h);
	
%------------------------------------------------
% Save Figure ...
%------------------------------------------------

case ('Save Figure')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
		
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% check for save location
	%--
	
	if (isempty(data.browser.save))
		
		browser_file_menu(h,'Save Figure As ...');
		return;
		
	else
		
		fig_save(h,data.browser.save);
		
	end
	
%------------------------------------------------
% Save Figure As ...
%------------------------------------------------

case ('Save Figure As ...')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
		
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
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
		
	% add preference setting for printing with and without the uicontrols
	
	export_figure(h);
		
%------------------------------------------------
% Close
%------------------------------------------------

case ('Close')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'File'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
	
		out = info;
		
		return;
		
	end

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% confirm and save updates to sound file
	%--
		
	% NOTE: this innocuous looking functions is doing quite a bit
	
	browser_sound_save(h,data);
	
	%--
	% delete children and palettes
	%--
	
	% NOTE: this function is capable of finding neglected children and destroying them
	
	tmp = get_xbat_figs('parent',h);
	
	try
		delete(tmp);
	end
	
% 	try
% 		delete(data.browser.children);
% 	end
% 	
% 	try
% 		delete(data.browser.palettes);
% 	end
				
	%--
	% check for open logs and save before closing
	%--
		
	if (data.browser.log_active)
		
		%--
		% get logs
		%--
		
		log = data.browser.log;
		
		%--
		% update open state and save logs
		%--
		
		for k = 1:length(log)
			
			log(k).open = 0;
			
			log(k).sound = sound_update(data.browser.sound, data);
			
			log_save(log(k));
			
			%--
			% create backup of log
			%--
			
			log_backup(log(k));
			
		end
		
	end
		
	%--
	% stop daemons if needed
	%--
	
	% NOTE: the only remaining sound browser is being closed right now
	
	if (length(get_xbat_figs('type','sound')) == 1)
		
		% TODO: centralized management for daemons
		
		timer_stop('XBAT Browser Daemon');
		
		timer_stop('XBAT Scrolling Daemon');
	
		timer_stop('XBAT Jogging Daemon');
	
	end
	
	%--
	% show another browser and delete this one
	%--
	
	% NOTE: we may add fault tolerance to log saving, catch failure and abort close 

	show_browser(h,'previous'); 
	
	delete(h);
		
	%--
	% update window menu
	%--
	
	browser_window_menu;
	
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
% set default available formats
%--

% NOTE: only the color EPS export is really useful
	
% NOTE: BMP is low quality and the fonts are not right

% NOTE: illustrator format file does not open in current versions

if ((nargin < 2) | isempty(formats))
	formats = { ...
		'*.emf', 'Enhanced Metafiles (*.emf)', 'meta'; ...
		'*.eps', 'Encapsulated PostScript (*.eps)', 'epsc2'; ...
		'*.tif', 'TIFF Images (*.tif)', 'tiff'; ...
		'*.jpg', 'JPEG Images (*.jpg)', 'jpeg'; ...
		'*.png', 'PNG Images (*.png)', 'png' ...
	};
end

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
