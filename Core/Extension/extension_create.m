function ext = extension_create(fun)

% extension_create - create extension
% -----------------------------------
% 
% ext = extension_create(fun)
%
%
% Input:
% ------
%  fun - extension function
%
% Output:
% -------
%  ext - extension

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

%--------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------

%--
% set empty extension function
%--

% NOTE: the 'get_caller' function will try to discover this

if (nargin < 1)
	fun = '';
end
	
%--------------------------------------------------
% GET EXTENSION INFO
%--------------------------------------------------

%--
% check whether input is proposed extension or extension type
%--

if ~is_extension_type(fun)
	caller = get_caller(fun);
else
	caller = [];
end 
	
%--
% get basic extension info
%--

if ~isempty(caller)
	
	% NOTE: 'get' functions are private because of the fragility of stack use
	
	type = get_type(caller);
	
	name = get_name(caller);
	
	info = get_info(caller); modified = info.date;
	
	main = get_main(caller);

else
	
	% NOTE: this allows testing from command line
	
	type = fun; 
	
	name = '';
	
	modified = datestr(now); 
	
	main = [];
	
end
	
%--
% check extension type
%--

% NOTE: return empty for unrecognized type

if ~is_extension_type(type)
	ext = [];  return;
end

%--------------------------------------------------
% CREATE EXTENSION
%--------------------------------------------------

%--------------------------------
% ADMIN AUTO
%--------------------------------

% TODO: get rid of this stupid type field and rename 'subtype' as 'type

ext.type = 'extension';

ext.subtype = type;			% actual type of extension (available types above)

ext.name = name; 			% name of extension

ext.modified = modified; 	% release date of current version

ext.parent = [];

%--------------------------------
% ADMIN USER
%--------------------------------

ext.version = '';			% version string for extension

ext.short_description = '';	% short description of extension

ext.category = {};			% extension category (used in the production of menus)

ext.author = '';			% author of extension

ext.email = '';

ext.url = '';

ext.enable = 1;				% enable extension in interface

% TODO: develop allowed modes, perhaps 'user', 'developer', 'simple', 'advanced'

ext.mode = 'simple';

%--------------------------------
% FUNCTION HANDLES
%--------------------------------

% NOTE: we get type specific handles from the type description

if ~isempty(main)
	
	ext.fun = attach_fun(main, type); 
	
	ext.fun.main = main;
	
else
	
	ext.fun = feval(type);
	
	ext.fun.main = [];
	
end

%--------------------------------
% STORES
%--------------------------------
	
ext.parameter = struct; % NOTE: keep parameter values when a palette is closed

ext.value = struct;

ext.control = struct; % NOTE: keep control values when a palette is closed

%--------------------------------
% SYSTEM (we just don't know what these are yet)
%--------------------------------

ext.multichannel = 0;

ext.fade = 1;

%--
% required 
%--

% NOTE: declare required sound metadata	

ext.required.sound = []; 

% NOTE: retrieve availability information using 'ver' function 

ext.required.toolbox = cell(0);

%--
% behaviors
%--

% NOTE: these are not thoroughly implemented

% NOTE: extension can be made active

if findstr(type, 'action')
	ext.active = 0;
else
	ext.active = 1; 
end

% NOTE: extension can be paused an restarted

ext.restart = 0; 	

%--
% other
%--

% NOTE: these are type dependent at the moment

ext.estimate = 1; % NOTE: indicate whether filter output is a signal estimate

ext.waitbar = 1; % NOTE: use waitbar for array actions

%--
% interface configuration
%--

% NOTE: it is possible that we can use typical palette extensions in dialog mode

ext.palette.opt = control_group;

ext.dialog.opt = dialog_group;

%--------------------------------
% USERDATA FIELDS
%--------------------------------

ext.userdata = [];
