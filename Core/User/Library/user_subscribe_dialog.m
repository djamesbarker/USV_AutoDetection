function result = user_subscribe_dialog(user)

% user_subscribe_dialog - get library to which to subscribe
% ---------------------------------------------------------
% result = user_subscribe_dialog
%
% Input:
% ------
%  user - user to subsribe
% 
% output:
% -------
%  result - dialog group output

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
% handle input
%--

if nargin < 1 || isempty(user)
	user = get_active_user;
end

%--
% create controls
%--

name = 'Add ...';

control(1) = control_create( ...
	'style','separator', ...
	'type','header', ...
	'space', 0.75, ...
	'min',1, ...
	'string',['Library  (', user.name, ')'] ...
);

control(end + 1) = control_create( ...
	'style', 'edit', ...
	'name', 'find_libraries', ...
	'alias', 'search', ...
	'onload', 1 ...
);

%--
% get library name list
%--

names = library_name_list(get_users, 'full');

%--
% library listbox
%--

control(end + 1) = control_create( ...
	'style', 'listbox', ...
	'name', 'Libraries', ...
	'lines', 3, ...
	'min', 0, ...
	'max', 2, ...
	'string', names, ...
	'value', 1, ...
	'space', 0.75 ...
);

%--
% add new library (+) button
%--

control(end + 1) = control_create( ...
	'style', 'buttongroup', ...
	'name', 'locate_library', ...
	'alias','Find ...', ...
	'align', 'right', ...
	'lines', 1.75, ...
	'space', -0.25, ...
	'width', 1/3 ...
);

%----------------------------
% Library Info
%----------------------------

%--
% info box
%--

control(end + 1) = control_create( ...
	'name', 'library_info', ...
	'alias', 'info', ...
	'style', 'listbox', ...
	'space', 1.25, ... 
	'min', 0, ...
	'max', 2, ...
	'lines', 3 ...
);

%--
% create dialog group
%--

opt = dialog_group;	

opt.width = 12; opt.top = 1; opt.bottom = 0;

opt.header_color = get_extension_color('root');

opt.text_menu = 1;

result = dialog_group(name, control, opt, {@user_subscribe_callback, user});

%---------------------------------
% SUBSCRIBE USER
%---------------------------------

% NOTE: return empty on cancel

if isempty(result.values)
	return;
end

%--
% subscribe to all libraries
%--

for k = 1:length(result.values.Libraries)
	
	%--
	% get library from value
	%--

	lib = get_user_library(result.values.Libraries{k});
	
	if isempty(lib)
		continue;
	end
	
	%--
	% subscribe the user to the library
	%--
	
	user = user_subscribe(lib, user);

end


%-----------------------------------------
% CALLBACK FUNCTION
%-----------------------------------------

function result = user_subscribe_callback(obj, eventdata, user) 

%--
% get callback context
%--

result = [];

[control,pal] = get_callback_context(obj); 

%--
% select operation by control name
%--

switch (control.name)
	
	%--
	% find libraries
	%--
	
	case ('find_libraries')
		
		%--
		% filter complete name list by search string
		%--
		
		handles = get_control(pal.handle, 'Libraries', 'handles');
		
		set(handles.obj, 'string', library_name_list(get_users, 'full'));
		
		listbox_search(pal.handle, 'library');
		
			
	%--
	% select library
	%--
	
	case ('Libraries')
		
		%--
		% get library info string
		%--
		
		libname = get_control(pal.handle, control.name, 'value');
		
		str = library_info_str(get_library_from_name(libname));

		%--
		% put info string in info box
		%--
		
		handles = get_control(pal.handle, 'library_info', 'handles');
		
		set(handles.uicontrol.listbox, 'string', str, 'value', [], 'enable', 'on');

	%--
	% locate library
	%--
		
	case ('locate_library')
		
		%--
		% look for library starting in this user's root
		%--
		
		di = pwd; cd(user_root(user, 'lib'));
		
		[lib_file, lib_path] = uigetfile2({'*.mat', 'MAT-files (*.mat)'},'Please select an existing library file.');
		
		cd(di);

		if isnumeric(lib_file) || ~is_library(lib_path, lib_file) 
			return;
		end
		
		%--
		% get library
		%--
			
		lib = load_library(fullfile(lib_path, lib_file));
		
		%--
		% subscribe user to library if needed
		%--
		
		user_subscribe(lib, user);
		
		%--
		% delete subscription dialog
		%--
		
		close(pal.handle);
				
end


%-------------------------------------------
% IS_LIBRARY
%-------------------------------------------

function out = is_library(path, file)

out = 0;

fullfile = [path, file];

contents = load(fullfile, 'lib');

if ~isfield(contents, 'lib')
	return
end

lib = contents.lib;

if ~isequal(fieldnames(library_create), fieldnames(lib));
	return
end

out = 1;



