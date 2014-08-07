function controls = get_palette_headers(pal)

% get_palette_headers - get palette header handles
% ------------------------------------------------
%
% header = get_palette_headers(pal)
%
% Input:
% ------
%  pal - palette handle

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


if ~is_palette(pal)
	error('Input handle is not palette handle.');
end

if nargin < 2
	name = ''; 
end

toggle = findobj(pal, 'tag', 'header_toggle');

if isempty(toggle)
	control = []; return;
end

controls = [];

for k = 1:length(toggle)
	
	control.label = '';
	
	control.handles.axes = get(toggle(k), 'parent');
	
	control.handles.toggle = toggle(k);
	
	control.handles.label = findobj(control.handles.axes, 'tag', 'header_text');
	
	if ~isempty(control.handles.label)
		control.label = get(control.handles.label, 'string');
	end
	
	if isempty(controls)
		controls = control; 
	else
		controls(end + 1) = control;
	end
	
end
