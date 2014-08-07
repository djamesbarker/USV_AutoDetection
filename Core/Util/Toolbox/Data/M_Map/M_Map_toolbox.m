function toolbox = M_Map_toolbox

%------------------------
% DATA
%------------------------

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

toolbox.name = 'M_Map';

toolbox.home = 'http://www.eos.ubc.ca/~rich/map.html';

toolbox.url = 'http://www.eos.ubc.ca/%7Erich/m_map1.4.zip';

toolbox.install = @install;

%------------------------
% INSTALL
%------------------------

function install

% movefile(fullfile(toolbox_root('M_Map'), 'm_map', '*'), toolbox_root('M_Map'));
% 
% rmdir(fullfile(toolbox_root('M_Map'), 'm_map'), 's');
