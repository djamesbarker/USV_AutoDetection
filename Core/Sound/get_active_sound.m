function [sound, lib] = get_active_sound(par, pal)

% get_active_sound - get the active sound
% ---------------------------------------
%
% [sound, lib] = get_active_sound(par, pal)
%
% Input:
% ------
%  par - browser handle (def: active browser)
%  pal - XBAT palette handle
%
% Output:
% -------
%  sound - sound
%  lib - parent library

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
% Author: Matt Robbins
%--------------------------------
% $Revision: 5869 $
% $Date: 2006-07-28 12:32:05 -0400 (Fri, 28 Jul 2006) $
%--------------------------------

%--
% handle input
%--

lib = []; sound = [];

if nargin < 1 || isempty(par)
	par = get_active_browser;
end

if nargin < 2 || isempty(pal)
	pal = get_palette(0, 'XBAT');
end

%--
% get sound and library from open browser
%--

if ~isempty(par)
	
	sound = get_browser(par, 'sound'); info = parse_browser_tag(get(par, 'tag'));
	
	[ignore, libname] = strtok(info.library, filesep); libname = libname(2:end);   
	
	lib = get_libraries(get_users('name', info.user), 'name', libname);
	
	return;

end

%--
% otherwise, get sound from xbat palette if possible
%--

[sound, lib] = get_selected_sound(pal);

if length(sound) > 1
	sound = [];
end





	
	
	
