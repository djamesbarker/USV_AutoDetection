function ext = source_dialog(ext, context)

% attribute_dialog - create dialog for editing a source extension
% ---------------------------------------------------------------
%
% ext = attribute_dialog(ext, context)
%
% Input:
% ------
%  ext - the extension
%  context - the context
%
% Output:
% -------
%  ext - the extension with modified parameters

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

if nargin < 2
	context = [];
end

%--
% create controls
%--

control = empty(control_create);

control(end + 1) = control_create( ...
	'string', title_caps(ext.name), ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1 ...
);

ext_control = empty(control_create);

if ~isempty(ext.fun.parameter.control.create)
	
	try
		ext_control = ext.fun.parameter.control.create(ext.parameter, context);
	catch
		extension_warning(ext, 'Control creation failed.', lasterror);
	end

	for k = 1:length(ext_control)
		control(end + 1) = ext_control(k);
	end

end

%--
% configure dialog
%--

opt = dialog_group;

% NOTE: add color according to parent context

opt.header_color = get_extension_color('root');

opt.ext = ext;

opt.width = 12;

%--
% present dialog
%--

callback = {@callback_router, ext.fun.parameter.control.callback, context};

out = dialog_group('Source', control, opt, callback);

if ~strcmp(out.action, 'ok')
	return;
end

ext.parameter = struct_update(ext.parameter, out.values);


%----------------------------------------
% CALLBACK_ROUTER
%----------------------------------------

function callback_router(obj, eventdata, fun, context)

%--
% get callback context
%--

callback = get_callback_context(obj, 'pack');

%--
% call extension specific callback
%--

if ~isempty(fun)
	fun(callback, context);
end
