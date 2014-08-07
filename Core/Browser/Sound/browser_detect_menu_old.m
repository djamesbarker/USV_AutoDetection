function browser_detect_menu(h)

% browser_detect_menu - load menus of available detectors
% -------------------------------------------------------
%
% browser_detect_menu(h)
%
% Input:
% ------
%  h - handle to browser figure

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
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% check for existing detector menu
%--

if (get_menu(h,'Detect'))
	return;
end

%--
% get menu functions for available detectors
%--

fun = what('detectors'); 

if (isempty(fun.m))
	fun = fun.p;
else
	fun = fun.m;
end

j = 1;
for k = 1:length(fun)
	if findstr(fun{k},'_menu')
		tmp = findstr(fun{k},'.');
		menu{j} = fun{k}(1:tmp(end) - 1);
		j = j + 1;
	end
end

%--
% Create parent
%--

tmp = uimenu(h,'label','Detect');

set(tmp,'position',5);

if (exist('menu','var'))
	for j = 1:length(menu)
		if (~isempty(menu{j}))
			feval(menu{j},h,'Initialize');
		end
	end
end

