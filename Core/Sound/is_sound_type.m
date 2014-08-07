function [value,type] = is_sound_type(type)

% is_sound_type - check and normalize sound type string
% -----------------------------------------------------
%
% [value,type] = is_sound_type(type)
%
% Input:
% ------
%  type - proposed type string
%
% Output:
% -------
%  value - valid type indicator
%  type - normalized type string

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
% $Revision: 2201 $
% $Date: 2005-12-06 08:15:05 -0500 (Tue, 06 Dec 2005) $
%--------------------------------

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% check type
%--

if (~ischar(type))
	value = 0; type = ''; return;
end

%--
% add some type string flexibility
%--

type = lower(strtrim(type));

%----------------------------
% CHECK AND NORMALIZE
%----------------------------

types = sound_types;

ix = find(strcmp(types,type));

if (isempty(ix))
	value = 0; type = ''; return;
end

value = 1;
