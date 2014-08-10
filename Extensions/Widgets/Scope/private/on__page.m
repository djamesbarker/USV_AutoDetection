function [handles, context] = on__page(widget, data, parameter, context)

% SCOPE - on__page

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

% NOTE: we consider this event because scope may adapt to page

%--
% check for existing marker
%--

marker = []; % get_browser_marker(context.par);

if isempty(marker) || isempty(marker.time)
	handles = []; return;
end

%--
% add marker to data and set marker
%--

% NOTE: the marker is not currently included in the basic widget data

data.marker = marker;

handles = on__marker__create(widget, data, parameter, context);
