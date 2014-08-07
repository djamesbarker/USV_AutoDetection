function scan = scan_edit_dialog(sound, scan)

% scan_edit_dialog - manually edit a sound scan
% ---------------------------------------------
%
% scan = scan_edit_dialog(sound, scan)
%
% Input:
% ------
%  sound - sound
%  scan - scan
%
% Output:
% -------
%  scan - scan

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

%-----------------------------
% HANDLE INPUT
%-----------------------------

if nargin < 1
	sound = get_active_sound;
end

if isempty(sound)
	return;
end

%-----------------------------
% SETUP
%-----------------------------

%--
% get default scan
%--

if nargin < 2 || isempty(scan)
	scan = scan_create(0, get_sound_duration(sound), get_default_page_duration(sound));
end

str = scan_info_str(scan);

if ~iscell(str)
	str = {str};
end


%------------------------------
% CREATE DIALOG
%------------------------------

%--
% create controls
%--

control = empty(control_create);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', 'Scan' ...
);

control(end + 1) = control_create( ...
	'name', 'scan', ...
	'alias', 'tiles', ...
	'style', 'listbox', ...
	'string', str, ...
	'onload', 1, ...
	'value', 1, ...
	'max', 2, ...
	'space', 0.25, ...
	'lines', 1 ...
);

control(end + 1) = control_create( ...
	'style', 'buttongroup', ...
	'name', {'add', 'delete'}, ...
	'width', 0.5, ...
	'align', 'right', ...
	'space', 1, ...
	'lines', 1.5 ...
);

control(end + 1) = control_create( ...
	'style', 'separator' ...
);

control(end + 1) = control_create( ...
	'name', 'scan_view', ...
	'alias', 'time', ...
	'label', 1, ...
	'style', 'axes', ...
	'space', 1 ...
);

control(end + 1) = control_create( ...
	'name', 'start', ...
	'style', 'slider', ...
	'type', 'time', ...
	'width', 7 / 15, ...
	'min', 0, ...
	'max', sound.duration, ...
	'space', -2, ...
	'value', 0 ...
);

control(end + 1) = control_create( ...
	'name', 'stop', ...
	'style', 'slider', ...
	'type', 'time', ...
	'width', 7 / 15, ...
	'align', 'right', ...
	'min', 0, ...
	'space', 2, ...
	'max', sound.duration, ...
	'value', sound.duration ...
);

control(end + 1) = control_create( ...
	'space', 1.5, ...
	'style', 'separator' ...
);

%--
% create dialog
%--

opt = dialog_group; opt.width = 17;

opt.header_color = get_extension_color('sound_detector');

result = dialog_group('Edit ...', control, opt, {@scan_edit_callback, sound});

values = result.values;

if isempty(values)
	scan = []; return;
end

scan = result.values.scan_view.scan;


%-------------------------------
% SCAN_EDIT_CALLBACK
%-------------------------------

function result = scan_edit_callback(obj, eventdata, sound, ix)

[control,par] = get_callback_context(obj); 

result = [];

%--
% get scan string and scan
%--

han = get_control(par.handle, 'scan', 'handles');

scan_str = get(han.obj, 'string');

scan = parse_time_interval(scan_str);

%--
% find selected scan interval
%--

if nargin < 4 || isempty(ix)
	
	val = get_control(par.handle, 'scan', 'value');

	ix = find(strcmp(scan_str, val{1}));

end

%--
% edit interval if needed
%--

switch (control.name)
	
	case {'stop', 'start'}
		
		%--
		% set limits of this interval
		%--
		
		stop = get_control(par.handle, 'stop', 'value');
		
		start = get_control(par.handle, 'start', 'value');
		
		%--
		% enforce positive duration
		%--
		
		if stop < start
			
			switch control.name
				
				case 'start'
					
					start = stop;
					
					set_control(par.handle, 'start', 'value', start); 
					
				case 'stop'
					
					stop = start;
					
					set_control(par.handle, 'stop', 'value', stop);
					
			end
			
		end
		
		scan.start(ix) = start; scan.stop(ix) = stop;
				
	case 'add'
		
		%--
		% add a scan interval
		%--
		
		if numel([scan.start]) > ix
			next = scan.start(ix + 1);
		else
			next = sound.duration;
		end
		
		if scan.stop(ix) == next || scan.start(ix) == scan.stop(ix)
			return;
		end
		
		start = scan.stop(ix); stop = start;
		
		scan.start = [scan.start(1:ix), start, scan.start(ix+1:end)];
		
		scan.stop = [scan.stop(1:ix), stop, scan.stop(ix+1:end)];
		
		ix = ix + 1;
			
	case 'delete'
		
		%--
		% remove a scan interval
		%--
		
		if numel(scan.start) < 2
			return;
		end
		
		scan.start(ix) = []; scan.stop(ix) = [];	
		
		ix = max(ix - 1, 1);
				
end

%--
% sync sliders
%--

set_control(par.handle, 'start', 'value', scan.start(ix));

set_control(par.handle, 'stop', 'value', scan.stop(ix));

%--
% set scan string
%--

scan_str = scan_info_str(scan);

set(han.obj, 'string', scan_str);

set(han.obj, 'value', min(ix, numel(scan_str)));

%--
% store scan in display axes
%--

ax_han = get_control(par.handle, 'scan_view', 'handles');

data = get(ax_han.obj, 'userdata'); data = struct();

data.scan = scan; set(ax_han.obj, 'userdata', data);

%--
% display scan
%--

display_scan(ax_han.obj, scan, ix, obj, sound);

set_control(par.handle, 'OK', 'enable', ~any(scan.stop == scan.start));


%--------------------------------
% DISPLAY_SCAN
%--------------------------------

function display_scan(ax, scan, selected, obj, sound)

if nargin < 3
	selected = [];
end

set(ax, ...
	'layer', 'top', ...
	'box', 'on', ...
	'xlim', [0, sound.duration], ...
	'ylim', [0, 1], ...
	'xtick', [], ...
	'ytick', [] ... 
);

delete(get(ax, 'children'));

callback.control.name = '';

for k = 1:length(scan.start)
	
	start = scan.start(k); stop = scan.stop(k);
	
	if k == selected
		color = [1, 0, 0];
	else
		color = [0, 0, 0.9];
	end
		
	patch('parent', ax, ...
		'xdata', [start, stop, stop, start, start], ...
		'ydata', [0, 0, 1, 1, 0], ...
		'facecolor', (4 * get(ax, 'color') + color) / 5, ...
		'buttondownfcn', {@scan_edit_callback, sound, k}, ... 
		'facealpha', 1 ...
	);


end

set(ax, 'box', 'on');


