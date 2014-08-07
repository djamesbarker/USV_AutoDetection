function out = action_dialog(target, ext, parameter, context)

% action_dialog - present action dialog
% -------------------------------------
%
% out = action_dialog(target, ext, parameter, context)
%
% Input:
% ------
%  target - action target array
%  ext - action extension
%  parameter - action parameters
%  context - action context
%
% Output:
% -------
%  out - dialog output

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

%--
% create controls
%--

control = empty(control_create);

control(end + 1) = control_create( ...
	'string', 'Parameters', ...
	'style', 'separator', ...
	'type', 'header', ...
	'space', 0.75, ...
	'min', 1 ...
);

ext_control = empty(control_create);

if ~isempty(ext.fun.parameter.control.create)
	try
		ext_control = ext.fun.parameter.control.create(parameter, context);
	catch
		extension_warning(ext, 'Control creation failed.', lasterror);
	end
end

if length(ext_control)
	control(end) = adjust_control_space(control(end), ext_control(1));
end
	
for k = 1:length(ext_control)
	control(end + 1) = ext_control(k);
end

%--
% configure dialog
%--

opt = dialog_group;

% NOTE: add color according to parent context

if strcmp(ext.subtype, 'event_action')
	header_type = 'sound_browser_palette';
else
	header_type = 'root';
end 

opt.header_color = get_extension_color(header_type);

if ~isempty(ext.fun.parameter.control.options)
	try
		opt = struct_update(opt, ext.fun.parameter.control.options(context));
	catch
		extension_warning(ext, 'Control configuration options failed.', lasterror);
	end
end

opt.ext = ext;

%--
% present dialog
%--

% TODO: route callback and pass context in the router

par = context.callback.par.handle;

out = dialog_group(ext.name, ...
	control, opt, {@callback_router, ext, context}, par ...
);


%----------------------------------------
% CALLBACK_ROUTER
%----------------------------------------

function callback_router(obj, eventdata, ext, context)

%--
% handle input
%--

% NOTE: return if there is no callback

if isempty(ext.fun.parameter.control.callback)
	return;
end

%--
% get callback context
%--

callback = get_callback_context(obj, 'pack');

%--
% call extension specific callback
%--

try
	ext.fun.parameter.control.callback(callback, context);
catch
	extension_warning(ext, 'Control callback failed.', lasterror);
end

