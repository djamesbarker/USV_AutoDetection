function str = get_browser_time_string(par, time, context)

% get_browser_time_string - get browser time string
% -------------------------------------------------
%
% str = get_browser_time_string(par, time, context)
%
% Input:
% ------
%  par - browser
%  time - browser time, slider time
%  context - extension context
%
% Output:
% -------
%  str - browser time string

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
% handle input
%--

if nargin < 3
	
	if (nargin < 1) || isempty(par)
		par = get_active_browser;
	end
	
	if isempty(par)
		str = ''; return;
	end 
	
	context = get_extension_context([], par); 
	
end

% NOTE: sometimes we use this because it is hard to get the slider time from context

if (nargin < 2) || isempty(time)
	slider = get_time_slider(par); time = slider.value;
end

%--
% get browser time string
%--

% NOTE: get real time from slider time, this handles sessions

time = map_time(context.sound, 'real', 'slider', time);

% NOTE: we use grid options and real-time to produce string

str = get_grid_time_string(context.display.grid, time, context.sound.realtime);
