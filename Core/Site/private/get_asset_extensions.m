function ext = get_asset_extensions(type)

% GET_ASSET_EXTENSIONS get file extensions of assets of given type
%
% ext = get_asset_extensions(type)

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

ext = {};

if ~is_asset_type(type)
	return;
end

switch type
		
	case 'equations', ext = {'*.tex'}; 
		
	% NOTE: we will implement a distinction between 'Pages' from 'Assets\Pages'
	
	case {'fragments', 'pages'}, ext = {'*.html', '*.php', '*.xml'};
			
	case 'images', ext = {'*.gif', '*.jpg', '*.png'};
		
	case 'scripts', ext = {'*.js', '*.php'};
		
	case 'styles', ext = {'*.css'};
		
	otherwise, disp(['WARNING: Asset type ''', type, ''' has no defined extensions.']);
		
end 
