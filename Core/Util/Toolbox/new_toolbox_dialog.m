function toolbox = new_toolbox_dialog(toolbox)

% new_toolbox_dialog - dialog to create new toolbox description
% -------------------------------------------------------------
%
% toolbox = new_toolbox_dialog(toolbox)
%
% Input:
% ------
%  toolbox - toolbox
%
% Output:
% -------
%  toolbox - new toolbox created

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

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set new toolbox state
%--

new = ~nargin;

%--
% get toolbox data from name
%--

if nargin && ischar(toolbox)
	
	name = toolbox; toolbox = get_toolbox_data(name);
	
	if isempty(toolbox)
		return; % new_toolbox_dialog;
	end
	
end

%----------------------------------
% CREATE CONTROLS
%----------------------------------

control = empty(control_create);

%-----------------
% INFO
%-----------------

if ~new
	str = ['Toolbox  (', toolbox.name, ')'];
else
	str = 'Toolbox';
end

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'space', .1, ...
	'string', str ...
);

tabs = {'Basic'};

control(end + 1) = control_create( ...
	'style','tabs', ...
	'tab',tabs ...
);

control(end + 1) = control_create( ...
	'name', 'name', ...
	'space', 1, ...
	'onload', 1, ...
	'space', 0.75, ...
	'style', 'edit', ...
	'tab', tabs{1}, ...
	'type', 'filename' ...
);

% NOTE: a toolbox description cannot be renamed

if ~new
	control(end).string = toolbox.name; control(end).initialstate = '__DISABLE__';
end

%--
% home
%--

% TODO: extend this to have both a home, and a download url

control(end + 1) = control_create( ...
	'name', 'home', ...
	'space', 0.75, ...
	'tab', tabs{1}, ...
	'style', 'edit' ...
);

if ~new && isfield(toolbox, 'home')
	control(end).string = toolbox.home;
end

%--
% url
%--

% TODO: extend this to have both a home, and a download url

control(end + 1) = control_create( ...
	'name', 'url', ...
	'alias', 'URL', ...
	'space', 0.75, ...
	'tab', tabs{1}, ...
	'style', 'edit' ...
);

if ~new
	control(end).string = toolbox.url;
end

control(end).space = 1.5;

%----------------------------------
% CREATE DIALOG
%----------------------------------

%--
% configure dialog options
%--

opt = dialog_group; opt.width = 16;

opt.header_color = get_extension_color('root');

opt.text_menu = 1;

%--
% create dialog
%--

if new
	name = 'New ...';
else 
	name = 'Edit ...';
end

try
	out = dialog_group(name, control, opt, @new_toolbox_callback);
catch
	out.values = []; nice_catch(lasterror);
end

% NOTE: return empty on cancel

if isempty(out.values)
	toolbox = []; return;
end

%--
% add toolbox
%--

toolbox = add_toolbox(out.values);


%----------------------------------
% NEW_USER_CALLBACK
%----------------------------------

function new_toolbox_callback(obj, eventdata) %#ok<INUSD>

%--
% get callback context
%--

[control, pal] = get_callback_context(obj);

%--
% process callback request
%--

switch control.name

	case 'name'
		
		set_control(pal.handle, 'OK', 'enable', proper_filename(get(obj, 'string')));
			
end


%----------------------------------
% ADD_TOOLBOX
%----------------------------------

function toolbox = add_toolbox(toolbox)

%--
% create data root
%--

root = create_dir(toolbox_data_root(toolbox.name));

if isempty(root)
	error(['Unable to create toolbox data root for ''', toolbox.name, '''.']);
end

%--
% create file
%--

file = toolbox_data_file(toolbox.name);

[ignore, name, ignore] = fileparts(file);

fid = fopen(file, 'wt');

fprintf(fid, 'function toolbox = %s\n\n', name);

block_comment(fid, 'DATA');

fields = fieldnames(toolbox);

% NOTE: this code currently assumes all field values are strings

for k = 1:length(fields)
	fprintf(fid, 'toolbox.%s = ''%s'';\n\n', fields{k}, toolbox.(fields{k}));
end

fprintf(fid, 'toolbox.install = @install;\n\n');

block_comment(fid, 'INSTALL');

fprintf(fid, 'function install\n\n');

fclose(fid);

%--
% get toolbox data
%--

toolbox = get_toolbox_data(toolbox.name);


%----------------------------------
% BLOCK_COMMENT
%----------------------------------

function block_comment(fid, comment)

fprintf(fid, '%%------------------------\n');
fprintf(fid, '%% %s\n', comment);
fprintf(fid, '%%------------------------\n\n');


