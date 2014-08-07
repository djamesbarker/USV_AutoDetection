function [flag, g] = log_open(h, p, opt)

% log_open - open log in browser figure
% -------------------------------------
%
% [flag, g] = log_open(h, p)
%
% Input:
% ------
%  h - handle to browser figure (def: gcf)
%  p - log path or full location or log
%  opt - warning option
%
% Output:
% -------
%  flag - open confirmation flag
%  g - handle of figure that has log open

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
% $Revision: 7028 $
% $Date: 2006-10-16 12:35:31 -0400 (Mon, 16 Oct 2006) $
%--------------------------------

% NOTE: this function can be improved through modularization, separating the code
% that opens the log from the code that generates and updates the log menu

%--------------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------------

%--
% set warning option
%--

if (nargin < 3) || isempty(opt)
	opt = 1;
end

%--
% get figure handle and userdata
%--

if (nargin < 1) || isempty(h)
	h = get_active_browser;
end

data = get(h, 'userdata');

openflag = 1;

pi = pwd;

%--
% handle path or location input
%--

if (nargin < 2) || isempty(p)
	
	%--
	% set open to be interactive
	%--
	
	inter = 1;
	
	%--
	% build library appropiate path to start dialog
	%--
	
	info = parse_tag(get(h, 'tag'));
	
	lib = get_libraries([], 'name', get_library_file_name(info.library));
		
	% start looking for the log in the library appropiate place
	
	p = [lib.path, info.sound filesep, 'Logs'];
	
elseif isstruct(p)
		
	openflag = 0; inter = 0;
		
else
		
	%--
	% check for file or directory location to see if open is interactive
	%--

	switch exist(p)

		% file location, not interactive 

		case (2)
			inter = 0;

		% directory location, interactive

		case (7)
			inter = 1;

		% error condition, this needs some work

		otherwise

			%--
			% handle error condition depending on warn option
			%--

			% this function needs to be redesigned, figure out dependencies

			if opt
				error(['No ''', p, ''' directory or file exists.']);
			else
				flag = 0; return;
			end

	end

end

%--
% get file if needed
%--

if inter
	
	%--
	% try to get log file starting from specified directory
	%--
		
	cd(p);
	
	[f, p] = uigetfile2( ...
		{ ...
			'*.mat','MAT-Files (*.mat)'; ...
			'*.zip','ZIP-Files (*.zip)'; ...
			'*.*','All Files (*.*)' ...
		}, ...
		'Select XBAT Log File: ' ...
	);
	
	% return if cancel
	
	if ~f
		return;
	end
	
	cd(pi); 
	
	%--
	% build log location string
	%--
	
	p = [p, f];
	
end

if openflag
	
	%--
	% load log from file
	%--

	log = log_load(p);
	
	if isempty(log)
		flag = 0; g = []; cd(pi); return;
	end

	%--
	% separate location into path and filename
	%--

	ix = find(p == filesep); 

	fn = p(ix(end) + 1:end);

	p = p(1:ix(end));

else
	
	log = p;
	
	p = log.path;
	
	fn = log.file;

end
	
%--------------------------------------------------------
% OPEN LOG
%--------------------------------------------------------

%--
% check that log is not already open
%--

if log.open
	
	%--
	% check that log is in fact open
	%--
	
	g = log_is_open(log);
	
	%--
	% display warning dialog
	%--
	
	if ~isempty(g)
		
		%--
		% display warning according to warn option
		%--
		
		if opt
			
			%--
			% log is open in this browser
			%--
			
			if (g == h)
				
				% perhaps remove warning and turn on display
				
				tmp = warn_dialog( ...
					['Log ''' log.file ''' is already open in this browser.'], ...
					' XBAT Warning  -  Log Open', ...
					'modal' ...
				);
			
			%--
			% log is open in another browser
			%--
				
			else
				
				tmp = warn_dialog( ...
					['Log ''' log.file ''' is currently open in another browser.'], ...
					' XBAT Warning  -  Log Open', ...
					'modal' ...
				);
			
			end
			
			waitfor(tmp);
			
		end
		
		%--
		% output proper flag and return
		%--
		
		flag = 0; return;
		
	end

else
	
	%--
	% set log flag to open
	%--

	log.open = 1;
	
end

%--
% update path and file if log file has been moved or renamed
%--

if ~strcmp(log.path,p) || ~strcmp(log.file,fn)
	log.path = p; log.file = fn;
end

%----------------------------------------------------
% UPDATE/FIX
%----------------------------------------------------

% NOTE: make visible double not logical

% TODO: consider setting visibility to 'on' on open

log.visible = double(log.visible);

% NOTE: make 'no patch' signature equal to zero not -1

if (log.patch < 0)
	log.patch = 0;
end

%--
% check that log corresponds to sound
%--

is_match = sound_compare(log.sound, data.browser.sound);

is_compatible = log_is_compatible(log, data.browser.sound);

%--
% try to open the sound that the log points to
%--

if is_compatible == 0

	tmp = quest_dialog( ...
		['Selected log is not compatible with this sound. Attempt to open log ''', log.file, ''' in new window ?'], ...
		' XBAT Question > Open Log', ...
		'modal' ...
	);
	
	%--
	% open sound browser for log sound and open log
	%--
	
	if ~strcmp(tmp, 'Yes')
		return;
	end

	h = browser(log.sound);

	if ~isempty(h)
		log_open(h, log);
	end

	return;
	
end

%--
% if log and sound don't match but are still compatable
%--
	
if is_compatible && ~is_match
	
	tmp = quest_dialog( ...
		{'Log is old or may not contain pertinent data for this sound, ', 'are you sure you want to import it?'}, ...
		' XBAT Question > Import Log', ...
		'modal' ...
	);

	if ~strcmp(tmp, 'Yes')	
		return;
	end
	
	% NOTE: this points the log at the currently open sound, regardless
	% of it's original association

	newlog = log_file_update(h, log);

	log_open(h, newlog);

	cd(pi);
	
	return;
	
end

%--
% append log to browser data structure
%--

if isempty(data.browser.log)
	
	data.browser.log = log;
	data.browser.log_active = 1;
	
else
	
	m = length(data.browser.log);
	
	data.browser.log(m + 1) = log;
	data.browser.log_active = m + 1;
	
end

%--
% save changes to log
%--

log_save(log);

%--------------------------------------------------------
% CREATE LOG RELATED MENUS
%--------------------------------------------------------

%--
% update userdata
%--

set(data.browser.log_menu.log,'enable','on');

%--
% Log
%--

file = file_ext(log.file);

L = { ...
	file, ...
	[file ' Options'] ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{1} = 'on';

g1 = menu_group(data.browser.log_menu.log(1),'browser_log_menu',L,S);

set(g1,'tag',file);

%--
% Log information, annotation, and measurement
%--

L = { ...
	'Log', ...
	'Annotation', ...
	'Measurement' ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{2} = 'on';

g2 = menu_group(g1(1),'browser_log_menu',L,S);

set(g2,'tag',file);

%--
% Log and Info
%--

if ((isempty(log.time) || isempty(log.freq) || isempty(log.channel)) && log.length)
	
	[time,freq,channel] = log_info_update(log);
	
	log.time = time;
	
	log.freq = freq;
	
	log.duration = diff(time);
	
	log.bandwidth = diff(freq);
	
	log.channel = channel;
	
end

[tstr,fstr] = log_labels(h,log);

L = { ...
	['Path:  ' log.path], ...
	['File:  ' log.file], ...
	['Number of Events:  ' int2str(log.length)], ...
	['Current ID:  ' int2str(log.curr_id)], ...
	['Channels:'], ...
	['Start Time:  ' tstr{1}], ...
	['End Time:  ' tstr{2}], ...
	['Duration:  ' tstr{3}], ...
	['Min Freq:  ' fstr{1}], ...
	['Max Freq:  ' fstr{2}], ...
	['Bandwidth:  ' fstr{3}], ...
	['Log Info:'] ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{3} = 'on';
S{5} = 'on'; 
S{6} = 'on';
S{9} = 'on';
S{end} = 'on';

g3 = menu_group(get_menu(g2,'Log'),'',L,S);

set(g3,'tag',file);

if (~isempty(log.modified))
	L = { ...
		['Author:  ' log.author], ...
		['Created:  ' datestr(log.created)], ...
		['Modified:  ' datestr(log.modified)] ...
	};
else
	L = { ...
		['Author:  ' log.author], ...
		['Created:  ' datestr(log.created)] ...
	};
end

n = length(L);

S = bin2str(zeros(1,n));
S{2} = 'on';

tmp = menu_group(g3(end),'',L,S);

set(tmp,'tag',file);

%--
% Channel
%--

n = length(log.channel);

L = cell(1,n);
for k = 1:length(log.channel)
	L{k} = ['Channel ' int2str(log.channel(k))];
end

menu_group(get_menu(g3,'Channels:'),'',L);

%--
% Annotation
%--

%--
% Measurement
%--
	
%--
% Log Options
%--

L = { ...
	'Color', ...
	'Line Style', ...
	'Line Width', ...
	'Opacity', ...
	'Auto Save Log', ...
	'Save Log', ...
	'Backup Log', ...
	'Close' ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{5} = 'on'; 
S{end} = 'on';

g2 = menu_group(g1(2),'browser_log_menu',L,S);

set(g2,'tag',file);

if (log.autosave)
	set(get_menu(g2,'Auto Save Log'),'check','on');
end

if (log.saved)
	set(get_menu(g2,'Save Log'),'enable','off');
end

set(get_menu(g2,'Backup Log'),'enable','off');
set(get_menu(g2,'Export Log ...'),'enable','off');

%--
% Color
%--

[L,S] = color_to_rgb;

tmp = menu_group(get_menu(g2,'Color'),'browser_log_menu',L,S);
	
set(tmp,'tag',file);

ix = find(strcmp(rgb_to_color(log.color),color_to_rgb));
if (~isempty(ix))
	set(tmp(ix),'check','on');
end

%--
% Line Style
%--

[L,S] = linestyle_to_str('','strict');

tmp = menu_group(get_menu(g2,'Line Style'),'browser_log_menu',L,S);		

set(tmp,'tag',file);

ix = find(strcmp(L,str_to_linestyle(log.linestyle)));
if (~isempty(ix))
	set(tmp(ix),'check','on');
end

%--
% Line Width
%--

L = {'1 pt','2 pt','3 pt','4 pt'};

tmp = menu_group(get_menu(g2,'Line Width'),'browser_log_menu',L);
	
set(tmp,'tag',file);
	
ix = find(log.linewidth == [1, 2, 3, 4]);
if (~isempty(ix))
	set(tmp(ix),'check','on');
end

%--
% Opacity
%--

L = { ...
	'Transparent', ...
	'1/8 Alpha', ...
	'1/4 Alpha', ...
	'1/2 Alpha', ...
	'3/4 Alpha', ...
	'Opaque' ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{2} = 'on';
S{end} = 'on';

tmp = menu_group(get_menu(g2,'Opacity'),'browser_log_menu',L,S);

set(tmp,'tag',file);

ix = find(log.patch == [-1, 1/8, 1/4, 1/2, 3/4, 1]);
if (~isempty(ix))
	set(tmp(ix),'check','on');
end

%--------------------------------------------------------
% UPDATE RELATED MENUS UPON OPENING LOG
%--------------------------------------------------------

L = file_ext(struct_field(data.browser.log,'file'));

% try sorting these menus

tmp = length(data.browser.log);

if (tmp > 1)
	
	[L,ix] = sort(L);
	
	ms = find(data.browser.log_active == ix);
	
	v = struct_field(data.browser.log,'visible');
	v = v(ix);
	
else
	
	ms = data.browser.log_active;
	
	v = data.browser.log.visible;
	
end

%--
% update active menu
%--

tmp = get_menu(data.browser.log_menu.log,'Active');
delete(get(tmp,'children'));

tmp = menu_group(tmp,'browser_log_menu',L);
data.browser.log_menu.active = tmp;

% set(tmp(data.browser.log_active),'check','on');
set(tmp(ms),'check','on');

%--
% update display menu
%--

tmp = get_menu(data.browser.log_menu.log,'Display');
delete(get(tmp,'children'));

S = bin2str(zeros(length(L) + 2,1));
S{2} = 'on';
S{end} = 'on';

tmp = menu_group(tmp,'browser_log_menu',{'No Display',L{:},'Display All'},S);
data.browser.log_menu.display = tmp;

for k = 1:length(data.browser.log)
% 	if (data.browser.log(k).visible)
	if (v(k))
		set(tmp(k + 1),'check','on');
	else
		set(tmp(k + 1),'check','off');
	end
end

%--
% update browse menu
%--

tmp = get_menu(data.browser.log_menu.log,'Browse');
delete(get(tmp,'children'));

tmp = menu_group(tmp,'browser_log_menu',L);
data.browser.log_menu.browse = tmp;

%--
% update export menu
%--

tmp = get_menu(data.browser.log_menu.log,'Export');
delete(get(tmp,'children'));

tmp = menu_group(tmp,'browser_log_menu',L);
data.browser.log_menu.export = tmp;

%--
% update strip menu
%--

tmp = get_menu(data.browser.log_menu.log,'Strip');
delete(get(tmp,'children'));

tmp = menu_group(tmp,'browser_log_menu',L);
data.browser.log_menu.strip = tmp;
	
%--
% update copy to workspace menu
%--

tmp = get_menu(data.browser.log_menu.log,'Workspace');
delete(get(tmp,'children'));

tmp = menu_group(tmp,'browser_log_menu',L);
data.browser.log_menu.copy_to_workspace = tmp;
	
%--
% update log selection to menu
%--

tmp = get_menu(data.browser.edit_menu.edit,'Log Selection To');
delete(get(tmp,'children'));

tmp = menu_group(tmp,'browser_edit_menu',L);
data.browser.edit_menu.log_to = tmp;

% set(tmp(data.browser.log_active),'check','on');
set(tmp(ms),'check','on');

%--------------------------------------------------------
% SORT LOG INFORMATION MENUS
%--------------------------------------------------------

%--
% get parent log menu
%--

tmp = findobj(h,'type','uimenu','label','Log');

ix = find(cell2mat(get(tmp,'parent')) == h);

%--
% get children and select the ones to sort
%--

% assume the children come out in reverse order

ch = get(tmp(ix),'children');

ch = flipud(ch(:));

ch = ch(7:end);

%--
% sort the menus
%--

if (length(ch) > 2)

	[ignore,ix] = sort(get(ch(1:2:end),'label'));
	
	ch = reshape(ch,2,length(ch)/2)';
	ch = ch(ix,:)';
	ch = ch(:);
	
	% note that this depends on the number of static menu items in the log menu
	
	for k = 1:length(ch)
		set(ch(k),'position',k + 6);
	end
	
end

%--
% update measure menu, make measurements available
%--

set(data.browser.measure_menu.measure,'enable','on');

%--
% update annotate menu, make annotations available
%--

set(data.browser.annotate_menu.annotate,'enable','on');

%--
% update renderer mode and menus, eventually get rid of the renderer menus
%--

update_renderer(h, [], data);

%--
% update userdata
%-

set(h, 'userdata', data);

flag = 1;

%--
% perform log related palette updates
%--

% NOTE: this does not affect the state of the browser on open, only on close

update_log_palette(h, data);

update_extension_palettes(h, data);

%--
% update find events if needed
%--

update_find_events(h, [], data);

%--
% update display 
%--

browser_display(h, 'events', data);


%---------------------------------------------------
% LOG_IS_COMPATIBLE
%---------------------------------------------------

function out = log_is_compatible(log, sound)

sound2 = log.sound;

out = ...
	(sound2.samplerate >= sound.samplerate) && ...
	(sound.channels >= sound2.channels);

% out = ...
% 	(sound2.samplerate >= sound.samplerate) && ...
% 	(sound2.duration <= sound.duration) && ...
% 	(sound.channels >= sound2.channels);

