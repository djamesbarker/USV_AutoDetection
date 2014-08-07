function geometry = get_geometry(sound, type)

%------------------------------
% HANDLE INPUT
%------------------------------

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

if nargin < 2 || isempty(type)
	type = 'local';
end

types = {'local', 'global'};

if ~ismember(type, types)
	error(['invalid geometry type, "', type, '".']);
end

%------------------------------
% GET GEOMETRY
%------------------------------
	
error_str = [type, ' geometry not available for "', sound_name(sound), '"'];

if ~isfield(sound, 'geometry')
	geometry = []; return;
end

%--
% structured geometry
%--

if isstruct(sound.geometry) 
	
	if isfield(sound.geometry, type)
		geometry = sound.geometry.(type); return;	
	else
		error(error_str);
	end
	
end

%--
% simple geometry (BC)
%--

if strcmp(type, 'local') 
	geometry = sound.geometry; return;
else
	error(error_str);
end

