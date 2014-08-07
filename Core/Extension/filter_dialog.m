function out = filter_dialog(ext, context)

%--
% get controls
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

controls = get_filter_controls(ext, context, [], 'dialog');

%--
% set base options
%--

opt = dialog_group;

opt.left = 1; opt.right = 1;

opt.width = 9;

%--
% update configuration with filter specific configuration options
%--

if ~isempty(ext.fun.parameter.control.options)

	try
		opt = struct_update(opt, ext.fun.parameter.control.options(context));
	catch
		extension_warning(ext, 'Parameter compilation failed.', lasterror);
	end

end

%--
% set fixed configuration fields after possible update
%--

% NOTE: header at top requires this 

opt.top = 0;

% NOTE: the first field is a useful convention, the second essential

opt.header_color = get_extension_color(ext); opt.ext = ext;

%--
% create dialog group
%--

out = dialog_group(ext.name, controls, opt, {@filter_dispatch, ext});


