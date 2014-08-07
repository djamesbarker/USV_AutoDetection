function compute_features(feature, sound, page, context)

%--
% build scan for page
%--

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

scan = scan_intersect(get_sound_scan(sound), get_page_scan(page));

% NOTE: the pager reads sound in recording time, the scan handles session boundaries

sound.time_stamp = [];

%---------------------------------
% SETUP
%---------------------------------

%--
% add page to context
%--

% NOTE: this is typically used in layout

context.page = page;

%--
% get grid from parent if possible
%--

if ~isempty(context.par)
	data = get_browser(context.par); grid = data.browser.grid; axes = data.browser.axes;
else
	grid = []; axes = [];
end

% NOTE: the context contents are largely shared

shared_context = context; view = zeros(size(feature)); wait = view;

for k = 1:length(feature)
	
	%--
	% select extension
	%--
	
	ext = feature(k); 
	
	% NOTE: we need a separate context for each feature
	
	context = shared_context; context.ext = ext;
	
	%--
	% set view and waitbar flags
	%--

	% NOTE: these should not be exclusive
	
	if ~isfield(ext.control, 'view')
		ext.control.view = 1;
	end
	
	viewing = ext.control.view && ~isempty(ext.fun.view.display);

	waiting = ~viewing;

	%--
	% waitbar setup
	%--

	if waiting

		pal = feature_waitbar(context);

		waitbar_update(pal, 'PROGRESS', 'message', 'Starting ...');
		
	end

	%--
	% view setup
	%--

	% NOTE: create the view figure, parameters, and layout figure if needed

	if viewing

		%--
		% create view figure
		%--

		context.view.figure = view_figure(context.par, context.ext);

		%--
		% get view parameters
		%--

		% NOTE: the default is a length 1 struct with no fields, so no parameters

		context.view.parameter = struct;

		if ~isempty(ext.fun.view.parameter.create)

			try
				context.view.parameter = ext.fun.view.parameter.create(context);
			catch
				extension_warning(ext, 'View parameter creation failed.', lasterror);
			end

		end

		%--
		% layout view figure
		%--

		if ~isempty(ext.fun.view.layout)

			% NOTE: how do we expect to use these?

			context.grid = grid; context.axes = axes;

			try
				ext.fun.view.layout(context.view.figure, context.view.parameter, context);
			catch
				extension_warning(ext, 'View layout failed.', lasterror);
			end

		end

	end

	%--
	% pack contexts and state variables
	%--

	contexts(k) = context;
	
	view(k) = viewing;
	
	wait(k) = waiting;
	
end

context = contexts;

%---------------------------------
% COMPUTE
%---------------------------------

%--
% initialize output
%--

if nargout
	
	for k = 1:length(feature)
		out(k).name = feature(k).name; out(k).value = {};
	end

end

% NOTE: get channels from input page before we change what page means

channels = page.channels;

%--
% page and compute
%--

[page, scan] = get_scan_page(scan);

%--
% continue while we have pages
%--

while ~isempty(page)

	%--
	% read and filter page
	%--
	
	page = read_sound_page(sound, page, channels); 

	page = filter_sound_page(page, context);
	
	%--
	% compute features
	%--
	
	for k = 1:length(feature)
		
		% NOTE: this means that we don't accept scan changes from features
		
		ext = feature(k); context(k).scan = scan;
			
		%--
		% compile parameters for page adaptation
		%--

		% NOTE: this is not as for detectors, in that case we are configuring the pager
		
		if ~isempty(ext.fun.parameter.compile)
			try
				ext.parameter = ext.fun.parameter.compile(ext.parameter, context);
			catch
				extension_warning(ext, 'Parameter compilation failed.', lasterror);
			end
		end
		
		%--
		% compute 
		%--
		
		value = struct;
		
		try
			[value, context(k)] = ext.fun.compute(page, ext.parameter, context(k));
		catch
			extension_warning(feature(k), 'Compute failed.', lasterror);
		end
		
		%--
		% display view
		%--
		
		if ~view(k)
			continue;
		end

		context(k).view.handles = [];

		try
			context(k).view.handles = ext.fun.view.display( ...
				context(k).view.figure, value, context(k).view.parameter, context(k) ...
			);
		catch
			extension_warning(ext, 'Multi-channel view failed.', lasterror);
		end

		% NOTE: waitbar update calls drawnow
		
		if ~waiting
			drawnow;
		end
		
		%--
		% store feature values
		%--
		
		% NOTE: each page adds and element to value, later collapsed
		
		if nargout
			out(k).value{end + 1} = value;
		end
		
	end
	
	%--
	% turn a page
	%--
	
	[page, scan] = get_scan_page(scan);
	
end

%--
% make sure view objects are visible
%--

for k = 1:length(view)

	if ~view(k)
		continue;
	end 

	%--
	% get explain handles
	%--

	view_all = findobj(context(k).view.figure);

	view_axes = findobj(context(k).view.figure, 'type', 'axes');

	%--
	% make sure objects are displayed and axes grids visible
	%--

	set(setdiff(view_all, view_axes), 'visible', 'on');

	% NOTE: this resolves the display problem with the tool and status

	% NOTE: another way might be making these axes callback visible

	tags = get(view_axes, 'tag');

	if ischar(tags)
		tags = {tags};
	end

	for k = length(tags):-1:1

		if ~isempty(findstr(tags{k}, 'HARRAY'))
			view_axes(k) = [];
		end

	end

	set(view_axes, 'layer', 'top');

end

%--
% collapse feature values
%--

if nargout
	
	
end


