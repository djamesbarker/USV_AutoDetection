function pal = palette_create(name,par);

% palette_create - create palette using extension framework
% ---------------------------------------------------------
%
% pal = palette_create(name,par)
%
% Input:
% ------
%  name - palette name
%  par - parent handle
%
% Output:
% -------
%  pal - palette handle

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
% Author: Harold Figueroa
%--------------------------------
% $Revision: 4630 $
% $Date: 2006-04-17 19:07:15 -0400 (Mon, 17 Apr 2006) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% set no parent default
%--

if (nargin < 2)
	par = [];
end

%--
% check for browser parent
%--

if (~isempty(par) && ~is_browser(par))
	error('Input parent is not browser handle.');
end

%--
% handle multiple palette requests recursively
%--

if (iscellstr(name))
	
	pal = cell(size(name));
	
	for k = 1:numel(name)
		pal{k} = palette_create(name{k},par);
	end
	
	return;
	
end

%--
% get extension by name
%--

ext = get_extensions('sound_browser_palette','name',name);

if (isempty(ext))
	result = []; return;
end
	
%--------------------------------
% CREATE PALETTE
%--------------------------------

%--
% check parent for existing palette
%--

pal = get_palette(par,name);

if (~isempty(pal))
	return;
end

%--
% render palette
%--

pal = palette_render(ext,par);

%--
% register palette with parent if needed
%--

if (par)
	register_palette(par,pal);
end


%----------------------------------
% PALETTE_RENDER
%----------------------------------

% NOTE: consider making this a separate function

function pal = palette_render(ext,par)

% palette_render - render extension palette
% -----------------------------------------
%
% pal = palette_render(ext,par)
%
% Input:
% ------
%  ext - palette extension
%  par - parent handle
%
% Output:
% -------
%  pal - palette handle

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 4630 $
% $Date: 2006-04-17 19:07:15 -0400 (Mon, 17 Apr 2006) $
%--------------------------------

%---------------------
% HANDLE INPUT
%---------------------

%--
% set empty parent
%--

if (nargin < 2)
	par = [];
end

%---------------------
% RENDER PALETTE
%---------------------

%--
% get palette controls
%--

control = ext.control__create();

%--
% get palette options
%--

opt = control_group;

if (ext.control__options)
	opt = struct_update(opt,ext.control__options());
end

%--
% create palette
%--

pal = control_group(par,{@palette_callback,ext},ext.name,control,opt);


%----------------------------------
% PALETTE_CALLBACK
%----------------------------------

function result = palette_callback(obj,eventdata,ext)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 4630 $
% $Date: 2006-04-17 19:07:15 -0400 (Mon, 17 Apr 2006) $
%--------------------------------

result = [];

callback = get_callback_context(obj,'pack'); 

%----------------------------
% CALLBACKS
%----------------------------

switch (callback.control.name) 
		
	%----------------------
	% PRESET
	%----------------------
	
	case ('preset')
				
		% TODO: make robust and output status
				
		load_preset(obj,eventdata); return;
	
	case ('new_preset')
		
		% TODO: consider using new modal dialog framework
		
		show_new_preset(obj,eventdata); return;
		
	%----------------------
	% FILTER
	%----------------------
	
	case ('opacity')
		
		slider_sync(obj,callback.control.handles);

		control_flash(callback.control,callback.pal);
	
	case ('active')

		%--
		% update active filter state
		%--
		
		% NOTE: we compute command string from control value
		
		if (get(obj,'value') == 1)
			str = callback.pal.name; 
		else
			str = 'No Filter'; 
		end
				
		browser_filter_menu(callback.par.handle,str);
		
	%----------------------
	% EXTENSION
	%----------------------
		
	otherwise
		
		%--
		% sync slider if needed
		%--
		
		if (has_slider(callback.control.handles))
			slider_sync(obj,callback.control.handles);
		end
		
		%--
		% flash control to indicate callback
		%--
		
		% NOTE: consider hover fade behavior here
		
		control_flash(callback.control,callback.pal);

		%--
		% yield to extension callback function
		%--
		
		% TODO: handle control specific callback
		
		fun = filter.fun.parameter.control.callback;
				
		if (~isempty(fun))
			result = fun(callback);
		end
				
		%--
		% update preset control
		%--

		% TODO: this model for preset 'documents' needs to be reconsidered

		% NOTE: this sets the preset control to display '(Manual)'
		
		control_update([],callback.pal.handle,'preset',1);
	
end

%--
% consider callback result
%--

% NOTE: the empty result is a default option

if (~isempty(result))
		
	% NOTE: return if results indicate no need for update
	
	if (~result.update)
		return;
	end
	
end

%--
% update display considering results
%--

update_parent_display(callback.pal.handle);
