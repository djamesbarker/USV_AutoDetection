function set_browser_info(h,sound)

% set_browser_info - set basic browser info
% -----------------------------------------
%
% info = set_browser_info(h,sound)
%
% Input:
% ------
%  h - browser handle
%
% Output:
% -------
%  info - browser info

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
% $Revision: 2093 $
% $Date: 2005-11-08 16:46:14 -0500 (Tue, 08 Nov 2005) $
%--------------------------------

%------------------------------
% HANDLE INPUT
%------------------------------


%------------------------------
% SET BROWSER INFO
%------------------------------

% NOTE: the implementation could change to a handle hash

%--
% get info string components
%--

sep = '::';

user = get_active_user;

lib = user.library(user.active);

%--
% build and store info string
%--

% TODO: extend this to handle various browser types

tag = [ ...
	'XBAT_SOUND_BROWSER', sep , user.name, sep, lib.name, sep, sound_name(sound) ...
];

set(h,'tag',tag);

%--
% get browser info if needed
%--

if (nargout)
	info = get_browser_info(h);
end
