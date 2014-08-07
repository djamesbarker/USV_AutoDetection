function format = format_aac

% format_aac - create format structure
% -----------------------------------
%
% format = format_aac
%
% Output:
% -------
%  format - format structure

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
% $Revision: 689 $
% $Date: 2005-03-09 22:14:37 -0500 (Wed, 09 Mar 2005) $
%--------------------------------

%--
% create format structure
%--

format = format_create;

%--
% fill format structure (set)
%--

format.name = 'Advanced Audio Coding (AAC)';

format.ext = {'aac', 'mp4', 'm4a', 'm4b'};

format.home = 'http://www.audiocoding.com/';

format.info = [];

format.read = [];

format.write = [];

format.seek = 0;

format.compression = 1;


