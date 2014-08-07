function out = detector_scan(ext, sound, scan, channels, log, context)

% detector_scan - scan sound with detector
% ----------------------------------------
%
% out = detector_scan(ext, sound, scan, channels, log, context)
%
% out = detector_scan(context)
% 
% Input:
% ------
%  ext - detector
%  sound - sound
%  scan - scan (def: default sound scan)
%  channels - channels to scan (def: [])
%  log - log to append events to (def: [])
%  context - context
%
% Output:
% -------
%  out - events or updated log

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

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% CONTEXT INPUT
%--

% NOTE: simply rename and unpack context

if nargin < 2
	
	context = ext;
	
	try
		ext = context.ext; sound = context.sound; scan = context.scan; channels = context.channels; log = context.log;
	catch	
		nice_catch(lasterror, 'Problems unpacking context.');
	end
	
%--
% COMPONENT INPUT
%--

else
	
	%--
	% get default scan
	%--

	if (nargin < 3) || isempty(scan)
		scan = get_sound_scan(sound);
	end

	%--
	% set and check channels
	%--

	if nargin < 4 || isempty(channels)
		channels = 1:sound.channels;
	end

	if ~proper_channels(channels, sound)
		error('Improper scan channels input.');
	end

	%--
	% set default empty log
	%--

	if nargin < 5
		log = [];
	end

	%--
	% build best context we can
	%--

	if (nargin < 6) || isempty(context)
		context = detector_context(ext, sound, scan, channels, log);
	end
	
end

%--------------------------------------------
% SETUP
%--------------------------------------------

%--
% get grid from parent if possible
%--

if isfield(context, 'par') && ~isempty(context.par)
	data = get_browser(context.par); grid = data.browser.grid; axes = data.browser.axes;
else
	grid = []; axes = []; ext.control.explain = 0;
end

context.grid = grid; context.axes = axes;
	
%--
% set explain and waitbar flags
%--

if ~isfield(ext.control, 'explain')
    ext.control.explain = 0;
end

% NOTE: these should not be exclusive

explaining = ext.control.explain && ~isempty(ext.fun.explain.display);

waiting = ~explaining;

%--
% waitbar setup
%--

if waiting
	
	pal = detector_waitbar(context);

	waitbar_update(pal, 'PROGRESS', 'message', 'Starting ...');

end

%--
% explain setup
%--

% NOTE: create the explain figure, parameters, and layout figure if needed

if explaining
	
	%--
	% create explain figure
	%--
	
	context.explain.figure = explain_figure(context.par, context.ext);
	
	%--
	% get explain parameters
	%--
	
	% NOTE: the default is a length 1 struct with no fields, so no parameters
	
	context.explain.parameter = struct;
	
	if ~isempty(ext.fun.explain.parameter.create)
		
		try
			context.explain.parameter = ext.fun.explain.parameter.create(context);
		catch
			extension_warning(ext, 'Explain parameter creation failed.', lasterror);
		end
	
	end
		
	%--
	% layout explain figure
	%--
	
	if ~isempty(ext.fun.explain.layout)
		
		try
			ext.fun.explain.layout(context.explain.figure, context.explain.parameter, context);
		catch
			extension_warning(ext, 'Explain layout failed.', lasterror);
		end
		
	end
	
end

%--------------------------------------------
% DETECTOR SCAN
%--------------------------------------------

%--
% compile to configure pager
%--

if ~isempty(ext.fun.parameter.compile)
	
	try
		[ext.parameter, context] = ext.fun.parameter.compile(ext.parameter, context);
	catch
		extension_warning(ext, 'Parameter compile for context update failed.', lasterror);
	end
	
end 

%--
% page through sound
%--

event = cell(0); contexts = [];

while 1
	
	%--
	% GET PAGE, BREAK IF DONE
	%--
	
	[page, context.scan] = get_scan_page(context.scan);
	
	if isempty(page)
		break;
	end
	
	%--
	% READ PAGE
	%--
		
	page = read_sound_page(sound, page, channels); 
	
	%--
	% skip zero-length pages
	%--
	
	if isempty(page.samples)
		continue;
	end
	
	%--
	% start timing
	%--
	
	start = clock;
	
	%--
	% PROCESS PAGE
	%--
	
	page = filter_sound_page(page, context);
	
	page = feature_sound_page(page, context);
	
	%--
	% SCAN PAGE FOR EVENTS
	%--
	
	[event{end + 1}, contexts] = detector_page_scan( ...
		ext, page, context, contexts, explaining, waiting ...
	);

	% ---------------
	% TODO:
	% ---------------
	%
	% MEASURE EVENTS
	% CLASSIFY EVENTS
	%
	% ---------------
	
	%--
	% collect timing information
	%--
	
	elapsed = etime(clock, start); 
		
	%--
	% adapt scan and get next page
	%--
	
	context.scan = adapt_page_duration(context.scan, elapsed);
	
end

%--------------------------------------------
% FINISH SCAN
%--------------------------------------------
	
%--
% make sure explain objects are visible
%--

if explaining
	
	%--
	% get explain handles
	%--
	
	explain_all = findobj(context.explain.figure); 
	
	explain_axes = findobj(context.explain.figure, 'type', 'axes');
	
	%--
	% make sure objects are displayed and axes grids visible
	%--
	
	set(setdiff(explain_all, explain_axes), 'visible', 'on');
	
	set(explain_axes, 'layer', 'top');
	
end

%--------------------------------------------
% OUTPUT
%--------------------------------------------
	
%--
% concatenate and sort events
%--

event = collapse_cell(event);

%--
% update waitbar and close if needed
%--

if waiting
	
	waitbar_update(pal, 'PROGRESS', ...
		'value', context.scan.position, 'message', 'Done.' ...
	);

	if get_control(pal, 'close_after_completion', 'value')
		close(pal);
	end

end

%--
% quick return for no detections
%--

if isempty(event)
    out = log; return;
end

event = sort_events(event);

%--
% output events or append to log and output log
%--

if isempty(log)
	out = event; return;
end

% TODO: consider updating log in open browsers if needed

out = log_append(log, event);




%-------------------------------------------------------------------------
% PROPER_CHANNELS
%-------------------------------------------------------------------------

function value = proper_channels(channels, sound)

if isempty(channels)
	value = 1; return;
end

value = ~(any(channels ~= floor(channels)) || any(channels < 1) || any(channels > sound.channels));


%-------------------------------------------------------------------------
% SORT_EVENTS
%-------------------------------------------------------------------------

function event = sort_events(event)

%--
% get event times and channels
%--

% TODO: this needs some protection from inconsistent events

time = struct_field(event, 'time'); time = time(:,1);

channel = struct_field(event, 'channel');

%--
% sort on time then channel
%--

[ignore, ix] = sortrows([time(:), channel(:)]);

event = event(ix);


