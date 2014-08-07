function pal = delete_palette(par, str)

% delete_palette - delete palette from screen and parent
% ------------------------------------------------------
%
% pal = delete_palette(par, str)
%
% Input:
% ------
%  par - parent handle
%  str - palette name
%
% Output:
% -------
%  pal - palette handle (no longer a handle)

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

% NOTE: this function does a lot more than just close the palette figure

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% get parent userdata
%--

data = get(par, 'userdata');

%--
% try to get palette handle
%--

pal = get_palette(par, str, data);

if isempty(pal)
	return;
end

%-------------------------------------------------------------
% PERFORM EXTENSION UPDATES
%-------------------------------------------------------------

%--
% check if this is an extension palette
%--

% NOTE: the extension returned here, if any does not contain current state

[test, ext] = is_extension_palette(pal);

%--
% update browser extension state
%--

if test
	
	[ext, eix] = get_browser_extension(ext.subtype, par, ext.name, data);

	if ~isempty(eix)
		data.browser.(ext.subtype).ext(eix) = ext;
	end

end

%-------------------------------------------------------------
% STORE PALETTE STATE
%-------------------------------------------------------------

%--
% get palette state
%--

% NOTE: the palette state includes: position, toggle, and tab selection states

state = get_palette_state(pal);

%--
% append or update palette state registry
%--

if isempty(data.browser.palette_states)
	
	data.browser.palette_states = state;
	
else
	
	names = struct_field(data.browser.palette_states, 'name');
	
	ix = find(strcmp(state.name, names));
	
	% NOTE: this clears the state store of old strutures
	
	try
		if ~isempty(ix)
			data.browser.palette_states(ix) = state;
		else
			data.browser.palette_states(end + 1) = state;
		end
	catch
		data.browser.palette_states = state;
	end
	
end

%-------------------------------------------------------------
% UNREGISTER WITH PARENT AND DELETE
%-------------------------------------------------------------

% TODO: registering and unregistering need to be encapsulated

%--
% remove palette handle from list and update userdata
%--

ix = find(data.browser.palettes == pal);

data.browser.palettes(ix) = [];

set(par, 'userdata', data);

%--
% close palette figure
%--

closereq;
