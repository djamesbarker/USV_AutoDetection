function filter_dispatch(obj, eventdata, ext, control_callback)

% filter_dispatch - callback dispatch for filter extensions
% ---------------------------------------------------------
%
% filter_dispatch(obj, eventdata, par, ext, control_callback)
%
% Input:
% ------
%  obj, eventdata - MATLAB callback inputs
%  par - parent browser
%  ext - filter extension
%  control_callback - control specific callback, typically empty

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

%----------------------------
% SETUP
%----------------------------

%--
% get callback context from handle
%--

callback = get_callback_context(obj, 'pack'); 

par = callback.par.handle;

%--
% get fresh extension
%--

[ext, ignore, context] = get_browser_extension(ext.subtype, par, ext.name);

%--
% set default result
%--

result = [];

%----------------------------
% CALLBACKS
%----------------------------

switch callback.control.name
		
	%----------------------
	% CONTROL PANEL
	%----------------------
	
	case 'refresh'
		
		pal = refresh_extension(callback, context);
		
		% NOTE: this will update the parent only when we are active
		
		if ~isempty(pal)
			update_parent_display(pal);
		end
		
		return;
	
	case 'active'

		% TODO: consider a 'set_active_extension' function
		
		%--
		% update active filter state
		%--
		
		% NOTE: we compute command string from control value
		
		if get(obj, 'value')
			str = ext.name; 
		else
			str = 'No Filter'; 
		end
				
		browser_filter_menu(callback.par.handle, str, ext.subtype); 
		
		% NOTE: the call to the filter gateway updates the parent, so we return
		
		return;
		
	%----------------------
	% EXTENSION
	%----------------------
		
	otherwise
		
		%--
		% yield to extension callback function
		%--
		
		% TODO: handle control specific callback
		
		fun = ext.fun.parameter.control.callback;
		
		if ~isempty(fun)
			try
				result = fun(callback, context);
			catch
				extension_warning(ext, 'Parameter control callback failed.', lasterror);
			end
		end
	
end

%--
% consider callback result
%--

% NOTE: return if result indicate no need for update

if ~isempty(result) && isfield(result, 'update') && ~result.update
	return;
end

%--
% update display considering results
%--

update_parent_display(callback.pal.handle);
