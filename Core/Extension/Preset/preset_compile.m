function preset = preset_compile(pal)

% preset_compile - put together preset given palette handle
% ---------------------------------------------------------
%
% preset = = preset_compile(pal)
%
% Input:
% ------
%  pal - extension palette handle
%
% Output:
% -------
%  preset - compiled preset

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

% NOTE: this is not robust and needs work, limited use should not break it 

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

%--
% check for extension palette
%--

% NOTE: this extension is not current, but it helps further on

[test, ext] = is_extension_palette(pal);

if ~test
	error('Input handle is not extension palette.');
end
		
%----------------------------------------
% SETUP
%----------------------------------------

%--
% get palette parent
%--

% NOTE: the parent provides the context for the preset

par = get_palette_parent(pal);

data = get_browser(par);

%--
% get preset extension and context
%--

% NOTE: this extension contains compiled parameters, a superset of the controlled parameters

[ext, ignore, context] = get_browser_extension(ext.subtype, par, ext.name, data);

%--
% get active extensions
%--

types = setdiff(get_extension_types, ext.subtype);

% NOTE: this extension also has a context, it should essentially be the same as before

active = get_active_extension(types, par, data);

%----------------------------------------
% CREATE PRESET
%----------------------------------------

% TODO: preset info string for dialog box (?) consider full control preview

%--
% create preset with compiled information
%--

% NOTE: the context contains a copy of the extension

preset = preset_create(ext, ...
	'ext',		ext, ...
	'context',	context, ...
	'active',	active ...
);
