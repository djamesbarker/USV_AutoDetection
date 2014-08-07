function toolbox = Wavelab_toolbox

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

toolbox.name = 'Wavelab';

toolbox.home = 'http://www-stat.stanford.edu/~wavelab';

toolbox.url = 'http://www-stat.stanford.edu/~wavelab/Wavelab_850/WAVELAB850.ZIP';

toolbox.install = @install;

%------------------------
% INSTALL
%------------------------

function install

%--
% copy patched files
%--

source = fullfile(toolbox_data_root('Wavelab'), 'Files', '*.m');

destination = real_toolbox_root('Wavelab');

copyfile(source, destination, 'f');

%--
% run startup
%--

p1 = pwd;

cd(destination);

startup;

cd(p1);
