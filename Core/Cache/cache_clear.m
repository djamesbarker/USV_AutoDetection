function cache_clear(label)

% cache_clear - clear cache entry
% -------------------------------
%
% cache_clear(label)
%
% Input:
% ------
%  label - label of cache entry (def: clear all cache entries)

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
% clear a single or all cache entries
%--

if (nargin < 1)
	
	data = get(0,'userdata');
	
	if (isfield(data,'cache'))
		data.cache = [];
		set(0,'userdata',data);
	end 

else 
	
	data = get(0,'userdata');
	
	if (isfield(data,'cache') & length(data.cache))
		labels = struct_field(data.cache,'label');
		ix = find(label == labels);
		if (~isempty(ix))
			data.cache(ix) = [];
		end
		set(0,'userdata',data);
	end
	
end
		
