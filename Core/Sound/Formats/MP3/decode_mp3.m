function out = decode_mp3(f1, f2)

% decode_mp3 - decode mp3 to wav
% ------------------------------
%
% com = decode_mp3(f1, f2)
%
% Input:
% ------
%  f1 - input file
%  f2 - output file
%
% Output:
% -------
%  com - command to execute to perform decoding

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%----------------------------------------------------
% BUILD COMMAND STRING
%----------------------------------------------------

%--
% persistently  store location of command-line helper
%--

persistent LAME_PATH;

if isempty(LAME)
	LAME_PATH = [fileparts(mfilename('fullpath')), filesep, 'lame.exe'];
end

%--
% build full command string
%--

out = ['"', LAME_PATH, '" --decode "', f1, '" "', f2, '"'];
