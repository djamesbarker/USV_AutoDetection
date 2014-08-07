function handle = big_time_display(ax, time, grid, sound)

% big_time_display - big time display
% -----------------------------------
%
% handle = big_time_display(ax, time, limits, sound)
%
% Input:
% ------
%  ax - parent axes
%  time - time
%  grid - grid options
%  sound - related sound
%
% Output:
% -------
%  handle - big time handle

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
% $Revision: 4695 $
% $Date: 2006-04-20 11:22:26 -0400 (Thu, 20 Apr 2006) $
%--------------------------------

% TODO: expand to handle multiple axes for display

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% set default empty sound and grid
%--

% NOTE: use duck decoys to solve the variable input problem

if nargin < 4
	sound.time_stamp = []; sound.realtime = [];
end

if nargin < 3
	grid.time.labels = 'seconds';
end

%---------------------------
% BIG TIME DISPLAY
%---------------------------

%--
% convert to session time from slider time
%--

time = map_time(sound, 'real', 'slider', time);

%--
% use grid options to produce string
%--

% NOTE: realtime translation if applied if needed, this is independent from sessions

string = get_grid_time_string(grid, time, sound.realtime);

%--
% display big time string
%--

handle = big_centered_text(ax, string);
