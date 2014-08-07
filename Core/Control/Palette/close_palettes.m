function close_palettes(obj,eventdata,fun)

% close_palettes - close parent palettes
% --------------------------------------
% 
% close_palettes(obj,event,fun)
%
% Input:
% ------
%  obj - parent handle
%  event - reserved
%  fun - clean fun

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

%--
% set close fun
%--

if (nargin < 3)
	fun = @closereq;
end

%--
% get palette handles
%--

data = get(obj,'userdata');

pal = data.browser.palette.handle;

%--
% close all palettes
%--

for k = 1:length(pal)	
	close(pal(k),'force');
end

%--
% yield to fun
%--

if (~isempty(fun))
	fun();
end
