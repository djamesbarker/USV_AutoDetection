function update_add_shortcuts

% update_add_shortcuts - add shortcuts to sound data in library sounds
% --------------------------------------------------------------------
%
% update_add_shortcuts

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

% TODO: consolidated sounds, this seems to require significant sound updates

% NOTE: the main advantage of consolidated sounds is that the library can be moved easily

% NOTE: how about consolidated libraries, should libraries be held anywhere

% TODO: implement library aliases in some kind of user update

%--
% get libraries
%--

libs = get_unique_libraries;

%--
% add data directories to sounds
%--

for k = 1:length(libs)
	add_sound_shortcut(libs(k));
end
