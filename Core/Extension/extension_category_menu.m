function handles = extension_category_menu(par, ext, callback)

% extension_category_menu - create category menus for extensions
% --------------------------------------------------------------
%
% handles = extension_cateegory_menu(par, ext, callback)
%
% Input:
% ------
%  par - parent for menu
%  ext - extensions array
%  callback - callback
%
% Output:
% -------
%  handles - extension menu handles

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
% $Revision: 1380 $
% $Date: 2005-07-27 18:37:56 -0400 (Wed, 27 Jul 2005) $
%--------------------------------

% TODO: develop new callback framework for extension menus, start here

%------------------
% HANDLE INPUT
%------------------

%--
% get extensions by type if needed
%--

if ischar(ext)
	
	types = get_extension_types; type = ext;
	
	if ~ismember(type, types)
		error('Unrecognized extension type.');
	end
	
	ext = get_extensions(type);
	
end

% TODO: consider what to do when we have multiple extension types

%------------------
% SETUP
%------------------

%--
% get extension categories
%--

category = get_extension_categories(ext);

%--
% create menus
%--

handles = [];

for k = 1:length(category)
	
	%--
	% attach category parent to parent
	%--
	
	cat = uimenu(par, category(k).name); 
	
	%--
	% attach children to category parent
	%--
	
	for j = 1:length(category(k).children)
		
		label = [category(k).children{j}, ' ...'];
		
		handles(end + 1) = uimenu(cat, ...
			'label', label ...
		);
		
	end
	
end


