function pal_menu(pal, str, type)

% pal_menu - developer menu for extension palettes
% ------------------------------------------------
% 
% pal_menu(pal, str, type)
%
% Input:
% ------
%  pal - palette handle
%  str - command string
%  type - extension type

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

% TODO: handle the situation where extensions are not under revision control

%------------------------------------------------------------

% NOTE: this feature is for developers

if ~xbat_developer
	return;
end

%------------------------------------------------------------

%-----------------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------------

%--
% set default empty type
%--

% NOTE: this code and this input are no longer needed!

if (nargin < 3)
	
	data = get(pal, 'userdata'); opt = data.opt;
	
	if isfield(opt, 'ext')
		type = opt.ext.subtype;
	else
		type = '';
	end
	
end

%--
% set default command
%--

if (nargin < 2) || isempty(str)
	str = 'Initialize';
end

% NOTE: disable docking of dialog and palette figures

set(pal, 'dockcontrols', 'off');

%-----------------------------------------------------------
% PALETTE EXTENSION INFO
%-----------------------------------------------------------

%--
% get extension using palette tag
%--

tag = get(pal, 'tag');

info = parse_tag(get(pal, 'tag'), '::', {'ignore', 'type', 'name'});

ext = get_extensions(lower(info.type), 'name', info.name);

if length(ext) > 1
	error(['Unable to select unique extension by name.']);
end

%--
% get main info
%--

info = functions(ext.fun.main);

ext_main_name = info.function;

ext_main = info.file;

ext_dir = extension_root(ext);

%--
% get function names and flatten extension fun structure
%--

name = extension_signatures(ext.subtype);

fun = flatten_struct(rmfield(ext.fun, 'main'));

%--
% get functions info
%--

ADD_LIST = cell(0); 

EDIT_LIST = {ext_main_name}; 

EDIT_FILE = {ext_main};

for k = 1:length(name)

	% NOTE: this is not a normal condition, it should perhaps trigger a message
	
	if ~isfield(fun, name{k})
		continue;
	end
	
	% NOTE: check for availability of function by looking at handle
	
	f = fun.(name{k});
	
	%--
	% unavailable function
	%--
	
	% NOTE: handle is empty, function neither exists or is inherited
	
	if isempty(f)
		ADD_LIST{end + 1} = name{k}; continue;
	end
	
	%--
	% inherited function
	%--
	
	% NOTE: function is not in extension directory, it is inherited
	
	file = get_field(functions(f), 'file');
	
	if isempty(strmatch(ext_dir, file))
		ADD_LIST{end + 1} = name{k}; continue;
	end
	
	%--
	% available function
	%--
	
	% NOTE: a non-empty handle exists in our directory
	
	EDIT_LIST{end + 1} = name{k};
	
	EDIT_FILE{end + 1} = file;
	
end

% NOTE: add when there are files to add

if length(ADD_LIST)
	ADD_LIST{end + 1} = 'Add All ...';
end

EDIT_LIST{end + 1} = 'Edit All ...';

%--
% get helper functions info
%--

% TODO: add support for multiple editable types 

% NOTE: get names of m-files in 'Helpers' directory 

HELPER_LIST = sort(file_ext(get_field(what_ext([ext_dir, filesep, 'Helpers'],'m'),'m')));

% NOTE: add when there are multiple files to edit

if (length(HELPER_LIST) > 1)
	HELPER_LIST{end + 1} = 'Edit All ...';
end

%--
% get svn info
%--

in_svn = is_working_copy(extension_root(ext));

%-----------------------------------------------------------
% COMMANDS
%-----------------------------------------------------------

switch str
	
	%-----------------------------------------------------------
	% INITIALIZE
	%-----------------------------------------------------------
	
	case 'Initialize'
		
		%--
		% set top level names
		%--
		
		name_1 = 'EXT';
		
		name_2 = 'SVN';
		
		%--
		% check for exising menu
		%--
		
		% NOTE: we assume this indicates presence of all menus
		
		temp = findobj(pal, 'type', 'uimenu', 'label', name_1);
		
		if ~isempty(temp)
			return;
		end
		
		%------------------------
		% FILE MENU
		%------------------------
		
		%--
		% create main file menu
		%--
		
		% TODO: add help menu, or perhaps a separate function, this should
		% include an 'About Extension ...' menu
		
		L = { ...
			name_1, ...
			'Edit ...', ...
			'(API)', ...
			'Edit', ... 
			'Diff', ... 
			'Add', ...  
			'M-Lint ...', ...
			'(Helpers)', ...
			'Edit', ...
			'Diff', ...
			'Add Helper ...', ...
			'M-Lint ...', ...
			'Refresh', ...
			'Show Files ...', ...
		};
	
		n = length(L);
		
		S = bin2str(zeros(1, n));  
		
		S{3} = 'on';
		S{8} = 'on'; 
		S{end - 1} = 'on';
		
		g = menu_group(pal, 'pal_menu', L, S);
	
		% NOTE: disable diff when subversion is not available
		
		if isempty(tsvn_root)
			set(g([5,10]), 'enable', 'off');
		end
		
		%--
		% special  menu handling
		%--
				
		% NOTE: disable header menus
		
		set(get_menu(g, '(API)'), 'enable', 'off');
		
		set(get_menu(g, '(Helpers)'), 'enable', 'off');

		% NOTE: alias menus for clarity
		
		ix = 4;
		
		API_EDIT = g(ix); 
		
		API_DIFF = g(ix + 1); 
		
		API_ADD = g(ix + 2);
		
		API_LINT = g(ix + 3);
		
		ix = 9;
		
		HELPER_EDIT = g(ix); 
		
		HELPER_DIFF = g(ix + 1);
		
		HELPER_LINT = g(ix + 3);
						
		% NOTE: tag menus to deal with label ambiguities
		
		set(API_EDIT,'tag','api edit');
		
		set(API_DIFF,'tag','api diff');
		
		set(API_LINT,'tag','api lint');
		
		set(HELPER_EDIT,'tag','helper edit');
				
		set(HELPER_DIFF,'tag','helper diff');

		set(HELPER_LINT,'tag','helper lint');
		
		%------------------------
		% API
		%------------------------
		
		%--
		% edit and diff
		%--
		
		par = [API_EDIT, API_DIFF];
		
		for k = 1:length(par)
			
			temp = menu_group(par(k), 'pal_menu', EDIT_LIST); 

			% NOTE: this separates the main function from the rest
			
			if (length(temp) > 1)
				set(temp(2), 'separator', 'on');
			end

			% NOTE: this tags the edit all and separates it
			
			set(temp(end), ...
				'tag', 'api', ...
				'separator', 'on' ...
			); 
		
		end
	
		delete(temp(end)); % NOTE: discard edit all from diff children
		
		%--
		% add
		%--
		
		if isempty(ADD_LIST)
			
			set(API_ADD, 'enable', 'off');
			
		else
			
			temp = menu_group(API_ADD, 'pal_menu', ADD_LIST);
			
			% NOTE: this separates the add all
			
			set(temp(end), ...
				'separator', 'on' ...
			); 
			
		end
		
		%------------------------
		% HELPER
		%------------------------
			
		%--
		% edit and diff
		%--
		
		if isempty(HELPER_LIST)
			
			set([HELPER_EDIT, HELPER_DIFF, HELPER_LINT], 'enable', 'off');
			
		else
			
			par = [HELPER_EDIT, HELPER_DIFF];

			for k = 1:length(par)
				
				temp = menu_group(par(k), 'pal_menu', HELPER_LIST);

				% NOTE: this tags the edit all and separates it
				
				set(temp(end), ...
					'tag', 'helper', ...
					'separator', 'on' ...
				);

			end
			
			delete(temp(end)); % NOTE: discard edit all from diff children
		
		end
		
		%------------------------
		% TOOLS MENU
		%------------------------
		
		% TODO: consider packaging functions 
		
		% TODO: documentation generation and editing
		
		%------------------------
		% SVN MENU
		%------------------------
		
		% TODO: this will be updated when extensions are independent working copies
		
		L = { ...
			name_2, ...
			'Update ...', ...
			'Status ...', ...
			'Commit ...', ...
			'Add ...', ...
			'About TSVN ...', ...
		};
	
		n = length(L);
		
		S = bin2str(zeros(1, n));
		
		S{3} = 'on';
		S{end} = 'on';
		
		g = menu_group(pal, 'pal_menu', L, S);
	
		% NOTE: disable SVN menus when subversion is not installed
		
		if isempty(tsvn_root)
			set(g, 'enable', 'off');
		else
			if ~in_svn
				set(g(2:end - 2), 'enable', 'off');
			end
		end
		
	%-----------------------------------------------------------
	% FILE COMMANDS
	%-----------------------------------------------------------
		
	%------------------------
	% EDIT
	%------------------------
	
	case 'Edit ...'
		
		% TODO: the tag on the 'action' dialogs or 'widget' displays does not conform to this approach
		
		%--
		% get required context to get extension
		%--
		
		call = get_callback_context(gcbo, 'pack');
		 
		info = parse_tag(get(call.pal.handle, 'tag'), '::', {'figure', 'type', 'name'});
		
		%--
		% get and edit extension
		%--
		
		ext = get_extensions(info.type, 'name', info.name);
		
		if isempty(ext)
			return;
		end
		
		% NOTE: clear main function, to get a fresh extension
		
		clear(func2str(ext.fun.main));
		
		ext = new_extension_dialog(ext.fun.main());
		
		%--
		% regenerate main
		%--
		
		regenerate_main(ext);
		
	%------------------------
	% REFRESH
	%------------------------
	
	case 'Refresh'

		% TODO: this should do the same as the button ... the button should do more
		
	%------------------------
	% SHOW FILES
	%------------------------
	
	case 'Show Files ...'
		
		% NOTE: we disable file selection
		
		showf(ext_main, 0);
		
	%------------------------
	% EDIT ALL
	%------------------------
	
	case 'Edit All ...'
		
		%--
		% get option related files
		%--
		
		% NOTE: we get the 'api' or 'helper' option context from menu tag
		
		con = get(gcbo, 'tag');
		
		switch con
			
			case 'api'
				p = [ext_dir, filesep, 'private'];
				
			case 'helper'
				p = [ext_dir, filesep, 'Helpers'];
				
			% NOTE: we simply return if we don't have an option context
			
			otherwise, return;
				
		end

		f = strcat(p, filesep, get_field(what(p), 'm'));
		
		%--
		% build and execute command string to edit files
		%--
				
		str = 'edit ';
		
		% NOTE: add main extension file to list in the 'api' option
		
		if strcmp(con, 'api')
			str = [str, '''', ext_dir, filesep, ext_main_name, ''' '];
		end
		
		for k = 1:length(f)
			str = [str, '''', f{k}, ''' '];
		end
				
		eval(str);
		
	%------------------------
	% API EDIT AND DIFF
	%------------------------
	
	case EDIT_LIST
		
		%--
		% get command from tag
		%--
		
		[ignore, com] = parse_context(get(get(gcbo, 'parent'), 'tag'));
				
		%--
		% build full filename
		%--
		
		if strcmp(str, ext_main_name)
			
			f = [ext_dir, filesep, ext_main_name, '.m'];
			
		else
			
			% NOTE: this should provide some fun in the future
			
			info = functions(fun.(str)); f = info.file;
			
% 			f = [ext_dir, filesep, 'private', filesep, str, '.m'];
			
		end
		
		%--
		% execute command
		%--
		
		switch com
			
			case 'edit', edit(f);
		
			case 'diff', tsvn('diff', f);
		
		end

	%------------------------
	% API ADD
	%------------------------
	
	%--
	% add all
	%--
	
	% NOTE: order matters here in the switch
	
	case 'Add All ...'

		%--
		% generate remaining functions
		%--
		
		disp(' '); generate_function(ext); disp(' ');

		%--
		% update extensions
		%--
		
		get_extensions('!'); update_filter_menu;
		
		%--
		% update edit and add menus
		%--
		
		par = get_xbat_figs('child', pal); 
		
		if ~isempty(par)
			close(pal); extension_palettes(par, ext.name, ext.subtype); return;
		end
		
		pal_menu(pal, 'update_api', ext.subtype);
		
	%--
	% add
	%--
	
	% TODO: consider adding editing on single add
	
	case ADD_LIST
		
		%--
		% generate specific function
		%--
		
		generate_function(ext, str);

		%--
		% update extensions
		%--
		
		get_extensions('!'); update_filter_menu;
		
		%--
		% update edit and add menus
		%--
		
		par = get_xbat_figs('child', pal); 
		
		if ~isempty(par)
			close(pal); extension_palettes(par, ext.name, ext.subtype); return;
		end
						
		pal_menu(pal, 'update_api', ext.subtype);
		
	%--
	% api add helper
	%--
	
	case 'update_api'

		%--
		% delete and update edit, diff, and add items
		%--
		
		% EDIT
		% ----
		
		g = findobj(pal, 'tag', 'api edit');
		
		if ~isempty(g)

			delete(allchild(g));

			temp = menu_group(g, 'pal_menu', EDIT_LIST);

			if (length(temp) > 1)
				set(temp(2), 'separator', 'on');
			end

		end
		
		set(temp(end), 'separator', 'on');
		
		% DIFF
		% ----
		
		g = findobj(pal, 'tag', 'api diff');
		
		if ~isempty(g)

			delete(allchild(g));

			temp = menu_group(g, 'pal_menu', EDIT_LIST);

			if (length(temp) > 1)
				set(temp(2), 'separator', 'on');
			end

		end
		
		delete(temp(end)); % NOTE: discard edit all from diff children
		
		% ADD
		%----
		
		g = get_menu(pal, 'Add');

		if ~isempty(g)

			delete(allchild(g));

			if ~isempty(ADD_LIST)
				set(g, 'enable', 'on'); menu_group(g, 'pal_menu', ADD_LIST);
			else
				set(g, 'enable', 'off');
			end

		end

	%------------------------
	% HELPER EDIT AND DIFF
	%------------------------
	
	case HELPER_LIST
		
		%--
		% get command option
		%--
		
		[ignore, com] = parse_context(get(get(gcbo, 'parent'), 'tag'));

		%--
		% build full filename
		%--
				
		% NOTE: this will change when we allow other editable types
		
		f = [ext_dir, filesep, 'Helpers', filesep, str, '.m'];
		
		%--
		% execute command
		%--
		
		switch com
			
			case 'edit', edit(f);
				
			case 'diff', tsvn('diff', f);
		
		end
		
	%------------------------
	% ADD HELPER
	%------------------------
	
	%--
	% add helper
	%--
	
	case 'Add Helper ...'

		%--
		% create dialog controls
		%--
		
		% NOTE: the 'min' value makes this a non-collapsible header
		
		control(1) = control_create( ...
			'style', 'separator', ...
			'type', 'header', ...
			'min', 1, ...			
			'string', 'Helper', ...
			'space', 0.75 ...
		);

		% TODO: consider prefix for names
		
		control(end + 1) = control_create( ...
			'name', 'name', ...
			'alias', 'Name', ...
			'style', 'edit' ...
		);
		
		%--
		% create dialog and get values
		%--
		
		% TODO: implement validation as control callbacks for dialog
		
		% NOTE: validation callbacks can be executed prior to the formal button callback
		
		% NOTE: the ok button may only be available when the contents are right
		
		% NOTE: if any validation tests fail highlight controls in dialog
		
		out = dialog_group('Add Helper ...', control);
			
		if isempty(out.values)
			return;
		end
		
		values = out.values;
		
		%--
		% create helper file and open for editing
		%--
		
		try 
			
			f = [ext_dir, filesep, 'Helpers', filesep, values.name, '.m'];
			
			fid = fopen(f, 'w'); fprintf(fid, '%s', ['function ', values.name]); fclose(fid);
			
			edit(f);
			
		catch
			
			xml_disp(lasterror);
			
		end
				
		%--
		% update menus
		%--
		
		pal_menu(pal, 'update_helper_edit', ext.subtype);
	
	%--
	% add helper helper
	%--
	
	case 'update_helper_edit'

		%--
		% update edit and diff children
		%--
		
		% EDIT
		%-----
		
		g = findobj(pal, 'tag', 'helper edit');
		
		if ~isempty(g)
			
			delete(allchild(g));
			
			set(g, 'enable', 'on');
			
			temp = menu_group(g, 'pal_menu', HELPER_LIST); 

			if length(temp) > 2
				set(temp(end), 'separator', 'on');
			end
			
		end	
		
		% DIFF
		%-----
		
		g = findobj(pal, 'tag', 'helper diff');
		
		if ~isempty(g)
			
			delete(allchild(g));

			set(g, 'enable', 'on');
			
			temp = menu_group(g, 'pal_menu', HELPER_LIST); 

			if length(temp) > 2
				set(temp(end), 'separator', 'on');
			end
			
		end	
		
		% TODO: handle edit all ...
		
	%------------------------
	% MLINT
	%------------------------
		
	case 'M-Lint ...'
		
		%--
		% get context from menu tag
		%--
		
		con = parse_context(get(gcbo, 'tag'));

		%--
		% build path 
		%--
		
		p = extension_root(ext);
		
		switch con
			
			case 'api', p = [p, filesep, 'private'];
				
			case 'helper', p = [p, filesep, 'Helpers'];
				
		end
		
		%--
		% produce lint report
		%--
			
		mlintrpt(p, 'dir');
	
	%-----------------------------------------------------------
	% SVN COMMANDS
	%-----------------------------------------------------------
	
	%--
	% update extension directory
	%--
	
	case 'Update ...', tsvn('update', ext_dir);
	
	%--
	% status of extension directory
	%--
	
	case 'Status ...', tsvn('status', ext_dir);
	
	%--
	% commit extension directory
	%--
	
	case 'Commit ...', tsvn('commit', ext_dir);

	case 'Add ...', tsvn('add', ext_dir);
		
	%--
	% about tortoise
	%--
	
	case 'About TSVN ...', tsvn('about');
		
end


%-------------------------------------------
% PARSE_CONTEXT
%-------------------------------------------

function [con, com] = parse_context(tag)

% parse_context - get context and command from menu tag
% -----------------------------------------------------
%
% [con, com] = parse_context(tag)
%
% Input:
% ------
%  tag - menu tag
%
% Output:
% -------
%  con - context
%  com - command

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

%--
% parse string
%--

% NOTE: tags are of the form 'context command' we only need to split

out = str_split(tag);

%--
% output context and command if needed
%--

con = out{1};

if (nargout > 1)
	if (length(out) > 1)
		com = out{2};
	else
		com = '';
	end
end
