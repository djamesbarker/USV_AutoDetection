function cache = cache_create

% cache_create - create cache structure
% -------------------------------------
% 
% cache = cache_create
%
% Output:
% -------
%  cache - cache structure

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
% get current cache labels
%--

data = get(0,'userdata');

if (isfield(data,'cache'))
	
	if (length(data.cache))
		labels = struct_field(data.cache,'label');
		flag = 1;
	else
		flag = 0;
	end
	
else
	
	data.cache = [];
	flag = 0;
	
end

%--
% create unique double cache label
%--

label = rand(1) * 10^6;

if (flag)
	while (length(find(label == labels)))
		label = rand(1) * 10^6;
	end
end

%--
% create cache structure
%--

cache.type = 'cache';

cache.label = label;

cache.data = [];







