function geometry = sync_geometry(geometry, type, ref)

% sync_geometry - synchronize local and global geometry fields
% ------------------------------------------------------------
%
% geometry = sync_geometry(geometry, type)
%
% Input:
% ------
%  geometry - geometry struct
%  type - which reference frame to synchronize to
%
% Output:
% -------
%  geometry - geometry struct
%

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

if ~has_toolbox('M_Map')
	
	install_toolbox('M_Map', 'http://www.eos.ubc.ca/%7Erich/m_map1.4.zip');
end

if nargin < 3 || isempty(ref)
	
	[ignore, ref] = min(sum(geometry.local.^2, 2)); %#ok<ASGLU>
end

if isempty(geometry.global) 
	
	if strcmp(type, 'global')
		return;
	end
		
	%--
	% create global geometry if we need to sync to local
	%--
		
	min_max_lon = [-1, 1]; min_max_lat = [-1, 1];
	
	geometry.global = zeros(size(geometry.local));
	
	geometry.offset = [0, 0, 0];
	
	geometry.ellipsoid = 'wgs84';
else
	min_max_lat = fast_min_max(geometry.global(:, 1));

	min_max_lon = fast_min_max(geometry.global(:, 2));
end

%--
% set up projection using current coordinates
%--

% NOTE: we can only do this if we have some way of anchoring the array geometry

if ~isempty(geometry.ellipsoid)

	m_proj('utm', 'longitude', min_max_lon, 'latitude', min_max_lat, 'ellipsoid', geometry.ellipsoid);
end

%--
% synchronize
%--

switch type
	
	case 'global'
		
		%--
		% get utm coordinates
		%--
		
		[x y] = m_ll2xy(geometry.global(:, 2), geometry.global(:, 1));
		
		%--
		% compute new offset and store in local
		%--
		
		geometry.offset = [x(ref), y(ref)];
		
		ix = 1:length(x);
		
		geometry.local(ix, 1) = x - geometry.offset(1); 
		
		geometry.local(ix, 2) = y - geometry.offset(2);
		
	case 'local'
		
		if isempty(geometry.offset)
			return;
		end
		
		%--
		% get coordinates with offset
		%--
		
		x = geometry.local(:, 1) + geometry.offset(1);
		
		y = geometry.local(:, 2) + geometry.offset(2);
		
		[lon, lat] = m_xy2ll(x, y);
		
		ix = 1:length(lat);
		
		% NOTE: there are some ambiguities regarding what happens when the
		% reference channel is edited.
		
		geometry.global(ix, 2) = lon; geometry.global(ix, 1) = lat;
end

