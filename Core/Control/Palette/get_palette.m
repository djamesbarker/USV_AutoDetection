function pal = get_palette(par, str, data)

% get_palette - get palette figure handle by name
% -----------------------------------------------
%
% pal = get_palette(par, name, data)
%
% Input:
% ------
%  par - parent handle
%  name - palette name
%  data - parent data (where palettes are registered)
%
% Output:
% -------
%  pal - palette handle

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

% TODO: rename variables as in help

% TODO: refactor completely

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% get palette through root
%--

% TODO: fix this, it's wrong

if isempty(par) || (par == 0)
	pal = findobj(get(0, 'children'), 'flat', 'name', str); return;
end

%--
% get parent data if needed
%--

if (nargin < 3) || isempty(data)
	data = get_browser(par);
end

%-------------------------
% GET PALETTE
%-------------------------

%--
% get palettes from parent
%--

% NOTE: consider storage in 'data.APP_CODE.palettes' with the application code stored in the parent tag

try
	pals = data.browser.palettes;
catch
	pals = data.browser.palette.handle;
end

%--
% remove stranded palette handles
%--

for k = length(pals):-1:1
	if ~ishandle(pals(k))
		pals(k) = [];
	end
end

if isempty(pals)
	pal = []; return;
end

% NOTE: return all palettes if no selection

if (nargin < 2) || isempty(str)
	pal = pals; return;
end

%--
% select palette by name
%--

% this requires that proper handles in the palette array

% for the moment deal with stranded handles in the palette array

try
	name = get(pals, 'tag');
catch
	pal = []; return;
end

if (length(pals) == 1)
	
	tmp = name;
	clear name;
	name{1} = tmp;
	
end
		
ix = [];	

for k = 1:length(name)	
	
	%--
	% find string at the end of the tag
	%--
		
	% NOTE: this is a partial parsing of the tag string
	
	try
		flag = strcmp(name{k}(end - length(str) + 1:end), str);
	catch
		continue;
	end
	
	if (flag == 1)
		ix = k; break;
	end	
	
end

%--
% output palette figure handle
%--

if ~isempty(ix)
	pal = pals(ix);
else
	pal = [];
end
	
