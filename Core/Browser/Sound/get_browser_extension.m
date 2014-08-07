function [ext, ix, context] = get_browser_extension(type, par, name, data)

% get_browser_extension - get extension with up to date browser state
% -------------------------------------------------------------------
%
% [ext, ix, context] = get_browser_extension(type, par, name, data)
%
% Input:
% ------
%  type - extension type
%  par - parent browser
%  name - extension name
%  data - browser state
%
% Output:
% -------
%  ext - extension
%  ix - index of extension in browser store
%  context - context used

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

% TODO: handle extension exceptions and produce extension warnings

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% try to get browser
%--

if isempty(par)
	
	par = get_active_browser;
	
	if isempty(par)
		[ext, context] = get_extension(type, name); ix = []; return;
	end
	
end

%--
% check browser and get state if needed
%--

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

if (nargin < 4) || isempty(data)
	data = get_browser(par);
end

%--
% check extension type and existence of browser store for type
%--

if ~ismember(type, get_extension_types)
	error(['Unrecognized extension type ''', type, '''.']);
end

% NOTE: we set empty outputs because we do not want to throw errors here

ext = []; ix = []; context = [];

if ~isfield(data.browser, type)
	return;
end

if isempty(data.browser.(type).ext)
	return;
end 

%-------------------------
% GET EXTENSION
%-------------------------

%--
% get extension from browser registry by name
%--

ix = find(strcmp(name, {data.browser.(type).ext.name}));

if isempty(ix)
	return;
end

ext = data.browser.(type).ext(ix);

%--
% compile generic context
%--

% TODO: create extension type dependent context compilation function

% GENERAL FIELDS

context.ext = ext; 

context.user = get_active_user;

context.library = get_active_library;

context.sound = sound_update(data.browser.sound, data); 

% BROWSER FIELDS

% NOTE: it seems like we could also get relevant library and user from parent browser

context.par = par;

context.page.start = data.browser.time;

context.page.duration = data.browser.page.duration; 

context.page.channels = get_channels(data.browser.channels);

% MISC FIELDS

context.debug = 0;

% NOTE: this is useful in extension displays, put it with browser fields?

context.display.grid = data.browser.grid;

%--
% consider if and what we need to do to get updated extension
%--
	
pal = get_palette(par, name, data); compile = ext.fun.parameter.compile;

if ~isempty(ext.parameter) && isempty(pal)
	
	% NOTE: we compile to ensure fresh context
	
	if ~isempty(compile)
		
		try
			[ext.parameter, context] = compile(ext.parameter, context);
		catch
			extension_warning(ext, 'Parameter compilation failed.', lasterror);
		end
		
	end
	
	return;

end

%--
% get control values
%--

if ~isempty(pal)
	
	ext.control = get_control_values(pal);
	
	if isfield(ext.control, 'debug')
		context.debug = ext.control.debug;
	end
	
end

%--
% create extension parameters if needed
%--

if isempty(ext.parameter)

	create = ext.fun.parameter.create;

	if isempty(create)
		return;
	end

	try
		ext.parameter = create(context);
	catch
		extension_warning(ext, 'Parameter creation failed.', lasterror);
	end

	if isempty(ext.parameter)
		return;
	end

end

%--
% update extension parameters using palette and compile if needed
%--

if ~isempty(pal)
	
	% NOTE: update must be configured to be shallow
	
	opt = struct_update; opt.flatten = 0;
	
	ext.parameter = struct_update(ext.parameter, ext.control, opt);
	
end

if ~isempty(compile)
	
	try
		[ext.parameter, context] = compile(ext.parameter, context);
	catch
		extension_warning(ext, 'Parameter compilation failed.', lasterror);
	end

end




