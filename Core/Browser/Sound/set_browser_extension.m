function set_browser_extension(par, ext)

% TODO: this is currently used as the load preset function, it loads too much!

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

% NOTE: create a true load preset function that merges the relevant
% contents of the preset with the current browser extension

%-------------------------
% UPDATE STATE
%-------------------------

%--
% get current extension and index
%--

data = get_browser(par);

[current, ix, context] = get_browser_extension(ext.subtype, par, ext.name, data);

%--
% update browser state
%--

% NOTE: this will typically be preset.ext

data.browser.(current.subtype).ext(ix) = ext;

set(par, 'userdata', data);

%-------------------------
% REFLECT STATE
%-------------------------

%--
% check for palette to update
%--

pal = get_palette(par, ext.name, data);

if isempty(pal)
	return;
end

%--
% check for controls
%--

ext_controls = empty(control_create);
	
if ~isempty(ext.fun.parameter.control.create)

	try
		ext_controls = ext.fun.parameter.control.create(ext.parameter, context);
	catch
		extension_warning(ext, 'Parameter control creation failed.', lasterror);
	end

end

% NOTE: there are no controls to update

if isempty(ext_controls) 
	return;
end 

%--
% update controls and make display consistent
%--

% NOTE: this relies on parameter compilation not clobbering controlled parameter values

set_control_values(pal, ext.parameter);

% NOTE: the onload callback ensures consistent display

palette_onload(pal, ext_controls);


%-------------------------
% PALETTE_ON_LOAD
%-------------------------

function palette_onload(pal, ext_controls)

% TODO: order 'onload' callbacks by making value a position

%--
% check for controls
%--

if (nargin < 2) || isempty(ext_controls)
	return;
end

%--
% check for onload
%--

onload = [ext_controls.onload];

if ~any(onload)
	return;
end

%--
% perform onload callbacks
%--

for k = 1:length(onload)
	if onload(k)
		control_callback([], pal, ext_controls(k).name);
	end
end


