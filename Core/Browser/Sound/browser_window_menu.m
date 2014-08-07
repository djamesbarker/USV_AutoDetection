function out = browser_window_menu(h, str, flag)

% browser_window_menu - track and arrange open windows
% ----------------------------------------------------
%
% browser_window_menu(h, str, flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - info flag (def: '')
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
% $Revision: 2199 $
% $Date: 2005-12-05 17:57:23 -0500 (Mon, 05 Dec 2005) $
%--------------------------------

% NOTE: this function should be made as efficient as possible

%--------------------------------------------------------
% SETUP
%--------------------------------------------------------

%--
% set default output
%--

out = [];

%--
% get sound and log browser figures
%--

% NOTE: these handles are used whether or not we are rebuilding

XBAT_FIGS = [ ...
	get_xbat_figs('type','sound'); get_xbat_figs('type','log') ...
];

N = length(XBAT_FIGS);

%--------------------------------------------------------
% REBUILD MENUS
%--------------------------------------------------------

% NOTE: a call with no input is a request to rebuild menus for all

if (nargin < 1) || isempty(h)
	
	%--
	% delete old and create new window menus
	%--
	
	for k = 1:N
		
		g = get_menu(XBAT_FIGS(k), 'Window'); delete(findall(g, 'type', 'uimenu'));
		
		browser_window_menu(XBAT_FIGS(k), 'Initialize');

	end
	
	%--
	% perform window menu command
	%--
	
	% TODO: test calling menu command on all figures when provided
	
	if (nargin > 1) && ~isempty(str)
		
		for k = 1:N
			browser_window_menu(XBAT_FIGS(k), str);
		end

	end
	
	return;
	
end

%--------------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------------

%--
% set info output flag
%--

if (nargin < 3) || isempty(flag)
	flag = 0;
end

%--
% set command string
%--

if nargin < 2
	str = 'Initialize';
end

%--------------------------------------------------------
% SETUP
%--------------------------------------------------------
	
%--
% get figure tags and names
%--

TAG = get(XBAT_FIGS, 'tag'); 

NAME = get(XBAT_FIGS, 'name');
	
if (N == 1)
	TAG = {TAG}; NAME = {NAME};
end

%--
% parse window names and get parent from name
%--

% TODO: replace this with some use of 'get_xbat_figs', possibly a separate function

% NOTE: this should allow renaming of figures in more dynamic ways

% NOTE: the parentage information should not be extracted from name!

for k = 1:N
	
	%--
	% separate prefix from name
	%--
	
	[str1, str2] = strtok(NAME{k}, '-');
	
	%--
	% separate name from parent
	%--
	
	str2 = strip_blanks(str2(2:end));
	
	ix = findstr(str2, '(');
	
	if isempty(ix)
		
		NAME{k} = str2; SEP{k} = 'off'; 
		
	else
		
		str3 = str2((ix + 1):(end - 1));
		
		NAME{k} = [str3 '  -  ' str2(1:(ix - 3)) '  (Log)']; SEP{k} = 'off';
		
	end
	
end

%--
% get names of available sound browser palettes
%--

PAL_SOUND = browser_palettes;

% NOTE: escape of ampersands in palette names to create menu labels

for k = 1:length(PAL_SOUND)
	PAL_SOUND{k} = strrep(PAL_SOUND{k}, '&', '&&'); 
end

%--
% get names of available widgets
%--

widgets = get_extensions('widget');

WIDGET_NAME = {widgets.name}';

for k = 1:length(WIDGET_NAME)
	WIDGET_NAME{k} = strrep(WIDGET_NAME{k}, '&', '&&'); 
end

%--
% get names of available log browser palettes
%--

PAL_LOG = log_browser_palettes;

% NOTE: escape of ampersands in palette names to create menu labels

for k = 1:length(PAL_LOG)
	PAL_LOG{k} = strrep(PAL_LOG{k}, '&', '&&'); 
end

%--------------------------------------------------------
% MENU COMMANDS
%--------------------------------------------------------

switch str

%--------------------------------------------------------
% Initialize
%--------------------------------------------------------

case 'Initialize'
	
	%--
	% check for existing menu
	%--
	
	if get_menu(h, 'Window')
		return;
	end
	
	%--
	% check figure type to attach palettes
	%--
		
	% TODO: there should be a cleaner way of doing this
	
	if strncmp(get(h,'tag'), 'XBAT_SOUND_BROWSER', length('XBAT_SOUND_BROWSER'))
		PAL = PAL_SOUND;
	else
		PAL = PAL_LOG;
	end
	
	%--
	% create window menu
	%--

	if N > 1
		
		% NOTE: sort the names and separators
		
		[NAME, ix] = sort(NAME); SEP = SEP(ix);
		
		L = { ...
			'Window', ...
			'Cascade', ...
			'Arrange', ...
			'Tile', ...
			'Half Size', ...
			'Actual Size', ...
			'Tile Related', ...
			'Hide Palettes', ...
			'TOGGLE_OTHERS', ...
			'TOGGLE_DESKTOP', ...
			'(Palettes)', ...
			'Palette Presets', ...
			PAL{:}, ...
			'(Widgets)', ...
			WIDGET_NAME{:}, ...
			'(Sounds)', ...
			NAME{:} ...
		};
	
	else
		
		L = { ...
			'Window', ...
			'Cascade', ...
			'Arrange', ...
			'Tile', ...
			'Half Size', ...
			'Actual Size', ...
			'Tile Related', ...
			'Hide Palettes', ...
			'TOGGLE_OTHERS', ...
			'TOGGLE_DESKTOP', ...
			'(Palettes)', ...
			'Palette Presets', ...
			PAL{:}, ...
			'(Widgets)', ...
			WIDGET_NAME{:}, ...
			'(Sounds)', ...
			NAME{:} ...
		};
	
	end
	
	n = length(L);
	
	PAL_SEP = bin2str(zeros(1, length(PAL)));
	
	WID_SEP = bin2str(zeros(1, length(WIDGET_NAME)));
	
	if ischar(PAL_SEP)
		PAL_SEP = {PAL_SEP};
	end
	
	if ischar(WID_SEP)
		WID_SEP = {WID_SEP};
	end
	
% 	PAL_SEP{1} = 'on';
	
% 	SEP{1} = 'on';
		
	S = { ...
		'off', ...
		'off', ...
		'off', ...
		'off', ...
		'on', ... % Half Size
		'off', ...
		'off', ...
		'off', ...
		'off', ...
		'off', ... % (Palettes)
		'off', ... % Preset
		'off', ...
		PAL_SEP{:}, ...
		'on', ... % (Widgets)
		WID_SEP{:}, ...
		'on', ... % (Sounds)
		SEP{:} ...
	};
		
	mg = menu_group(h, 'browser_window_menu', L, S);
		
	%--
	% set some keyboard accelerators and some other properties
	%--
	
	% NOTE: these are older accelerators
	
	set(get_menu(mg,'Cascade'),'accelerator','S');
	
	set(get_menu(mg,'Arrange'),'accelerator','R');
	
	set(get_menu(mg,'Tile'),'accelerator','T');
	
	set(get_menu(mg,'Hide Palettes'), ...
		'separator','on' ...
	);
	
	% NOTE: disable information display menus and separate sections
	
	set(get_menu(mg,'(Palettes)'), ...
		'enable', 'off', ...
		'separator', 'on' ...
	);

	set(get_menu(mg,'(Widgets)'), ...
		'enable', 'off', ...
		'separator', 'on' ...
	);
	
	set(get_menu(mg,'(Sounds)'), ...
		'enable', 'off', ...
		'separator', 'on' ...
	);
	
	% NOTE: WE HIDE TILE RELATED COMMAND
	
	set(get_menu(mg,'Tile Related'),'visible','off');
	
	%--
	% update hide/show labels based on states
	%--
	
	% TOGGLE_DESKTOP
	
	switch (show_desktop)
		case (0)
			desk_label = 'Show Desktop';
		case (1)
			desk_label = 'Hide Desktop';
	end
	
	set(get_menu(mg,'TOGGLE_DESKTOP'), ...
		'label', desk_label, ...
		'separator', 'off' ...
	);

	% TOGGLE_OTHERS
	
	switch (show_other_sounds)
		
		case (0)
			other_label = 'Show Others'; other_state = 'off';
			
		case (1)
			other_label = 'Hide Others'; other_state = 'on';
			
	end
	
	set(get_menu(mg,'TOGGLE_OTHERS'), ...
		'label', other_label, ...
		'separator', 'off' ...
	);

	% NOTE: hiding is more disoncerting than disabling, don't do it
	
	set(get_menu(h,'Cascade'),'enable',other_state);
	
	set(get_menu(h,'Arrange'),'enable',other_state);
	
	set(get_menu(h,'Tile'),'enable',other_state);

	%--
	% position top level menus
	%--
		
	% TODO: move the positioning of most menus to a function called after
	% browser creation, this is often exceptions that slow down the system
	
	% NOTE: this is hard coded and may change as new menus are added
	
	if (strcmp(get_field(parse_tag(get(h,'tag')),'type'),'XBAT_SOUND_BROWSER'))
	
		set(mg(1),'position',11);
		
		set(get_menu(h,'Help'),'position',12);
				
	end
	
	%--
	% update hide palettes menu based on state
	%--
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	data = get(h,'userdata');
	
	if (~data.browser.palette_display)
		set(get_menu(mg,'Hide Palettes'),'label','Show Palettes');
	end	
	
	% NOTE: remove record palette menu for static sounds
		
	if (isfield(data.browser.sound,'input'))
		
		if (isempty(data.browser.sound.input))

			temp = findobj(mg,'label','Record');

			if (~isempty(temp))
				delete(temp); mg = setdiff(mg,temp);
			end 

		end

	end
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%--
	% Tile Related
	%--
	
	L = { ...
		'Default', ...
		'Row Oriented', ...
		'Column Oriented' ...
	};
	
	n = length(L);
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	
	menu_group(get_menu(mg,'Tile Related'),'browser_window_menu',L,S);
	
% 	%--
% 	% MATLAB Command Window
% 	%--
% 	
% 	set(get_menu(mg,'MATLAB Command Window'), ...
%   		'callback','uimenufcn(gcbf,''WindowCommandWindow'')', ...
% 		'accelerator','M' ...
% 	);

	%--
	% Configuration
	%--
	
	% NOTE: we get the preset structures and the filenames, the names don't have extension
	
	[presets,names] = get_palette_presets;
	
	names = file_ext(names);
	
	if (isempty(presets))
		
		L = { ...
			'New Preset ...', ...
			'Show Presets ...' ...
		};
	
		S =  { ...
			'off', ...
			'off' ...
		};
		
	else
				
		L = { ...
			names{:}, ...
			'New Preset ...', ...
			'Show Presets ...' ...
		};
	
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{end - 1} = 'on';
		
	end
	
	mg = menu_group(get_menu(mg,'Palette Presets'),'',L,S);
	
	set(mg,'callback',{@palette_preset_handler,h});
	
	%--
	% MATLAB Editor
	%--
	
	% reset callback of parent menu
	
% 	set(mg(1),'callback',['browser_window_menu(' num2str(h) ',''Window'');']);
	
	% NOTE: this update will be performed every time the main menu is opened
	% no need to initialize this menu here, since it would slow down the
	% window menu update for XBAT windows
	
%--------------------------------
% Arrange
%--------------------------------

case 'Arrange'
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% return for single figure display
	%--
	
	if (length(XBAT_FIGS) == 1)
		return;
	end
	
	%--
	% stop figure display daemons
	%--
	
	pd = timerfind('name','XBAT Palette Daemon'); stop(pd);
	
	bd = timerfind('name','XBAT Browser Daemon'); stop(bd); 
	
	%--
	% sort all windows using menu names (preserve relation order)
	%--
	
	[tmp,ix] = sort(NAME);
	XBAT_FIGS = XBAT_FIGS(ix);
	
	%--
	% tile windows
	%--

	figs_arrange(XBAT_FIGS);

	%--
	% set display order of figures
	%--
	
	for k = 1:length(XBAT_FIGS)
		tmp = get(XBAT_FIGS(k),'position');
		pos(k) = tmp(1);
	end
	
	[tmp,ix] = sort(pos);
	
	for k = 1:length(XBAT_FIGS)
		figure(XBAT_FIGS(ix(k)));
	end
	
	%--
	% start daemons
	%--
		
	start(pd); start(bd);
	
%--------------------------------
% Hide/Show Desktop
%--------------------------------

case ('TOGGLE_DESKTOP')
		
	%--
	% toggle desktop display state, update menus, and recover focus
	%--
	
	show_desktop(~show_desktop);
	
	browser_window_menu; % NOTE: the new window menu will reflect the right state
	
	figure(h);
	
%--------------------------------
% Hide/Show Others
%--------------------------------

case ('TOGGLE_OTHERS')
		
	%--
	% toggle other sounds display state, update menus, and recover focus
	%--
	
	show_other_sounds(~show_other_sounds); 
	
	browser_window_menu; % NOTE: the new window menu will reflect the right state
	
	figure(h); 
	
	% NOTE: this updates the visibility of others
	
	browser_palettes(h, 'Show');
	
%--------------------------------
% Cascade
%--------------------------------

case ('Cascade')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% return for single figure display
	%--
	
	if (length(XBAT_FIGS) == 1)
		return;
	end
	
	%--
	% stop figure display daemons
	%--
	
	pd = timerfind('name','XBAT Palette Daemon'); stop(pd);
	
	bd = timerfind('name','XBAT Browser Daemon'); stop(bd); 
	
	%--
	% sort all windows using menu names (preserve relation order)
	%--
	
	[tmp, ix] = sort(NAME);
	
	XBAT_FIGS = XBAT_FIGS(ix);
	
	%--
	% tile windows
	%--
	
	figs_cascade(XBAT_FIGS);

	%--
	% set display order of figures
	%--
	
	for k = 1:length(XBAT_FIGS)
		tmp = get(XBAT_FIGS(k),'position');
		pos(k) = tmp(1);
	end
	
	[tmp,ix] = sort(pos);
	
	for k = 1:length(XBAT_FIGS)
		figure(XBAT_FIGS(ix(k)));
	end
	
	%--
	% start daemons
	%--
		
	start(pd); start(bd);
	
%--------------------------------
% Tile
%--------------------------------

case ('Tile')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% return for single figure display
	%--
	
	if (length(XBAT_FIGS) == 1)
		return;
	end
	
	%--
	% stop figure display daemons
	%--
	
	pd = timerfind('name','XBAT Palette Daemon');
	stop(pd);
	
	bd = timerfind('name','XBAT Browser Daemon');
	stop(bd); 
	
	%--
	% sort all windows using menu names (preserve relation order)
	%--
	
	[tmp,ix] = sort(NAME);
	XBAT_FIGS = XBAT_FIGS(ix);
	
	%--
	% tile windows
	%--
	
	figs_tile(XBAT_FIGS);
	
	%--
	% start daemons
	%--
		
	start(pd);
	start(bd);

%--------------------------------
% Tile Related
%--------------------------------

case ({'Default','Row Oriented','Column Oriented'})
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% get and parse current figure's name
	%--
	
	name = get(gcf,'name');
	
	% separate prefix from name
	
	[str1,str2] = strtok(name,'-');
	
	% separate name from parent
	
	str2 = strip_blanks(str2(2:end));
	ix = findstr(str2,'(');
	
	if (isempty(ix))
		name = str2;
	else
		name = str2((ix + 1):(end - 1));
	end

	%--
	% get related windows
	%--

	ix = [];
	len = length(name);
	for k = 1:N
		if (strcmp(name,NAME{k}) | strncmp([name ' '],NAME{k}, len + 1))
			ix = [ix, k];
		end
	end
	
	NAME = NAME(ix);
	XBAT_FIGS = XBAT_FIGS(ix);
	
	[tmp,ix] = sort(NAME);
	XBAT_FIGS = XBAT_FIGS(ix);
	
	%--
	% tile windows
	%--
	
	if (length(XBAT_FIGS) == 1);	
		fig_sub(1,1,1,XBAT_FIGS(1));
		figure(XBAT_FIGS(1));
		return;
	end
	
	switch (str)
		
	case ('Default')
		
		%--
		% tile figures
		%--
		
		figs_tile(XBAT_FIGS);
		
		%--
		% enforce resize
		%--
		
		for k = 1:length(tmp)
			figure(XBAT_FIGS(k));
			if (~isempty(findstr(tmp{k},'(Log)')))
				log_resizefcn(XBAT_FIGS(k));
			else
				browser_resizefcn(XBAT_FIGS(k));
			end
		end
		
	case ('Row Oriented')
		
		%--
		% tile figures in row oriented way 
		%--
		
		fig_sub(2,1,1,XBAT_FIGS(1));
		figure(XBAT_FIGS(1));
		
		n = length(XBAT_FIGS) - 1;
		for k = 1:n
			fig_sub(2,n,n + k,XBAT_FIGS(k + 1));
			figure(XBAT_FIGS(k + 1));
		end
		
		%--
		% enforce resize
		%--
		
		browser_resizefcn(XBAT_FIGS(1));
		
		for k = 2:length(XBAT_FIGS)
			log_resizefcn(XBAT_FIGS(k));
		end
		
	case ('Column Oriented')
		
		%--
		% tile figures in row oriented
		%--
		
		fig_sub(1,2,1,XBAT_FIGS(1));
		figure(XBAT_FIGS(1));
		
		n = length(XBAT_FIGS) - 1;
		for k = 1:n
			fig_sub(n,2,2*k,XBAT_FIGS(k + 1));
			figure(XBAT_FIGS(k + 1));
		end
		
		%--
		% enforce resize
		%--
		
		browser_resizefcn(XBAT_FIGS(1));
		
		for k = 2:length(XBAT_FIGS)
			log_resizefcn(XBAT_FIGS(k));
		end
		
	end
	
%--------------------------------
% XBAT
%--------------------------------

case ('XBAT')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	xbat_palette;
	
%--------------------------------
% NAME (named window)
%--------------------------------

case (NAME)

	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% bring window to front
	%--
	
	ix = find(strcmp(NAME,str));
	
	if (length(ix) > 1)
				
		%--
		% get position of other menus with same label
		%--
		
		tmp = get(get(gcbo,'parent'),'children');
		tmp = findobj(tmp,'label',get(gcbo,'label'));
		
		%--
		% find position of current menu in list
		%--
		
		ixl = find(sort(cell2mat(get(tmp,'position'))) == get(gcbo,'position'));
		
		%--
		% select the figure that shares position in list
		%--
		
		tmp = sort(XBAT_FIGS(ix));
		g = tmp(ixl);
		
	else
		
		g = XBAT_FIGS(ix);
		
	end
		
	figure(g);
	browser_palettes(g,'Show');
	figure(g);
	
%--------------------------------
% Half Size, Actual Size
%--------------------------------

case ({'Half Size','Actual Size'})
	
	%--
	% get type of figure from figure tag
	%--
	
	type = get_field(parse_tag(get(h,'tag')),'type');
	
	%--
	% handle clip viewer separately
	%--
	
	if (strcmp(type,'XBAT_LOG_BROWSER'))
		log_view_menu(gcf,str); return;
	end
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	im = data.browser.images;
	
	%--
	% get desired scaling
	%--
	
	str = strtok(str,' ');
	
	%--
	% get initial figure position
	%--
	
	pos = get(h,'position');
		
	%--
	% compute according to desired scaling
	%--
	
	[m,n,d] = size(get(im(1),'cdata'));
	
	%--
	% scale the number of rows based on the page frequency settings
	%--
		
	if (~isempty(data.browser.page.freq))
		m = round(2 * m * diff(data.browser.page.freq) / data.browser.sound.samplerate);
	end
	
	% NOTE: consider computing the size along with the resize function
	
	%--
	% scale according to desired image size fraction
	%--
	
	switch (str)
		
		case ('Half'), m = round(m / 2); n = round(n / 2);  

		case ('Actual')
		
		case ('Double'), m = 2 * m; n = 2 * n;

	end

	%--
	% get figure size from image size
	%--
	
	ch = length(im); 
	
	color = ~isempty(data.browser.colorbar); 
	
	slider = get_time_slider(h); slider = strcmpi(get(slider.handle(1), 'visible'), 'on');
	
	[figw, figh] = browser_imsize_to_figsize(n, m, ch, 1, color, slider);
	
	%--
	% get-modify-set figure 'position'
	%--
	
	% TODO: make this into a function
	
	tmp = get(h,'position');
	
	pos(3) = figw; 
	
	pos(4) = figh;
	
	% NOTE: this makes top left corner stay fixed
	
	pos(2) = tmp(2) - (pos(4) - tmp(4));
	
	set(h, 'position', pos);
		
%--------------------------------
% Refresh
%--------------------------------

% TODO: update menu creation code to be more dynamic

case ('Hide Palettes')
	
	%--
	% update visibility state, actual visibility and menu
	%--
	
	data = get(h,'userdata');
	
	if (data.browser.palette_display)
		
		data.browser.palette_display = 0;
		
		palette_display(h,'off');
		
		set(get_menu(h,'Hide Palettes'),'label','Show Palettes');
		
	else
		
		data.browser.palette_display = 1;
		
		palette_display(h,'on');
		
		set(get_menu(h,'Show Palettes'),'label','Hide Palettes');
			
	end
	
	set(h,'userdata',data);
	
	%--
	% set focus on parent
	%--
	
% 	figure(h);
	
%--------------------------------
% Refresh
%--------------------------------

case ('Refresh')
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	refresh(h);
	
%--------------------------------
% Sound Browser Palette
%--------------------------------

% TODO: handle palette requests when palettes are hidden, first show, possibly position

case (PAL_SOUND)
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	% NOTE: we escape ampersands in palette name strings
	
	str = strrep(str, '&&', '&');
	
	[out, flag] = browser_palettes(h, str);

	%--
	% palette was recreated update last state if available
	%--
	
	if flag
		
		set(out, 'visible', 'off');
		
		%--
		% update state of palette if available
		%--
		
		data = get(h, 'userdata');
		
		if ~isempty(data.browser.palette_states)
			
			names = struct_field(data.browser.palette_states, 'name');
			
			ix = find(strcmp(names, str));
			
			if ~isempty(ix)
				set_palette_state(out, data.browser.palette_states(ix));
			end
			
		end
		
		set(out, 'visible', 'on');
		
	end
	
%--------------------------------
% Sound Browser Palette
%--------------------------------

% TODO: handle palette requests when palettes are hidden, first show, possibly position

case WIDGET_NAME
	
	par = h;
	
	%--
	% get widget extension
	%--
	
	% NOTE: this gets the extension with saved state
	
	[ext, ignore, context] = get_browser_extension('widget', par, str);
	
	%--
	% create widget if needed
	%--
	
	% NOTE: create widget will ensure singleton condition
	
	if ~isempty(ext) 
		create_widget(par, ext, context);
	end 
	
%--------------------------------
% Log Browser Palette
%--------------------------------

case PAL_LOG
	
	%-------
	% INFO
	%-------
	
	if (flag)
		
		info.name = str;
		info.category = 'Window'; 
		info.description = [ ...
			'Play currently displayed page. ' ...
			'When there is no designated left and right channels are played, ' ...
			'otherwise only the selection channel is played' ...
		];
		
		out = info;
		
		return;
		
	end
	
	% handle escaped ampersands in palette name strings
	
	str = strrep(str,'&&','&');
	
	log_browser_palettes(h,str);
	
%--
% Rebuild Window menus
%--

otherwise
	
	browser_window_menu;
	
end
	
	
%-----------------------------------------------------------
% PALETTE_PRESET_HANDLER
%-----------------------------------------------------------

function palette_preset_handler(obj,eventdata,h)

% palette_preset_handler - handle creation and loading of palette presets
% -----------------------------------------------------------------------

% TODO: find a way to exclude extension palettes from the state

% TODO: put load into a function to allow programmatic loading

%--
% get menu label
%--

label = get(obj,'label');

%-------------------------------
% COMMAND SWITCH
%-------------------------------

switch (label)
	
	%-------------------------------
	% NEW PRESET
	%-------------------------------
	
	case ('New Preset ...')
		
		%--
		% create dialog controls
		%--
		
		% NOTE: the 'min' value makes header non-collapsible
		
		control(1) = control_create( ...
			'style','separator', ...
			'type','header', ...
			'min',1, ... 
			'string','Palette Preset', ...
			'space',0.75 ...
		);
		
		control(end + 1) = control_create( ...
			'name','name', ...
			'alias','Name', ...
			'style','edit', ...
			'value','New Preset' ...
		);
	
		control(end + 1) = control_create( ...
			'name','extensions', ...
			'alias','Keep extension palettes', ...
			'style','checkbox', ...
			'lines',0, ...
			'value',0, ...
			'space',0.75 ...
		);

		control(end + 1) = control_create( ...
			'name','sound', ...
			'alias','Keep browser position', ...				
			'lines',0, ...
			'style','checkbox', ...
			'value',0 ...
		);
		
		% 'space',-1, ... % this would move the buttons up
		
		%--
		% create dialog and get values
		%--
		
		out = dialog_group('New Preset ...',control);
		
		% NOTE: empty values indicate cancel or abort
		
		if (isempty(out.values))
			return;
		end		
		
		values = out.values;
		
		%--
		% GET PALETTE CONFIGURATION
		%--
		
		% NOTE: configure 'get' based on dialog output
		
		opt = get_browser_state;
		
		opt.extension_palettes = values.extensions;
		
		state = get_browser_state(h,[],opt);
		
		% NOTE: decorate state with author so that we may possibly filter
		
		state.author = get_field(get_active_user,'name');
	
		%--
		% SAVE CONFIGURATION AND UPDATE MENUS
		%--
		
		p = [xbat_root, filesep, 'Presets', filesep, 'Palettes'];
		
		val = out.values.name;
		
		save([p, filesep, val, '.mat'],'state');
		
		% NOTE: this updates all open window menus
		
		browser_window_menu;
	
	%-------------------------------
	% SHOW PRESETS
	%-------------------------------
	
	case ('Show Presets ...')
		
		% NOTE: only works on windows at the moment
		
		str = ['!explorer /n,', xbat_root, filesep, 'Presets', filesep, 'Palettes', filesep, ' &'];

		eval(str);
							
	%-------------------------------
	% LOAD PRESET
	%-------------------------------
	
	% NOTE: the menu label in this case is simply the name of the preset
	
	% TODO: there are issues in renaming the preset files, since 'name' is a field
	
	otherwise

		%--
		% close current browser palettes
		%--
				
		g = get_xbat_figs('parent',h,'type','browser_palettes');
		
		if (~isempty(g))
			
			for k = 1:length(g)
				close(g(k));
			end 	
			
		end
		
		%--
		% load palette configuration
		%--
		
		% TODO: the catch should update the window menu, including the presets
		
		p = [xbat_root, filesep, 'Presets', filesep, 'Palettes'];
		
		try
			in = load([p, filesep, label, '.mat'],'state');
		catch
			browser_window_menu; return;
		end

		state = in.state;
				
		%--
		% set palette configuration
		%--
		
		% NOTE: configure 'set' to only load palette part of state
		
		opt = set_browser_state;
		
		opt.position = 0; opt.log = 0; opt.selection = 0;
		
		set_browser_state(h,state,opt);
		
end

