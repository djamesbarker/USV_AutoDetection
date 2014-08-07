function tab_sound

% tab_sound - tab selection sound
% -------------------------------

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
% $Revision: 1156 $
% $Date: 2005-07-01 07:11:26 -0400 (Fri, 01 Jul 2005) $
%--------------------------------

%--
% return if palette sounds are not on
%--

if (~isequal(get_env('palette_sounds'),'on'))
	return;
end

%--
% create tab selection sound
%--

% TODO: make this configurable and load from file

n = 50;

x = 0.0075 * (sort(randn(1,n)) + 0.1 * randn(1,n));

%--
% play tab selection sound
%--

% NOTE: blocking play avoids multiple simultaneous play requests

sound(2 * x);
