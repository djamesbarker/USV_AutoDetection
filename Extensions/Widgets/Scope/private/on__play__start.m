function [handles, context] = on__play__start(widget, data, parameter, context)

% SCOPE - on__play__start

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

handles = [];

if isempty(data.buffer)
	return;
end

%--
% create play line in spectrum axes
%--

ax = scope_axes(widget);

% NOTE: get sound player display options

player = sound_player;

scope_line(ax, ...
	'xdata', [0, 1], ...
	'ydata', [0, 0], ...
	'color', player.color ...
);

%--
% scale axes for a better display
%--

ylim = get_scope_ylim(data.buffer.samples);

scope_axes(widget, 'ylim', ylim);
