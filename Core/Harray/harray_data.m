function data = harray_data(par, data)

% harray_data - harray data get and set
% -------------------------------------
%
% data = harray_data(par, data)
%
% Input:
% ------
%  par - parent figure handle
% 
% Output:
% -------
%  data - harray data structure

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

%--
% set default figure
%--

if nargin < 1
	par = gcf;
end

%--
% try to find support axes
%--

ax = findobj(par, 'tag', 'HARRAY_BASE_AXES');

if isempty(ax)
	data = []; return;
end 

%--
% get data
%--

if nargin < 2
	data = get(ax, 'userdata'); return;
end

%--
% set data
%--
	
old_data = get(ax, 'userdata');

% NOTE: what may fail here is the 'resizefcn' evaluation

try
	set(ax, 'userdata', data); feval(get(par, 'resizefcn'), par, []);
catch
	nice_catch(lasterror, ...
		'WARNING: Problem setting ''harray'' state, reverted to previous state.' ...
	); 
	set(ax, 'userdata', old_data);
end


