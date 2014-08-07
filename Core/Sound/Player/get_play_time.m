function time = get_play_time(par)

% get_play_time - get current play time from play display
% -------------------------------------------------------
%
% time = get_play_time(par)
%
% Input:
% ------
%  par - player display parent
%
% Output:
% -------
%  time - current play time

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
% find play time within parent
%--

play_line = findobj(par, 'type', 'line', 'tag', 'PLAY_DISPLAY');

% NOTE: return empty if there is no display

if isempty(play_line)
	time = []; return;
end

%--
% get time from display position
%--

% NOTE: there may be multiple lines, the should have the same time

time = get(play_line(1), 'xdata'); time = time(1);
