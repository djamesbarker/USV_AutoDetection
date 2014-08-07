function time_slider_callback(obj, eventdata, par, state)

% NOTE: we are thinking that 'set_time_slider' will call this fucntion
% programatically and that the time slider will of course have it as its
% callback

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
% initialize persistent slider state
%--

persistent SLIDER_STATE;

if isempty(SLIDER_STATE)
	SLIDER_STATE = 0;
end

if nargin > 3
	SLIDER_STATE = state;
end

%--
% update slider state and possibly refresh
%--

current = get(obj, 'value'); previous = get_browser_history(par, 'time');

if current == previous
	SLIDER_STATE = 0; return;
end

% NOTE: it seems like this should talk to the daemon and let it do the
% actual refreshing?

if SLIDER_STATE
	browser_refresh(par);
end

SLIDER_STATE = ~SLIDER_STATE;

