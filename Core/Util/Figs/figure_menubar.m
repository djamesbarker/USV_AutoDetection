function figure_menubar(h)

% figure_menubar - toggle figure menubar
% --------------------------------------
%
% figure_menubar(h)
%
% Input:
% ------
%  h - figure handles (def: gcf)

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
% $Revision: 1.0 $
% $Date: 2003-09-16 01:30:51-04 $
%--------------------------------

%--
% set figure handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% toggle menubar
%--

for k = 1:length(h)
	tmp = get(h(k),'menubar');
	switch (tmp)
	case ('none')
		set(h(k),'menubar','figure');
	case ('figure')
		set(h(k),'menubar','none');
	end
end
