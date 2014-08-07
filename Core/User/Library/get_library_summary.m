function info = get_library_summary(lib)

% get_library_summary - get summary of library contents
% -----------------------------------------------------
%
% info = get_library_summary(lib)
%
% Input:
% ------
%  lib - library (def: active library)
%
% Output:
% -------
%  info - content summary

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
% $Revision: 2025 $
% $Date: 2005-10-27 16:35:03 -0400 (Thu, 27 Oct 2005) $
%--------------------------------

% TODO: learn to cache and update these values, libraries need modification

% TODO: consider the use of the words 'summary' and 'info' in a variety of places

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set active library as default
%--

if (nargin < 1)
	lib = get_active_library;
end 

%--
% handle multiple libraries recursively
%--

if (length(lib) > 1)

	for k = 1:length(lib)
		info(k) = get_library_summary(lib(k));
	end

	return;

end

%----------------------------------
% COMPUTE SUMMARY
%----------------------------------

info.library = lib;

%--
% get library sounds and logs
%--

sounds = get_library_sounds(lib);

logs = get_library_logs('file');

info.sounds = length(sounds);

info.logs = length(logs);

%--
% get total duration of sounds in library
%--

% NOTE: consider how to use channel information

if (info.sounds)
	info.total_duration = sum(cell2mat({sounds.duration}));
else
	info.total_duration = 0;
end

%--
% get summary creation date
%--

info.created = now;
