function preset = preset_load(ext, name, type, context)

% preset_load - load preset from file
% -----------------------------------
%
% preset = preset_load(ext, name, type, context)
%
% Input:
% ------
%  ext - extension
%  name - preset name
%  type - preset type
%  context - context
%
% Output:
% -------
%  preset - preset or name

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

%-------------------------
% HANDLE INPUT
%-------------------------

if nargin < 4
	context = struct;
end

if nargin < 3
	type = '';
end

%-------------------------
% LOAD PRESET
%-------------------------

% TODO: implement custom preset load, consider file and directory presets

%--
% get preset file
%--

file = preset_file(ext, name, type);

if ~exist(file, 'file')
	error('Preset file does not seem to exist.');
end

%--
% load preset content based on type
%--

% NOTE: this loads the preset variable

load(file);

preset.name = name;


% NOTE: the context in this case is used to validate the content of the
% preset
