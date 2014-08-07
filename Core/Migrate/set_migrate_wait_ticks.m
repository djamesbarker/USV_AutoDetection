function set_migrate_wait_ticks(ticks)

% set_migrate_wait_ticks - set the total number of ticks
% ------------------------------------------------------
%
% set_migrate_wait_ticks(ticks)

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

%--
% get palette
%--

pal = migrate_wait;

%--
% get PROGRESS userdata
%--

if isempty(pal)
	return;
end

handles = get_control(pal, 'PROGRESS', 'handles');

data = get(handles.axes, 'userdata');

%--
% return if the number of ticks has already been set
%--

if isfield(data, 'ticks') && data.ticks > 0
	return;
end

%--
% set the number of ticks
%--

data.ticks = ticks; data.tick = 0;

set(handles.axes, 'userdata', data);
