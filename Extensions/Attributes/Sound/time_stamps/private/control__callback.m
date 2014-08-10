function result = control__callback(callback, context, ix)

% TIME_STAMPS - control__callback

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

if nargin < 3
	ix = [];
end

result = [];

set_control(callback.pal.handle, 'OK', 'enable', 0);

%--
% retrieve time stamps and axes handle
%--

time_stamps = get_control(callback.pal.handle, 'time_stamps', 'value');

ax_han = get_control(callback.pal.handle, 'time_stamps', 'handles');

%--
% load time stamps into 'fishbowl' if necessary
%--

if isempty(time_stamps) || ~isstruct(time_stamps)
	
	time_stamps = context.attribute;
	
	set_control(callback.pal.handle, 'time_stamps', 'value', time_stamps);
	
end

[ignore, ixs] = sort(time_stamps.table(:, 1));

time_stamps.table = time_stamps.table(ixs,:);

%--
% get index of currently-selected stamp
%--

list_han = get_control(callback.pal.handle, 'scan', 'handles');

if isempty(ix)

	str = get(list_han.obj, 'string');

	value = get_control(callback.pal.handle, 'scan', 'value');

	if numel(value) == 0
		value = '';
	else
		value = value{1};
	end

	ix = find(strcmp(str, value));
	
	if isempty(ix)
		ix = 1;
	end

	if numel(ix) > 1
		ix = ix(1);
	end
	
end

%--
% possibly edit time stamps
%--

switch callback.control.name
	
	case 'record_time'
		
		value = get_control(callback.pal.handle, callback.control.name, 'value');
		
		time_stamps.table(ix, 1) = value;
		
	case 'maps_to'
		
		value = get_control(callback.pal.handle, callback.control.name, 'value');
		
		time_stamps.table(ix, 2) = clock_to_sec(value);	
		
	case 'get_from_files'
		
		time_stamps.table = get_schedule_from_files(context.sound);
		
		ix = 1;
		
	case 'add'
		
		time_stamps.table(end+1,:) = time_stamps.table(end,:); 
		
		ix = size(time_stamps.table, 1);
	
	case 'delete'
		
		time_stamps.table(ix, :) = []; ix = min(ix - 1, 1);
		
		
	case 'enable'
		
		value = get_control(callback.pal.handle, callback.control.name, 'value');
		
		time_stamps.enable = value;
		
	case 'hide_silence'
		
		value = get_control(callback.pal.handle, callback.control.name, 'value');
		
		time_stamps.collapse = value;
				
	otherwise
		
		set_control(callback.pal.handle, 'record_time', ...
			'value', time_stamps.table(ix, 1) ...
		);
	
		set_control(callback.pal.handle, 'maps_to', ...
			'string', sec_to_clock(time_stamps.table(ix, 2)) ...
		);
	
		set_control(callback.pal.handle, 'enable', ...
			'value', time_stamps.enable ...
		);
	
		set_control(callback.pal.handle, 'hide_silence', ...
			'value', time_stamps.collapse ...
		);	
	
end

%--
% store edited time_stamps
%--

set(ax_han.obj, 'userdata', time_stamps);

%--
% get sessions
%--

context.sound.time_stamp = time_stamps;

sessions = get_sound_sessions(context.sound);

%--
% display sessions
%--

display_sessions(ax_han.obj, sessions, ix, callback, context);

%--
% update selection box
%--

str = time_stamps_info_str(time_stamps.table);

set(list_han.obj, ...
	'string', time_stamps_info_str(time_stamps.table), ...
	'value', ix ...
);

set_control(callback.pal.handle, 'OK', 'enable', 1);



%--------------------------------
% PARSE_TIME_STAMP_STR
%--------------------------------

function [record, real] = parse_time_stamp_str(str)

info = parse_tag(str, ' -> ', {'record', 'real'});

record = clock_to_sec(info.record); 

real = clock_to_sec(info.real);


%--------------------------------
% DISPLAY_SESSIONS
%--------------------------------

function display_sessions(ax, sessions, selected, callback, context)

if nargin < 3
	selected = [];
end

set(ax, ...
	'layer', 'top', ...
	'box', 'on', ...
	'xlim', [0, max([sessions.end])], ...
	'ylim', [0, 1], ...
	'xtick', [], ...
	'ytick', [] ... 
);

delete(get(ax, 'children'));

callback.control.name = '';

for k = 1:length(sessions)
	
	start = sessions(k).start; stop = sessions(k).end;
	
	if k == selected
		color = [1, 0, 0];
	else
		color = [0, 0, 0.9];
	end
		
	patch('parent', ax, ...
		'xdata', [start, stop, stop, start, start], ...
		'ydata', [0, 0, 1, 1, 0], ...
		'facecolor', (4 * get(ax, 'color') + color) / 5, ...
		'buttondownfcn', {@session_patch_callback, callback, context, k}, ... 
		'facealpha', 1 ...
	);

end

set(ax, 'box', 'on');


%------------------------------
% SESSION_PATCH_CALLBACK
%------------------------------

function session_patch_callback(obj, eventdata, callback, context, k)

control__callback(callback, context, k);
