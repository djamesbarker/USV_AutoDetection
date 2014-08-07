function type = extension_type_from_name(name)

% extension_type_from_name - get extension type from name
% -------------------------------------------------------
%
% type = extension_type_from_name(name)
%
% Input:
% ------
%  name - extension name
%
% Output:
% -------
%  type - extension type

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

type = '';

%--
% get extension names and types
%--

ext = get_extensions;

names = {ext.name}; types = {ext.subtype};

%--
% find extensions by name
%--

ix = find(strcmp(name, names));

if isempty(ix)
	return;
end

type = types(ix);

if (length(ix) < 2)
	type = type{1};
end
	
