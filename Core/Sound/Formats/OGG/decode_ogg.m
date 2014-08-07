function out = decode_ogg(f1,f2)

% decode_ogg - decode an ogg to wav
% ---------------------------------
%
% com = decode_ogg(f1,f2)
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

persistent OGGDEC;

if (isempty(OGGDEC))
	OGGDEC = [fileparts(mfilename('fullpath')), filesep, 'oggdec.exe'];
end

%--
% build full command string
%--

% NOTE: the 'Q' flag tries to make the decoding quiet

out = [ ...
	'"', OGGDEC, '" -Q --output="', f2, '" "', f1, '"' ...
];
