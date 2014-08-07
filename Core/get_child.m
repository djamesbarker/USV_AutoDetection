function g = get_child(h,str,data)

% get_child - get child figure handle name
% ----------------------------------------
%
% g = get_child(h,str,data)
%
% Input:
% ------
%  h - parent figure handle
%  str - child name string
%  data - parent figure userdata
%
% Output:
% -------
%  g - child figure handle

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% get userdata if needed
%--

if (nargin < 3)
	data = get(h,'userdata');
end

%--
% check for any children
%--

chi = data.browser.children;

if (isempty(chi))
	g = [];
	return;
end
	
%--
% check for specific child
%--

name = get(chi,'tag');

if (length(chi) == 1)
	tmp = name;
	clear name;
	name{1} = tmp;
end
		
ix = [];	
for k = 1:length(name)	
	
	%--
	% find string at the end of the tag
	%--
		
	try
		flag = strcmp(name{k}(end - length(str) + 1:end),str);
	catch
		continue;
	end
	
	if (flag == 1)
		ix = k;
		break;
	end	
	
end

%--
% output child figure handle
%--

if (~isempty(ix))
	g = chi(ix);
else
	g = [];
end
	
