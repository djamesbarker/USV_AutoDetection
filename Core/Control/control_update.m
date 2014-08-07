function [handles, value] = control_update(par, pal, name, value, data)

% control_update - update control in palette
% ------------------------------------------
%
% [handles, value] = control_update(par, pal, name, value, data)
%
% Input:
% ------
%  par - parent handle
%  pal - palette handle
%  name - control name
%  value - set value
%  data - parent data
%
% Output:
% -------
%  handles - control handles
%  value - control value

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
% $Revision: 4466 $
% $Date: 2006-04-04 11:36:42 -0400 (Tue, 04 Apr 2006) $
%--------------------------------

% NOTE: this function exists for backward compatibility

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% get palette from name
%--

% NOTE: consider palettes with and without parent

if (isempty(par) || (par == 0))

	if (ischar(pal))
		pal = findobj(get(0, 'children'), 'flat', 'name', pal);
	end

else
	
	if ((nargin < 5) || isempty(data))
		data = get(par, 'userdata');
	end
	
	pal = get_palette(par, pal, data);
	
end

% NOTE: return quickly if we can't get palette

if (isempty(pal))
	handles = []; value = []; return;
end

%--
% check palette handle
%--

if (~is_palette(pal))
	error('Handle is not a palette handle.');
end

%---------------------------------------------
% PERFORM UPDATE
%---------------------------------------------

%--
% get handles
%--

% NOTE: this is largely for backward compatibility

handles = get_control(pal, name, 'handles');

if (~isempty(handles))
	handles = handles.all;
end

% NOTE: handle output and get update rely on inputs and outputs in call

if ((nargin < 4) || isempty(value))

	%--
	% GET HANDLES UPDATE
	%--

	if (nargout < 2)
		return;
	end
	
	%--
	% GET VALUE UPDATE
	%--
	
	value = get_control(pal, name, 'value'); return;
	
end

%--
% COMMAND UPDATE
%--

if (is_control_command(value))
	
	set_control(pal, name, 'command', value); return;

end

%--
% SET VALUE UPDATE
%--

control = set_control(pal, name, 'value', value);

% NOTE: this hides missing controls, add a developer message

if (~isempty(control))
	value = control.value;
else
	value = [];
end
