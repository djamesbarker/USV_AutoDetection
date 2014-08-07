function out = browser_filter_menu(par, str, type)

% browser_filter_menu - create menus for filters extensions
% ---------------------------------------------------------
%
% out = browser_filter_menu(par, str, type)
%
% Input:
% ------
%  par - browser handle
%  str - command string
%  type - extension type
% 
% Output:
% -------
%  out - command dependent output

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
% SETUP
%--------------------------------------------

% NOTE: consider returning if there are no filters at all

%--
% get and sort able signal filters 
%--

SIG_FILTER = get_able_extensions('signal_filters');

if ~isempty(SIG_FILTER)
	
	SIG_FILTER_NAME = {SIG_FILTER.name}';

	category = get_extension_categories(SIG_FILTER);
	
	SIG_CATEGORY = {category.name}';
	
	SIG_CATEGORY_FILTER = {category.children}';
	
else
	
	SIG_FILTER_NAME = cell(0);
	
	SIG_CATEGORY = cell(0); SIG_CATEGORY_FILTER = cell(0);
	
end

%--
% get and sort able image filters
%--

IMG_FILTER = get_able_extensions('image_filters');

if ~isempty(IMG_FILTER)
	
	IMG_FILTER_NAME = {IMG_FILTER.name}';

	category = get_extension_categories(IMG_FILTER);
	
	IMG_CATEGORY = {category.name}';
	
	IMG_CATEGORY_FILTER = {category.children}';

else
	
	IMG_FILTER_NAME = cell(0);
	
	IMG_CATEGORY = cell(0); IMG_CATEGORY_FILTER = cell(0);
	
end

%--------------------------------------------
% HANDLE INPUT
%--------------------------------------------

%--
% set default command string
%--

if (nargin < 2)
	str = 'Initialize';
end

% NOTE: set command as default output

out = str;

%--
% set default parent figure
%--

if (nargin < 1)
	par = gcf;
end

%--
% get parent state
%--

data = get_browser(par);

%----------------------------------------------------------------------
% COMMAND SWITCH
%----------------------------------------------------------------------

switch str

%------------------------------------------------
% INITIALIZE
%------------------------------------------------

case 'Initialize'

	%--
	% check for existing filter menu
	%--
	
	if get_menu(par, 'Filter')
		return;
	end
	
	%-------------------------
	% Filter
	%-------------------------
		
	L = { ... 
		'Filter', ...
		'(Active)', ...
		'Signal', ...
		'Image' ...
	};
	
	n = length(L); 
	
	S = bin2str(zeros(1, n));
	
	g = menu_group(par, 'browser_filter_menu', L, S);

	%--
	% position top menu and disable header
	%--
	
	% NOTE: the top menu is used in later parts of code
	
	g1 = g(1);
	
	set(g1,'position',5); 
	
	set(g(2),'enable','off');

	%-------------------------
	% Active
	%-------------------------
		
	%--
	% Signal
	%--
	
	if ~isempty(SIG_FILTER)
		
		SIG_FILTER_ACTIVE = SIG_FILTER_NAME;
		
		L = {'No Filter', SIG_FILTER_ACTIVE{:}}; n = length(L); 
		
		S = bin2str(zeros(1,n)); S{2} = 'on';
		
		temp = menu_group(get_menu(g, 'Signal'), 'browser_filter_menu', L, S);
		
		set(get_menu(temp, 'No Filter'), 'check', 'on');
		
		set(temp, 'tag', 'signal_filter');
		
	else
		
		temp = get_menu(g, 'Signal'); g = setdiff(g, temp); delete(temp);
				
	end
	
	%--
	% Image
	%--
		
	if ~isempty(IMG_FILTER)
		
		IMG_FILTER_ACTIVE = IMG_FILTER_NAME;
		
		L = {'No Filter', IMG_FILTER_ACTIVE{:}}; n = length(L);
		
		S = bin2str(zeros(1,n)); S{2} = 'on';
		
		temp = menu_group(get_menu(g, 'Image'), 'browser_filter_menu', L, S);
		
		set(get_menu(temp, 'No Filter'), 'check', 'on');
		
		set(temp, 'tag', 'image_filter');
		
	else
		
		temp = get_menu(g, 'Image'); g = setdiff(g, temp); delete(temp);
						
	end
	
	%-------------------------
	% Signal
	%-------------------------
	
	if ~isempty(SIG_FILTER)
						
		%--
		% create signal filter header menu
		%--
				
		uimenu(g1, ...
			'label', '(Signal)', ...
			'separator', 'on', ...
			'enable', 'off' ...
		);
	
		%--
		% create filter category menus
		%--
		
		% NOTE: the logic here is correct but quirky
		
		if (length(SIG_CATEGORY) > 1) && isempty(SIG_CATEGORY{1})
			ki = 2;
		else
			ki = 1;
		end
			
		for k = ki:length(SIG_CATEGORY)
	
			temp = uimenu(g1, 'label', SIG_CATEGORY{k});
			
			%--
			% add category filters menu
			%--
			
			temp2 = menu_group(temp, 'browser_filter_menu', strcat(SIG_CATEGORY_FILTER{k}, ' ...'));
		
			set(temp2, 'tag', 'signal_filter');
			
		end
				
		%--
		% create 'Other' category menu
		%--
		
		if (ki == 2)
			
			temp = uimenu(g1, 'label', 'Other');
		
			temp2 = menu_group(temp, 'browser_filter_menu', strcat(SIG_CATEGORY_FILTER{1}, ' ...'));
			
			set(temp2, 'tag', 'signal_filter');
			
		end
		
	end

	%-------------------------
	% Image Filters
	%-------------------------
	
	if ~isempty(IMG_FILTER)
			
		%--
		% create image filters header menu
		%--
		
		uimenu(g1, ...
			'label', '(Image)', ...
			'separator', 'on', ...
			'enable', 'off' ...
		);
	
		%--
		% create filter category menus
		%--
		
		if (length(IMG_CATEGORY) > 1) & isempty(IMG_CATEGORY{1})
			ki = 2;
		else
			ki = 1;
		end
			
		for k = ki:length(IMG_CATEGORY)
			
			%--
			% create category menu
			%--

			temp = uimenu(g1, 'label', IMG_CATEGORY{k});
			
			%--
			% add category filters menu
			%--
			
			temp2 = menu_group(temp, 'browser_filter_menu', strcat(IMG_CATEGORY_FILTER{k}, ' ...'));
		
			set(temp2, 'tag', 'image_filter');
			
		end
				
		%--
		% create other category menu
		%--
		
		if (ki == 2)
			
			temp = uimenu(g1, 'label', 'Other');
		
			temp2 = menu_group(temp, 'browser_filter_menu', strcat(IMG_CATEGORY_FILTER{1}, ' ...'));
			
			set(temp2, 'tag', 'image_filter');
			
		end
		
	end
	
	%--
	% add refresh and show files
	%--
	
	if xbat_developer
		
		uimenu(g1, ...
			'label', 'Refresh', ...
			'separator', 'on', ...
			'callback', @refresh_filter_menu ...
		);
	
		uimenu(g1, ...
			'label', 'Show Files ...', ...
			'callback', @show_filter_files ...
		);
		
	end
	
	%--
	% update extension store
	%--
	
	data = update_extension_store(data, {'signal_filter', 'image_filter'});
	
	%--
	% update state
	%--
	
	set(par, 'userdata', data);

%------------------------------------------------
% ACTIVE FILTER
%------------------------------------------------

%--
% turn off active filter
%--

case { ...
	'No Filter', 'No Signal Filter', 'No Image Filter' ...
}
	
	%--
	% try to get filter type needed
	%--
	
	if (nargin < 3) || isempty(type)
	
		type = '';

		switch str

			% NOTE: these cases are for programmatic control of the filter state

			case 'No Signal Filter', type = 'signal_filter';

			case 'No Image Filter', type = 'image_filter';

				% NOTE: type is obtained through callback object

			otherwise

				switch get(gcbo, 'type')

					case 'uimenu'

						type = get(gcbo, 'tag');

					case 'uicontrol'

						pal = ancestor(gcbo, 'figure');

						name = get(pal, 'name');

						type = extension_type_from_name(name);

				end

		end

		% NOTE: return if we were unable to determine type uniquely

		if isempty(type) || iscell(type)
			return;
		end

	end
	
	%--
	% turn off active filter of given type
	%--
	
	data.browser.(type).active = '';
		
	set(par, 'userdata', data);
	
	%--
	% update active detection menu
	%--
		
	% TODO: move this code to update active controls, menus are controls
	
	g = findobj(par, ...
		'type', 'uimenu', 'label', 'Filter', 'parent', par ...
	);
	
	% NOTE: we are using the label variable to get the menus that need updating
	
	g =  get(get_menu(g, strtok(title_caps(type), ' ')), 'children');	
	
	set(g, 'check', 'off');
	
	set(get_menu(g, 'No Filter'), 'check', 'on');
	
	%--
	% update active detection controls in available palettes
	%--
	
	update_active_controls(par, type, data.browser.(type).active, data);

	%--
	% update display
	%--
	
	browser_view_menu(par, 'scrollbar', data);
			
%--
% set active filter
%--

case { ...
	SIG_FILTER_NAME{:}, IMG_FILTER_NAME{:} ...
}
	
	%--
	% get type of filter to activate
	%--
	
	if (nargin < 3) || isempty(type)
		
		type = '';

		if strcmp(get(gcbo, 'type'), 'uimenu')
			type = get(gcbo, 'tag');
		end

		if isempty(type)
			type = extension_type_from_name(str);
		end

		% NOTE: return if we were unable to determine type

		if isempty(type) || iscell(type)
			return;
		end
		
	end
	
	%--
	% set active filter state
	%--

	data.browser.(type).active = str;
	
	set(par, 'userdata', data);
	
	%--
	% update active detection menu
	%--
			
	g = findobj(par, ...
		'type', 'uimenu', 'label', 'Filter', 'parent', par ...
	);
	
	% NOTE: we are using the label variable to get the menus that need updating
	
	g =  get(get_menu(g, strtok(title_caps(type), ' ')), 'children');
	
	set(g, 'check', 'off');
	
	set(get_menu(g, str), 'check', 'on');
	
	%--
	% update active detection controls in available palettes
	%--
	
	update_active_controls(par, type, data.browser.(type).active, data);
	
	%--
	% update display
	%--
	
	browser_view_menu(par, 'scrollbar', data);
	
%------------------------------------------------
% FILTER ...
%------------------------------------------------

% NOTE: open filter control palette and return palette handle

case ( ...
	strcat({SIG_FILTER_NAME{:}, IMG_FILTER_NAME{:}},' ...') ...
)
	
	% NOTE: remove trailing space and periods from command string

	str = str(1:end - 4); 
	
	%--
	% try to get filter extension type if not provided
	%--
	
	if (nargin < 3) || isempty(type)
		
		type = '';

		if strcmp(get(gcbo, 'type'), 'uimenu')
			type = get(gcbo, 'tag');
		end

		if isempty(type)
			type = extension_type_from_name(str);
		end

		% NOTE: return if we were unable to determine type

		if isempty(type) || iscell(type)
			return;
		end
		
	end
	
	%---------------------------
	% CHECK FOR PALETTE
	%---------------------------
	
	%--
	% check for existing palette
	%--
	
	out = get_palette(par, str, data);

	% NOTE: further check the type and position and return if palette exists

	for k = 1:length(out)

		info = parse_tag(get(out(k), 'tag'), '::', {'ignore', 'type', 'name'});

		if strcmpi(type, info.type)
			position_palette(out(k), par, 'center'); return;
		end

	end
	
	%---------------------------
	% GET FILTER EXTENSION
	%---------------------------
	
	% NOTE: we get filter from browser registry with stored state
	
	[ext, ignore, context] = get_browser_extension(type, par, str, data);
	
	%--
	% find out if extension is active
	%--
	
	active_state = double(strcmp(data.browser.(type).active, str));
	
	%--
	% generate extension controls
	%--
	
	control = get_filter_controls(ext, context, active_state);
	
	%--------------------------------------------------
	% FILTER PALETTE OPTIONS
	%--------------------------------------------------
	
	%--
	% set default filter palette configuration
	%--

	opt = control_group;

	opt.left = 1; opt.right = 1;

	opt.width = 9;
	
	% NOTE: filter controls set bottom margin
	 
	opt.bottom = 0;
		
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
	
	%--------------------------------------------------
	% CREATE FILTER PALETTE
	%--------------------------------------------------
	
	%--
	% create control group
	%--
	
	pal = control_group(par, '', str, control, opt);
	
	%--
	% set palette tag, key press, and close request function
	%--
	
	% NOTE: control values are updated in parent as part of close request function
	
	set(pal, ...
		'visible','off', ...
		'keypressfcn', {@browser_keypress_callback, par}, ...
		'closerequestfcn',['delete_palette(' num2str(par) ',''' str ''');'] ...
	);
	
	%--
	% register palette with parent and set parent windowbuttondown function
	%--
	
	n = length(data.browser.palettes);
	
	data.browser.palettes(n + 1) = pal;
	
	set(par, ...
		'userdata', data, ...
		'buttondown', 'browser_palettes(gcf,''Show'');' ...
	);
	
	%--
	% position palette relative to parent
	%--
	
	position_browser_palette(par, pal, data);
	
	%--
	% output palette handle
	%--
	
	out = pal;
	
	update_selection_buttons(par, data.browser.selection);
	
end


% %-------------------------------------------------------------------------
% % FILTER_DISPATCH
% %-------------------------------------------------------------------------
% 
% function filter_dispatch(obj, eventdata, par, ext, control_callback)
% 
% % filter_dispatch - callback dispatch for filter extensions
% % ---------------------------------------------------------
% %
% % filter_dispatch(obj, eventdata, par, ext, control_callback)
% %
% % Input:
% % ------
% %  obj, eventdata - MATLAB callback inputs
% %  par - parent browser
% %  ext - filter extension
% %  control_callback - control specific callback, typically empty
% 
% %----------------------------
% % SETUP
% %----------------------------
% 
% %--
% % get callback context from handle
% %--
% 
% callback = get_callback_context(obj, 'pack'); 
% 
% %--
% % get fresh extension
% %--
% 
% [ext, ignore, context] = get_browser_extension(ext.subtype, par, ext.name);
% 
% %--
% % set default result
% %--
% 
% result = [];
% 
% %----------------------------
% % CALLBACKS
% %----------------------------
% 
% switch callback.control.name
% 		
% 	%----------------------
% 	% CONTROL PANEL
% 	%----------------------
% 	
% 	case 'refresh'
% 		
% 		pal = refresh_extension(callback, context);
% 		
% 		% NOTE: this will update the parent only when we are active
% 		
% 		if ~isempty(pal)
% 			update_parent_display(pal);
% 		end
% 		
% 		return;
% 	
% 	case 'active'
% 
% 		% TODO: consider a 'set_active_extension' function
% 		
% 		%--
% 		% update active filter state
% 		%--
% 		
% 		% NOTE: we compute command string from control value
% 		
% 		if get(obj, 'value')
% 			str = ext.name; 
% 		else
% 			str = 'No Filter'; 
% 		end
% 				
% 		browser_filter_menu(callback.par.handle, str, ext.subtype); 
% 		
% 		% NOTE: the call to the filter gateway updates the parent, so we return
% 		
% 		return;
% 		
% 	%----------------------
% 	% EXTENSION
% 	%----------------------
% 		
% 	otherwise
% 		
% 		%--
% 		% yield to extension callback function
% 		%--
% 		
% 		% TODO: handle control specific callback
% 		
% 		fun = ext.fun.parameter.control.callback;
% 		
% 		if ~isempty(fun)
% 			try
% 				result = fun(callback, context);
% 			catch
% 				extension_warning(ext, 'Parameter control callback failed.', lasterror);
% 			end
% 		end
% 	
% end
% 
% %--
% % consider callback result
% %--
% 
% % NOTE: return if result indicate no need for update
% 
% if ~isempty(result) && isfield(result, 'update') && ~result.update
% 	return;
% end
% 
% %--
% % update display considering results
% %--
% 
% update_parent_display(callback.pal.handle);


%-------------------------------------------------------------------------
% UPDATE_PARENT_DISPLAY
%-------------------------------------------------------------------------

function update_parent_display(pal)

% update_parent_display - update parent display on filter state change
% --------------------------------------------------------------------
%
% par = update_parent_display(pal)
%
% Input:
% ------
%  pal - filter extension palette
%
% Output:
% -------
%  par - updated parent

% TODO: update this to include active detection update

% NOTE: previously this was achieved with the 'Scrollbar' callback

%--
% set default palette handle
%--

% NOTE: since this is usually called after updating a palette control it makes sense

if (nargin < 1)
	pal = gcf;
end

%--
% check for parent
%--

par = get_xbat_figs('child', pal);

if isempty(par)
	return;
end

%--
% get parent userdata
%--

data = get(par, 'userdata');

%--
% get relevant filter state information
%--

% NOTE: get palette filter from name

filter_name = get(pal, 'name'); 

% NOTE: get active filters from parent

signal_filter = data.browser.signal_filter.active;

image_filter = data.browser.image_filter.active;

%--
% update parent if needed
%--

if strcmp(signal_filter, filter_name) || strcmp(image_filter, filter_name)
	
	browser_view_menu(par, 'scrollbar', data);

end


%---------------------------------------------
% DEVELOPER CALLBACK FUNCTIONS
%---------------------------------------------

%--
% new extension dialog
%--

function new_extension_callback(obj, eventdata, type)

new_extension_dialog(type);


%--
% refresh filter menu
%--

function refresh_filter_menu(obj, eventdata)

get_extensions('!'); update_filter_menu;


%--
% show filter files
%--

function show_filter_files(obj, eventdata)

filters_root = [extensions_root, filesep, 'Filters'];

show_file(filters_root);


