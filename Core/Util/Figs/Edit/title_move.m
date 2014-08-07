function title_move(d,h)

% move_title - move all titles in figure
% --------------------------------------
%
% title_move(d,h)
%
% Input:
% ------
%  d - distance to move (negative is up)
%  h - parent figure handle

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
% set figure
%--

if ((nargin < 2) | isempty(h))
	h = gcf;
end

%--
% return if no distance
%--

if ((nargin < 1) | isempty(d))
	return;
end

%--
% get axes titles in figure
%--

ax = findobj(h,'type','axes');
ti = zeros(size(ax));

for k = 1:length(ax)
	ti(k) = get(ax(k),'title');
end

%--
% modify position of titles in figure
%--

for k = 1:length(ti)
	pos = get(ti(k),'position');
	pos(2) = pos(2) + d;
	set(ti(k),'position',pos);
end


