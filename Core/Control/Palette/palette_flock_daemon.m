function daemon = palette_flock_daemon

% palette_flock_daemon - create a timer to handle palette flocking
% ----------------------------------------------------------------
%
% daemon = palette_flock_daemon
%
% Output:
% -------
%  daemon - timer object
%
% THIS IS NOT READY FOR USERS !!!

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
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%--
% create timer object
%--

daemon = timer;

%--
% configure timer object
%--

set(daemon, ...
	'name','XBAT Palette Flock Daemon', ...
	'timerfcn',@update_flock_state, ...
	'executionmode','fixedRate', ...
	'period',0.1 ...
);

%---------------------------------------------------
% UPDATE_PALETTE_DISPLAY
%---------------------------------------------------

function update_flock_state(obj,evendata)

% update_flock_state - timer callback to update palette display
% -------------------------------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%--
% get flock daemon and update the userdata
%--

tmp = timerfind('name','XBAT Palette Flock Daemon');

if (~isempty(tmp))
	set(tmp,'userdata',0);
end
