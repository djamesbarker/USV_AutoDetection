function h = figs_true(h)

% figs_true - display images pixel to pixel
% -----------------------------------------
% 
% h = figs_true(h)
%
% Input:
% ------
%  h - handles of figures to resize (def: open figures)
%
% Output:
% -------
%  h - handles of figures

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
% get figure handles
%--

if ((nargin < 1) | isempty(h))
	h = get(0,'children');
end

%--
% get figures with image_menu and set normal size
%--

for k = 1:length(h)

	t = findobj(h(k),'type','uimenu','label','Image');
	
	if (~isempty(t))
		image_menu(h(k),'Normal Size');
	end
	
end

%--
% older code
%--

% 	for j = length(t):-1:1
% 		if (strcmp(get(t(j),'tag'),'TMW_COLORBAR'))
% 			t(j) = [];
% 		end
% 	end
% 
% 	if (~isempty(t))
% 		truesize(h(k),s*size(get(t,'CData')));
% 	end

	
		
