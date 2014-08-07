function out = file_dialog(type, file)

% file_dialog - file selection dialog
% -----------------------------------
%
% out = file_dialog(type, file)
%
% Input:
% ------
%  type - type of dialog
%  file - file
%
% Output:
% -------
%  out - dialog output structure

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
% $Revision: 1938 $
% $Date: 2005-10-17 08:49:40 -0400 (Mon, 17 Oct 2005) $
%--------------------------------

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set default type
%--

if (nargin < 1) || isempty(type)
	type = 'dir';
end

%--
% set default file
%--

% NOTE: consider default for 'file' and 'dir' types

if (nargin < 2) || isempty(file)
	file = pwd;
end

%----------------------------------
% CREATE CONTROLS
%----------------------------------

control = empty(control_create);

%--
% dialog header
%--

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'min', 1, ...
	'string', 'File' ...
);


names = {'red', 'green', 'blue'};

for k = 1:length(names)
	
	control(end + 1) = control_create( ...
		'name',names{k}, ...
		'style','slider', ...
		'min',0, ...
		'max',1, ...
		'value',color(k) ...
	);

end

%--
% file control
%--

% NOTE: the number of lines along with the dialog group options produce a square

control(end + 1) = control_create( ...
	'name', 'file', ...
	'style', 'file', ...
	'value', file, ...
	'space', 1.5, ...
	'lines', 4 ...
);

%----------------------------------
% CREATE DIALOG
%----------------------------------

%--
% configure dialog options
%--

opt = dialog_group;

opt.width = 12;

%--
% create dialog
%--

out = dialog_group('File Dialog', control, opt, @dialog_callback);


%----------------------------------
% DIALOG_CALLBACK
%----------------------------------

function result = dialog_callback(obj, eventdata)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1938 $
% $Date: 2005-10-17 08:49:40 -0400 (Mon, 17 Oct 2005) $
%--------------------------------

result = [];

[control, par] = get_callback_context(obj) 

switch control.name
	
	otherwise
		
		values = get_control_values(par.handle)
		
		
% 		%--
% 		% update color display
% 		%--
% 		
% 		values = get_control_values(par.handle);
% 		
% 		color = values_to_color(values);
% 		
% 		color_display(par.handle, color);
% 		
% 		%--
% 		% store color in color display axes control
% 		%--
% 		
% 		control_update([], par.handle, 'color', color);
		
end





