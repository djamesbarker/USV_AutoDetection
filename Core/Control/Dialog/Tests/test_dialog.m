function out = test_dialog

% test_dialog - simple test function for 'dialog_group'
% -----------------------------------------------------
%
% out = test_dialog
%
% Output:
% -------
%  out - output from dialog

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
% $Revision: 1880 $
% $Date: 2005-09-29 17:29:36 -0400 (Thu, 29 Sep 2005) $
%--------------------------------

% TODO: add buttons that generate another modal dialog

% NOTE: consider storing the results of the nested dialog in the button

%----------------------------------------
% TEST_DIALOG
%----------------------------------------

%--
% create header separator
%--

name = 'TEST HEADER';

control(1) = control_create( ...
	'style','separator', ...
	'type','header', ...
	'min',1, ...
	'string',name ...
);

%--
% create slider controls
%--

n = 6;

for k = 1:n
	
	name = ['slider_', int2str(k)];
	
	% TODO: consider making this alias behavior the default behavior
	
	control(end + 1) = control_create( ...
		'name',name, ...
		'alias',title_caps(name,'_'), ...
		'style','slider', ...
		'slider_inc', [1,2], ...
		'min',1, ...
		'max',2^n, ...
		'value',2^k ...
	);

end

%--
% create dialog
%--

out = dialog_group('TEST DIALOG',control,[],@test_dialog_callback);

% NOTE: display output if none was requested

if (~nargout)
	xml_disp(out);
end


%----------------------------------------
% TEST_DIALOG_CALLBACK
%----------------------------------------

function test_dialog_callback(obj,eventdata)

%--
% get callback context
%--

context = get_callback_context(obj,'pack');

% xml_disp(context);

%--
% switch on control
%--

switch (context.control.name) 
	
	otherwise
		
		slider_sync(obj,context.control.handles);
		
		%--
		% apply validation rules
		%--
		
		[ignore,value] = control_update([],context.pal.handle,context.control.name);
		
		% NOTE: enforce valid value
		
		validated = round(value);
				
		if (value ~= validated)
			flag = 1; control_update([],context.pal.handle,context.control.name,validated);
		end
		
end

