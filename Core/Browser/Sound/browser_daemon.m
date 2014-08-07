function daemon = browser_daemon

% browser_daemon - create a timer object to handle browser state saves
% --------------------------------------------------------------------
%
% daemon = browser_daemon
%
% Output:
% -------
%  daemon - timer object

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
% $Revision: 2202 $
% $Date: 2005-12-06 08:24:51 -0500 (Tue, 06 Dec 2005) $
%--------------------------------

%--
% look for timer
%--

daemon = timerfind('name','XBAT Browser Daemon');

%--
% create and configure timer if needed
%--

if (isempty(daemon))

	daemon = timer;

	set(daemon, ...
		'name','XBAT Browser Daemon', ...
		'timerfcn',@save_browsers_state, ...
		'executionmode','fixedRate', ...
		'period',120 ...
	);

end


%---------------------------------------------------
% SAVE_BROWSER_STATE
%---------------------------------------------------

function save_browsers_state(obj,evendata)

% save_browsers_state - timer callback to save browsers state
% -----------------------------------------------------------

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2202 $
% $Date: 2005-12-06 08:24:51 -0500 (Tue, 06 Dec 2005) $
%--------------------------------

%--
% get sound browser figures
%--

h = get_xbat_figs('type','sound');

%--
% save sound browser states
%--

for k = 1:length(h)
	
	% NOTE: this exception is encountered when a figure is deleted before save

	try
		browser_sound_save(h(k));
	end
	
end
