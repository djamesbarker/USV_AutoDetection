function slider = get_time_slider(par)

% get_time_slider - get browser time slider
% -----------------------------------------
%
% slider = get_time_slider(par)
%
% Input:
% ------
%  par - parent browser
%
% Output:
% -------
%  slider - browser time slider

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
% $Date: 2005-08-25 10:08:40 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1658 $
%--------------------------------

%--
% get browser time slider
%--

handle = findobj(get(par, 'children'), 'tag', 'BROWSER_TIME_SLIDER');

if isempty(handle)
	slider = []; return;
end

%--
% get control time slider
%--

[control, handles] = get_navigate_time_slider(par);

if ~isempty(control)
	handle(end + 1) = control;
end

%--
% get relevant slider values and pack into struct
%--

slider.handle = handle;

% NOTE: for get operations we use a single handle, we for set all

slider.min = get(handle(1), 'min'); 

slider.value = get(handle(1), 'value');

% NOTE: this should happen when we are moving the navigate time control

if ~isempty(control) && ~isempty(gcbo) && ismember(gcbo, handles.all)
	
	slider.value = get(control, 'value'); set(handle(1), 'value', slider.value);
	
end

slider.max = get(handle(1), 'max');

% NOTE: these are custom stored slider properties

%--
% get time slider field values
%--

% first create empty fields

fields = get_time_slider_fields; 

for k = 1:length(fields)
	slider.(fields{k}) = [];
end

% NOTE: ensure non-empty previous value

slider.previous_value = slider.value;

% get data store from slider

data = get(handle(1), 'userdata');

if isempty(data) || ~isstruct(data)
	return;
end

% get time slider fields from data store

% NOTE: consider using 'struct_update'
	
for k = 1:length(fields)
	
	if isfield(data, fields{k})
		slider.(fields{k}) = data.(fields{k});
	end
	
end 


%-----------------------------------------------
% GET_NAVIGATE_TIME_SLIDER
%-----------------------------------------------

function [slider, handles] = get_navigate_time_slider(par)

% NOTE: this is to get the parent navigate slider quickly

slider = []; handles = [];

% pal = findobj(0, 'tag', 'XBAT_PALETTE::CORE::Navigate', 'visible', 'on');

% NOTE: this find seems slightly faster than the above

pal = findobj(0, 'type','figure', 'name', 'Navigate', 'visible', 'on');

if isempty(pal)
	return;
end

for k = 1:numel(pal)
	
	if par == get_palette_parent(pal(k))
		handles = get_control(pal(k), 'Time', 'handles'); slider = handles.obj; break;
	end

end
