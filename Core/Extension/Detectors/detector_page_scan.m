function [page_events, contexts] = detector_page_scan(ext, page, context, contexts, explaining, waiting)

%------------------------------
% HANDLE INPUT
%------------------------------

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

if nargin < 6
	waiting = 0;
end

if nargin < 5
	explaining = 0;
end

if nargin < 4
	contexts = [];
end

%------------------------------
% DETECT EVENTS IN PAGE
%------------------------------

%--
% compute considering whether extension handles multiple channels
%--

if ext.multichannel

	%--
	% compute all channels
	%--

	context.page = rmfield(page, {'samples', 'filtered'});

	% TODO: include some page information in message

	page_events = empty(event_create);

	try
		[page_events, context] = ext.fun.compute(page, ext.parameter, context);
	catch
		extension_warning(ext, 'Multi-channel compute failed on page.', lasterror);
	end

else

	%--
	% loop computation over channels
	%--

	M = length(page.channels);

	%--
	% establish / update individual channel contexts
	%--
	
	if isempty(contexts)
		
		for k = 1:M
			contexts{k} = context;
		end
		
	else
		
		for k = 1:M
			contexts{k}.scan = context.scan;
		end
		
	end

	page_events = cell(1, M);
	
	%--
	% compute / collapse page events
	%--

	for k = 1:M

		channel_page = get_channel_page(page, k);

		contexts{k}.page = rmfield(channel_page, {'samples', 'filtered'});

		page_events{k} = empty(event_create);

		% TODO: include page and channel information in message

		try
			[page_events{k}, contexts{k}] = ext.fun.compute(channel_page, ext.parameter, contexts{k});
		catch
			extension_warning(ext, 'Compute failed.', lasterror);
		end

	end

	page_events = collapse_cell(page_events);

end

%-----------------------
% TRIM EVENTS
%-----------------------

if ~isempty(page_events)

	%--
	% consider page boundaries
	%--

	% NOTE: when start is session boundary don't allow negative page times

	if mod(page.interval, 2)

		for k = 1:numel(page_events)
			page_events(k).time = max(page_events(k).time, 0);
		end

	end

	% NOTE: when stop is session boundary don't allow time to exceed page duration

	if page.interval > 1

		for k = 1:numel(page_events)
			page_events(k).time = min(page_events(k).time, page.duration);
		end

	end

	%--
	% add page offset
	%--

	for k = 1:numel(page_events)
		page_events(k).time = page_events(k).time + page.start;
	end

end

%----------------------------------
% UPDATE EXPLAIN FIGURE (IF NEEDED)
%-----------------------------------

if explaining

	% NOTE: explain considering whether the extension handled multiple channels

	if ~ext.multichannel

		for k = 1:M

			explain = contexts{k}.explain;

			explaing.handles{k} = [];

			try
				explain.handles{k} = ...
					ext.fun.explain.display(explain.figure, explain.data, explain.parameter, contexts{k});
			catch
				extension_warning(ext, 'Explain failed.', lasterror);
			end

		end

	else

		explain = context.explain;

		explain.handles = [];

		try
			explain.handles = ...
				ext.fun.explain.display(explain.figure, explain.data, explain.parameter, context);
		catch
			extension_warning(ext, 'Multi-channel explain failed.', lasterror);
		end

	end

	% NOTE: waitbar update calls drawnow

	if ~waiting
		drawnow;
	end
	
end

%----------------------------
% UPDATE WAITBAR (IF NEEDED)
%----------------------------

if waiting

	pal = detector_waitbar(context);
	
	waitbar_update(pal, 'PROGRESS', ...
		'value', context.scan.position, ...
		'message', page_time_string(page, context.sound, context.grid) ...
	);

	str = get_control(pal, 'events', 'string');
	
	han = get_control(pal, 'events', 'handles');
	
	if isempty(han)
		return;
	end
	
	new_str = [ ...
		page_time_string(page, context.sound, context.grid, 1), ...
		'  ', integer_unit_string(length(page_events), 'event') ...
	];

	if ~isempty(str)
		str{end + 1} = new_str;
	else
		str = {new_str};
	end

	str(1:end-30) = [];

	set(han.obj, 'string', str, 'value', numel(str));

end




