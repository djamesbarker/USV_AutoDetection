function assets = get_assets(site, type, update)

% GET_ASSETS get site assets of given type
%
% assets = get_assets(site, type, update)

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

%-----------------
% HANDLE INPUT
%-----------------

%--
% set no update default
%--

if nargin < 3
	update = 0;
end

%--
% check site exists and asset type is known
%--

assets = {};

if ~exist_site(site) || ~is_asset_type(type)
	return;
end 

%-----------------
% GET ASSETS
%-----------------

%--
% try to get assets from cache
%--

persistent ASSETS_CACHE; 

if in_cache(ASSETS_CACHE, site, type) && ~update
	assets = ASSETS_CACHE.(site).(type); return;
end

%--
% get assets of given type from site
%--
	
% NOTE: get assets from site asset root according to asset extensions

source = assets_root(site, type); ext = get_asset_extensions(type);

content = get_extension_content(source, ext);

if ~isempty(content)
	assets = {content.name}';
end

ASSETS_CACHE.(site).(type) = assets;


%-----------------
% IN_CACHE
%-----------------

function value = in_cache(cache, site, type)

% NOTE: check cache is not empty and has asset type cache for site

value = ~isempty(cache) && isfield(cache, site) && isfield(cache.(site), type);



