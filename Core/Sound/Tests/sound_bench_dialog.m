function [h] = sound_bench_dialog()

% sound_bench_dialog - get user input to set input parameters to
% read_compare, then run read_compare()
% -------------------------------------------------------------------------
% 
% h = sound_bench_dialog()
%
% Input:
% ------
% (none)
%
% Output:
% -------
% h - figure handle
%

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
% Author: Matt Robbins
%--------------------------------
% $Revision: 3512 $
% $Date: 2006-02-13 17:19:46 -0500 (Mon, 13 Feb 2006) $
%--------------------------------


NAME = 'Benchmark Sound';

%--
% "read" header
%--

controls(1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', 'read' ...
);

%--
% channels slider
%--

controls(end + 1) = control_create( ...
	'name', 'channels', ...
	'style', 'slider', ...
	'min', 1, ...
	'max', 8, ...
	'value', 1 ...
);

%--
% formats to compare list box
%--

formats = get_writeable_formats();

format_names = {formats.name};

controls(end + 1) = control_create( ...
	'name', 'formats', ...
	'style', 'listbox', ...
	'string', format_names, ...
	'min', 1, ...
	'max', 8, ...
	'value', [1 2 3 4] ...
);

%--
% functions to compare list box
%--

opt = read_compare;

functions = opt.functions;

controls(end + 1) = control_create( ...
	'name', 'functions', ...
	'style', 'listbox', ...
	'string', functions, ...
	'min', 1, ...
	'max', 4, ...
	'value', [1 2] ...
);

%--
% create dialog
%--

h = dialog_group('Benchmark Sound',controls,[],@sound_bench_callback);

opt.formats = h.values.formats;
opt.compare = h.values.functions;

read_compare([], opt);


%--------------------------------------------
% CALLBACK FUNCTION
%--------------------------------------------

function sound_bench_callback(obj,eventdata)

pal = get(obj, 'parent');

context = get_callback_context(obj,'pack');

value = get_control(pal, context.control.name, 'value');

% switch (context.control.name)
% 	
% 	case('channels')
% 		
% % 		slider_sync(obj,context.control.handles);
% % 		
% % 		[ignore,value] = control_update([],context.pal.handle,context.control.name);
% 	
% 		value = get_control(obj, 'channels', 'value');
% 		
% 	case('formats')
% 		
% 		value = get_control(obj, 'formats'

	
