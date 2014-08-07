function delete_child(h,str)

% delete_child - delete child from screen and parent
% --------------------------------------------------
%
% delete_child(h,str)
%
% Input:
% ------
%  h - parent figure handle
%  str - child name

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
% get parent userdata
%--

data = get(h,'userdata');

%--
% get child handle
%--

g = get_child(h,str,data);

if (isempty(g))
	return;
end

%--
% remove child handle from list and update userdata
%--

ix = find(data.browser.children == g);

data.browser.children(ix) = [];

set(h,'userdata',data);

%--
% close child figure
%--

closereq;
