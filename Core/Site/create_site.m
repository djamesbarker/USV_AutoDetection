function site = create_site(name)

% CREATE_SITE create site directory structure
%
% site = create_site(name)

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
% check site name and whether site exists
%--

[root, exists] = site_root(name);

if isempty(root)
	error('Site name must be a proper filename with no spaces.');
end 

if exists
	disp(['Site ''', name, ''' seems to exist.']); return;
end

%--
% create site
%--

root = create_dir(root);

if isempty(root)
	error(['Failed to create ''', name, ''' site root.']);
end

child = site_children;

for k = 1:length(child)
	
	if isempty(create_dir([root, filesep, child{k}]))
		error(['Failed to create ''', name, ''' site child directory ''', child{k}, '''.']);
	end
	
end

site = name;

if ~nargout
	clear site;
end 
