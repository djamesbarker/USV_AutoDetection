function [info, file] = preset_save(preset, name, type, tags, notes)

% preset_save - save preset to file
% ---------------------------------
%
% [info, file] = preset_save(preset, name, type, tags, notes)
%
% Input:
% ------
%  preset - preset
%  name - name
%  type - type
%  tags - tags
%  notes - notes
%
% Output:
% -------
%  info - preset file info
%  file - preset file

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

% NOTE: this is the current generic parameter preset store

%-------------------
% HANDLE INPUT
%-------------------

%--
% set default empty tags and notes
%--

if nargin < 5
	notes = {};
end

if nargin < 4
	tags = {};
end

if nargin < 3
	type = '';
end 

if nargin < 2
	if isfield(preset, 'name') && ~isempty(preset.name)
		name = preset.name;
	else
		error('need preset name.');
	end
end

%--
% handle tags
%--

if ischar(tags)
	tags = str_to_tags(tags);
end

if ~is_tags(tags)
	error('Input tags are not proper tags.');
end

%--
% check preset name
%--

if ~proper_filename(name)
	error('Preset name must be proper filename.');
end

%-------------------
% SAVE PRESET
%-------------------

%--
% get preset file location
%--

file = preset_file(preset.ext, name, type);

%--
% update preset
%--

if ~isempty(tags)
	preset.tags = tags;
end

if ~isempty(notes)
	preset.notes = notes;
end

%--
% save preset file and get info
%--

% TODO: the extension is part of the preset check for save method

try
	save(file, 'preset'); info = dir(file);
catch 
	info = [];
end
