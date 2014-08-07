function str = view_to_str(opt)

% view_to_str - create command string for view options
% ----------------------------------------------------
% 
% str = view_to_str(opt)
%
% Input:
% ------
%  opt - spectrogram options
%
% Output:
% -------
%  str - command string to achieve spectrogram options

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
% create string from options
%--

str = '%--\n% VIEW OPTIONS\n%--\n\n';

%--
% colormap options
%--

str = '%--\n% COLORMAP OPTIONS\n%--\n\n';

tmp = opt.colormap;

str = [str 'browser_view_menu(gcf,''Colormap::' tmp.name ''');\n'];
str = [str 'browser_view_menu(gcf,''Invert::' int2str(tmp.invert) ''');\n'];
str = [str 'browser_view_menu(gcf,''Auto Scale::' int2str(tmp.auto_scale) ''');\n'];

%--
% page options
%--

str = '%--\n% PAGE OPTIONS\n%--\n\n';

tmp = opt.page;

str = [str 'browser_view_menu(gcf,''Duration::' int2str(tmp.duration) ''');\n'];
str = [str 'browser_view_menu(gcf,''Overlap::' num2str(tmp.overlap) ''');\n'];
str = [str 'browser_view_menu(gcf,''Frequency Bounds ...::' mat2str(tmp.freq) ''');\n'];

%--
% grid options
%--

str = '%--\n% GRID OPTIONS\n%--\n\n';

tmp = opt.grid;

str = [str 'browser_view_menu(gcf,''Grid::' int2str(tmp.grid.on) ''');\n'];
str = [str 'browser_view_menu(gcf,''Time Grid::' int2str(tmp.grid.time.on) ''');\n'];
str = [str 'browser_view_menu(gcf,''Frequency Grid::' int2str(tmp.grid.freq.on) ''');\n'];
