function tag = browser_tag(sound, lib, user)

% browser_tag - build browser tag
% -------------------------------
%
% tag = browser_tag(sound, lib, user)
%
% Input:
% ------
%  sound - sound
%  lib - library
%  user - user
%
% Output:
% -------
%  tag - tag

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

%----------------
% HANDLE INPUT
%----------------

if (nargin < 3) || isempty(user)
	user = get_active_user;
end

if (nargin < 2) || isempty(lib)
	lib = get_active_library;
end

%----------------
% BUILD TAG
%----------------

% TODO: extend to other types of browser

type = 'XBAT_SOUND_BROWSER'; sep = '::';

tag = [type, sep, user.name, sep, get_library_name(lib), sep, sound_name(sound)];

