function format = format_mp3

% format_mp3 - create format structure
% ------------------------------------
%
% format = format_mp3
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
% fill format structure
%--

format.name = 'MPEG-1 Layer 3 (MP3)';

format.home = 'http://lame.sourceforge.net/';

format.ext = {'mp3'};

format.info = @info_mp3;

format.read = @read_mp3;

format.write = @write_mp3;

format.encode = @encode_mp3;

format.decode = @decode_mp3;

format.seek = 1;

format.compression = 1;

