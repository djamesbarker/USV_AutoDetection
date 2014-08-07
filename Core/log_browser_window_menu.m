function log_browser_window_menu(h,str,flag)

% log_browser_window_menu - track and arrange open windows
% --------------------------------------------------------
%
% log_browser_window_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag (def: '')

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

%--
% enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Window'))
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
% get open figures and tags
%--

XBAT_FIGS = findobj(0,'type','figure');

N = length(XBAT_FIGS);
if (N > 1)
	TAG = get(XBAT_FIGS,'tag');
else
	TAG = {get(XBAT_FIGS,'tag')};
end

%--
% select figures based on tag
%--

for k = length(XBAT_FIGS):-1:1
	if ((length(TAG{k}) < 5) | ~strcmp(TAG{k}(1:5),'XBAT_'))	
		XBAT_FIGS(k) = [];
	end
end
	
%--
% remove palettes from list
%--

for k = length(XBAT_FIGS):-1:1
	
	tmp = 'XBAT_PALETTE';
	n = length(tmp);
	
	if ((length(TAG{k}) > n) & strncmp(TAG{k},tmp,n))
		XBAT_FIGS(k) = [];
	end
	
end

%--
% remove center from 
	
N = length(XBAT_FIGS);

%--
% update all window menus
%--

if (nargin < 1)
	
	%--
	% update window menus for all figures
	%--
	
	for k = 1:N
		
		%--
		% remove previous window menu children
		%--
		
		g = get_menu(XBAT_FIGS(k),'Window');
		
		delete(findall(g,'type','uimenu'));
		
		%--
		% recreate window menu
		%--
		
		log_browser_window_menu(XBAT_FIGS(k),'Initialize');
		
		%--
		% set position of help menu
		%--
		
% 		tmp = findobj(gcf,'type','uimenu','parent',gcf);
% 		n = length(tmp);
% 		
% 		tmp1 = get_menu(tmp,'Help');
% 		tmp2 = get_menu(tmp,'Window');
% 		
% 		if (~isempty(tmp1))
% 			set(tmp1,'position',n);
% 			set(tmp2,'position',n - 1);
% 		else
% 			set(tmp2,'position',n);
% 		end
		
	end
	
	return;
	
end

if (N > 1)
	TAG = get(XBAT_FIGS,'tag');
	NAME = get(XBAT_FIGS,'name');
else
	TAG = {get(XBAT_FIGS,'tag')};
	NAME = {get(XBAT_FIGS,'name')};
end

%--
% parse window names and get parent from name
%--

for k = 1:N
	
	%--
	% separate prefix from name
	%--
	
	[str1,str2] = strtok(NAME{k},'-');
	
	%--
	% separate name from parent
	%--
	
	str2 = strip_blanks(str2(2:end));
	ix = findstr(str2,'(');
	
	if (isempty(ix))
		NAME{k} = str2;
		SEP{k} = 'on';
	else
		str3 = str2((ix + 1):(end - 1));
		NAME{k} = [str3 '  -  ' str2(1:(ix - 3)) '  (Log)'];
		SEP{k} = 'off';
	end
	
end

%--
% get available palettes
%--

% sound browser palettes

PAL_SOUND = browser_palettes;

MS = length(PAL_SOUND);

for k = 1:MS
	PAL_SOUND{k} = strrep(PAL_SOUND{k},'&','&&'); % escape ampersands in palette names
end

% log browser palettes

% PAL_LOG = cell(0);
% 
% ML = 0;

PAL_LOG = log_browser_palettes;

ML = length(PAL_LOG);

for k = 1:ML
	PAL_LOG{k} = strrep(PAL_LOG{k},'&','&&'); % escape ampersands in palette names
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
	
	if (get_menu(h,'Window'))
		return;
	end
	
	%--
	% check figure type to attach palettes
	%--
	
	tmp = length('XBAT_SOUND_BROWSER');
	
	if (strncmp(get(h,'tag'),'XBAT_SOUND_BROWSER',n))
		PAL = PAL_SOUND;
		M = MS;
	else
		PAL = PAL_LOG;
		M = ML;
	end
	
	%--
	% create window menu
	%--

	if (N > 1)	
		
		[tmp,ix] = sort(NAME);
		SEP = SEP(ix);
		
		L = { ...
			'Window', ...
			'Cascade', ...
			'Tile', ...
			'Tile Related', ...
			'Half Size', ...
			'Actual Size', ...
			'Refresh', ...
			'MATLAB Command Window', ...
			'XBAT', ...
			PAL{:}, ...
			tmp{:} ...
		};
	
	else
		
		L = { ...
			'Window', ...
			'Cascade', ...
			'Tile', ...
			'Tile Related', ...
			'Half Size', ...
			'Actual Size', ...
			'Refresh', ...
			'MATLAB Command Window', ...
			'XBAT', ...
			PAL{:}, ...
			NAME{:} ...
		};
	
	end
	
	n = length(L);
	
	tmp = bin2str(zeros(1,M - 1));
	
	S = {'off','off','off','off','on','off','off','on','on','on',tmp{:},SEP{:}};
	
	A = cell(1,n);
	A{2} = 'R';
	A{3} = 'T';
	
	mg = menu_group(h,'log_browser_window_menu',L,S,A);
	
	% make sure that window and help menus stay in their positions. note
	% that this is hard coded at the moment and may change as new menus are
	% added
	
	set(mg(1),'position',9);
	
	set(get_menu(h,'Help'),'position',10);
	
	% handling this problem here could slow down the window menu update
	% requiring this menu to retrieve the userdata of the figures being
	% updated
	
% 	set(get_menu(mg,'Log'),'enable','off'); % no log palette when no logs open
	
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
	
	menu_group(get_menu(mg,'Tile Related'),'log_browser_window_menu',L,S);
	
	%--
	% MATLAB Command Window
	%--
	
	set(get_menu(mg,'MATLAB Command Window'), ...
  		'callback','uimenufcn(gcbf,''WindowCommandWindow'')', ...
		'accelerator','M' ...
	);

	%--
	% MATLAB Editor
	%--
	
	% reset callback of parent menu
	
% 	set(mg(1),'callback',['log_browser_window_menu(' num2str(h) ',''Window'');']);
	
	% this update will be performed every time the main menu is opened
	% no need to initialize this menu here, since it would slow down the
	% window menu update for XBAT windows
	
%--
% Cascade
%--

case ('Cascade')
	
	%--
	% sort all windows using menu names (preserve relation order)
	%--
	
	[tmp,ix] = sort(NAME);
	XBAT_FIGS = XBAT_FIGS(ix);
	
	%--
	% tile windows
	%--

	figs_cascade(XBAT_FIGS);
	
	%--
	% enforce resizefcn in case we forget
	%--
	
% 	for k = 1:length(tmp)
% 		figure(XBAT_FIGS(k));
% 		if (~isempty(findstr(tmp{k},'(Log)')))
% 			log_resizefcn(XBAT_FIGS(k));
% 		else
% 			browser_resizefcn(XBAT_FIGS(k));
% 		end
% 	end

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
	% make palette display match front figure
	%--
	
	try
		tmp = gcf;
		browser_palettes(tmp,'Show');
		figure(tmp);
	end
		
%--
% Tile
%--

case ('Tile')
	
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
	% enforce resizefcn in case we forget
	%--
	
	for k = 1:length(tmp)
		figure(XBAT_FIGS(k));
		if (~isempty(findstr(tmp{k},'(Log)')))
			log_resizefcn(XBAT_FIGS(k));
		else
			browser_resizefcn(XBAT_FIGS(k));
		end
	end
	
	%--
	% make palette display match front figure
	%--
	
	try
		tmp = gcf;
		browser_palettes(tmp,'Show');
		figure(tmp);
	end

%--
% Tile Related
%--

case ({'Default','Row Oriented','Column Oriented'})
	
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
	
%--
% XBAT
%--

case ('XBAT')
	
	xbat_palette;
	
%--
% NAME (named window)
%--

case (NAME)

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
	
%--
% Half Size, Actual Size
%--

case ({'Half Size','Actual Size'})
	
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
	
% 	set(h,'visible','off');
	
	%--
	% compute according to desired scaling
	%--
	
	[m,n,d] = size(get(im(1),'cdata'));
	
	switch (str)
		
	% resizing using the built-in truesize function is generally buggy,
	% this function may have to be rewritten from scratch ...
	
	case ('Half')
		
		% produce actual size display

		for k = 1:12
			true_size(h,[m,n]);
		end
		
% 		for k = 1:2
% 			true_size(h,[m/2,n/2]);
% 		end
		
		% reset figure to half the size
		
		tmp = get(h,'position');
		
		tmp(1:2) = pos(1:2);
		
		if (~isempty(data.browser.colorbar))
			tmp(3) = tmp(3) - 0.5 * (tmp(3) - (12 * 13));
		else
			tmp(3) = tmp(3) - 0.5 * (tmp(3) - (12 * 8));
		end
		
		tmp(4) = tmp(4) - 0.5 * (tmp(4) - (12 * (13 + length(data.browser.channels) - 1)));
		
		set(h,'position',tmp);
				
	case ('Actual')
		
		for k = 1:8
			true_size(h,[m,n]);
		end
		
	case ('Double')
		
		for k = 1:8
			true_size(h,[2*m,2*n]);
		end
			
	end

	%--
	% refresh figure and apply resize function
	%--
	
	refresh(gcf);
	
	browser_resizefcn(h,data);
	
	%--
	% set figure position to minimize motion upon scaling
	%--
	
	new_pos = get(h,'position');
	
	new_pos(1) = pos(1);
	new_pos(2) = pos(2) - (new_pos(4) - pos(4));
	
	set(h,'position',new_pos);
	
% 	set(h,'visible','on');
	
%--
% Refresh
%--

case ('Refresh')
	
	refresh(h);
	
%--
% sound browser palette
%--

case (PAL_SOUND)
	
	% handle escaped ampersands in palette name strings
	
	str = strrep(str,'&&','&');
	
	browser_palettes(h,str);
	
%--
% log browser palette
%--

case (PAL_LOG)
	
	% handle escaped ampersands in palette name strings
	
	str = strrep(str,'&&','&');
	
	log_browser_palettes(h,str);
	
%--
% Rebuild Window menus
%--

otherwise
	
	log_browser_window_menu;
	
end
	
	
