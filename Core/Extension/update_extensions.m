function update_extensions(verb)

% update_extensions - shortcut to updating system extensions
% ----------------------------------------------------------
%
% update_extensions(verb)
%
% Input:
% ------
%  verb - verbosity flag (def: 0)

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
% $Revision: 2098 $
% $Date: 2005-11-09 21:51:51 -0500 (Wed, 09 Nov 2005) $
%--------------------------------

if ~nargin
	verb = 0;
end

%--
% update extensions cache
%--

get_extensions('!');

if verb
	disp('Extensions cache updated.');
end

%--
% update extension menus
%--

update_filter_menu; 

update_detect_menu;

if verb
	disp('Extension menus updated.');
	disp(' ');
end
