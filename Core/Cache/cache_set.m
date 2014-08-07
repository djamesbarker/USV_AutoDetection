function cache_set(cache)

% cache_set - put or update cache data 
% ------------------------------------
%
% cache_set(cache)
%
% Input:
% ------
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
% get environment userdata
%--

data = get(0,'userdata');

%--
% cache is not empty
%--

if (isfield(data,'cache') && length(data.cache))
	
	%--
	% check for cache update
	%--
	
	labels = struct_field(data.cache,'label');
	ix = find(cache.label == labels);
	
	%--
	% update cache or set new cache
	%--
	
	if (~isempty(ix))
		data.cache(ix) = cache; 
	else
		data.cache(length(data.cache) + 1) = cache;
	end

%--
% empty cache, create new cache
%--

else
	
	data.cache = cache;
	
end

%--
% update environment userdata
%--

set(0,'userdata',data);
