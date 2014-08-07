function register_palette(par,pal)

% register_palette - add palettes to browser palette list
% -------------------------------------------------------
%
% register_palette(par,pal)
%
% Input:
% ------
%  par - parent handle
%  pal - palette handles

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
% $Revision: 1482 $
% $Date: 2005-08-08 16:39:37 -0400 (Mon, 08 Aug 2005) $
%--------------------------------

% NOTE: we only modify the parent

%-------------------------
% HANDLE INPUT
%-------------------------

if ((nargin < 2) || isempty(pal))
	return;
end

if (ishandle(par) && strcmp(get(par,'type'),'figure'))
	data = get(par,'userdata');
else
	error('Parent input must be figure handle.');
end

%-------------------------
% REGISTER PALETTES
%-------------------------

%--
% ensure unique figure handles in palette list
%--

for k = 1:length(pal)
	
	if (ishandle(pal) && strcmp(get(pal,'type'),'figure'))
		data.browser.palette.handle(end + 1) = pal;
	end
	
end

data.browser.palette.handle = unique(data.browser.palette.handle);

%--
% update parent data
%--

set(par,'userdata',data);
