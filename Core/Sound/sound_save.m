function file = sound_save(lib, sound, state, opt)

% sound_save - save sound structure to file in library
% ----------------------------------------------------
%
% file = sound_save(lib, sound, state, opt)
%
% Input:
% ------
%  lib - library to save sound to (def: active library)
%  sound - sound to save
%  state - browser state to save
%  opt - refresh option
%
% Output:
% -------
%  file - file saved

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
% $Revision: 6520 $
% $Date: 2006-09-13 17:14:19 -0400 (Wed, 13 Sep 2006) $
%--------------------------------

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set default refresh
%--

if (nargin < 4) || isempty(opt)
	opt = 1;
end 

%--
% set default empty state
%--

if (nargin < 3)
	state = [];
end

%--
% check that sound is in library
%--

file = get_library_sound_file(lib, sound_name(sound));

% NOTE: check for the sound root directory

[par, leaf] = fileparts(file);

if ~exist_dir(par)
	error(['Root directory for ''', leaf, ''' not found in library.']);
end

%-------------------------------------------
% SAVE SOUND AND STATE
%-------------------------------------------
	
try
	save(file, 'sound', 'state');
catch
	xml_disp(lasterror);
end

%--
% update library cache if needed
%--

% NOTE: this might seem extraneous, but we are storing in a library, not just a file

if opt
	get_library_sounds(lib, 'refresh');
end
