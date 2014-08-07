function pixel_menu(h)

% pixel_menu - context menu for displaying pixel information
% ----------------------------------------------------------
%
% pixel_menu(h)
%
% Input:
% ------
%  h - handle to parent figure (def: gcf)

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

if (~nargin)
	h = gcf;
end

%--
% get image handle
%--

hi = get_image_handles(h);

if (length(hi) == 1)
	hc = uicontextmenu;
	set(hi,'uicontextmenu',hc);
else 
	error('More than one displayed image in figure. No pixel menu attached.');
end

%--
% create pixel menu
%--

L = { ...
	'Location: ', ...
	'R: ', ...
	'G: ', ...
	'B: ' ...
}

n = length(L);

S = bin2str(zeros(1,n));
S{2} = 'on';

A = cell(1,n);

hg = menu_group(hc,'',L,S,A); 

