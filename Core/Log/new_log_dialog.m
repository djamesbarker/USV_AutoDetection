function log = new_log_dialog(user, sound, type)

% new_log_dialog - dialog to create new logs
% ------------------------------------------
%
% log = new_log_dialog(user, sound)
%
% Input:
% ------
%  user - the user to which to attribute the log
%  sound - the sound to attach the log to
%
% Output:
% -------
%  log - new log

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
% Author: Matt Robbins
%--------------------------------
% $Revision$
% $Date$
%--------------------------------

%-----------------------
% HANDLE INPUT
%-----------------------

log = [];

%--
% get user, library, and sound information
%--

if nargin < 1 || isempty(user)
	user = get_active_user;
end

if nargin < 2 || isempty(sound)
	[sound, lib] = get_active_sound;
end

if nargin < 3
	type = 'sound_browser_palette';
end

if ~is_extension_type(type) && ~strcmp(type, 'root')
	error('Unrecognized extension type input.');
end

%--
% if there's no sound, we can't do anything
%--

if isempty(sound)
	return;
end

%----------------------------------
% CREATE CONTROLS
%----------------------------------

control = empty(control_create);

%-----------------
% INFO
%-----------------

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', ['Log  (', sound_name(sound), ')'] ...
);

%--
% name
%--

control(end + 1) = control_create( ...
	'name', 'name', ...
	'space', 1, ...
	'style', 'edit' ...
);

%----------------------------------
% CREATE DIALOG
%----------------------------------

%--
% configure dialog options
%--

opt = dialog_group;

opt.width = 12;

% NOTE: consider using different color depending on where we are called from

opt.header_color = get_extension_color(type);

opt.text_menu = 1;

name = 'New ...';

%--
% create dialog
%--

out = dialog_group(name, control, opt, @new_log_callback);

if strcmpi(out.action, 'cancel')
	return;
end

%--
% create and optionally open new log
%--

log = new_log(out.values.name, user, lib, sound);


%---------------------------------------------------
% NEW LOG CALLBACK
%---------------------------------------------------

function result = new_log_callback(obj, eventdata)

%--
% get callback context and control value
%--

[control, par] = get_callback_context(obj);

%--
% switch callback on control name
%--

switch control.name
	
	case 'name'
		
		%--
		% check name is a proper name
		%--
		
		value = get_control(par.handle, control.name, 'value');
		
		if ~proper_filename(value)
			
			warn_dialog({'User name must be ', 'a proper file name.'}, 'Invalid Log Name'); 
			set_control(par.handle,control.name, 'value', '');
		
		end
		
end




