function update = splash_wait_update(pal, message, value)

% splash_wait_update - update splash waitbar
% ------------------------------------------
%
% update = splash_wait_update(pal, message, value);
%
% Input:
% ------
%  pal - splash handle
%  message - message
%  value - value

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

%------------------
% HANDLE INPUT
%------------------

% NOTE: return if there is nothing to set

if nargin < 2
	return;
end

% NOTE: this is convenient, so we can ask update in a single line

if isempty(pal) || ~ishandle(pal)
	return;
end 

%--
% get value from tick
%--

if nargin < 3
	value = get_tick_value(pal);
end

%------------------
% SET WAITBAR
%------------------

update = 1;

if ischar(message)
	update = waitbar_update(pal, 'PROGRESS', 'message', upper(message)); % pause(0.05);
end 

if update
	update = waitbar_update(pal, 'PROGRESS', 'value', value);
end


%--------------------------------
% GET_TICK_VALUE
%--------------------------------

function value = get_tick_value(pal)

% get_tick_value - get value from waitbar tick
% --------------------------------------------
%
% value = get_tick_value(pal) 
%
% Input:
% ------
%  pal - splash handle
%
% Output:
% -------
%  value - waitbar value

data = get(pal, 'userdata');

tick = data.tick;

% NOTE: this incremente the tick position value to the end of the tick sequence

value = tick.value(tick.pos); tick.pos = min(tick.pos + 1, length(tick.value));

data.tick = tick; set(pal, 'userdata', data);

