function presets = get_presets(ext, type, varargin)

% get_presets - get extension presets
% -----------------------------------
%
% presets = get_presets(ext, type, 'field', value, ...)
%
% Input:
% ------
%  ext - extension
%  type - preset type
%  field - field name
%  value - field value
%
% Output:
% -------
%  presets - presets

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

%--------------------------------------
% GET PRESET FILES
%--------------------------------------

%--
% set default type
%--

if (nargin < 2) || isempty(type)
	type = '';
end

%--
% initialize presets
%--

% NOTE: this is not currently used, in the non-trivial case

presets = empty(preset_create);

%--
% get preset files and root 
%--

[files, root] = get_preset_files(ext, type);

if isempty(root) || isempty(files)
	return;
end

names = file_ext(files);

%--------------------------------------
% LOAD PRESETS
%--------------------------------------

for k = 1:length(names)
	
	try
		preset = preset_load(ext, names{k});
	catch
		continue;
	end
	
	% NOTE: the struct udpate provides a weak normalization
	
	opt = struct_update; opt.flatten = 0;
	
	presets(end + 1) = struct_update(preset_create, preset, opt);
	
end

%---------------------------------------------------------------
% SELECT PRESETS
%---------------------------------------------------------------

% TODO: add name filtering to this function

% TODO: this kind of selection will be factored, expanded, and improved

%--
% consider selection when we have something to select and criteria
%--

if length(varargin) && ~isempty(presets)
	
	%--
	% get field value pairs from input
	%--
	
	[field, value] = get_field_value(varargin);
	
	%--
	% loop over fields
	%--
	
	for j = 1:length(field)
				
		%--
		% check preset field
		%--
				
		if isfield(presets, field{j})

			for k = length(presets):-1:1
								
				if ~isequal(presets(k).(field{j}), value{j})
					presets(k) = [];
				end
				
			end
			
		%--
		% check preset values field
		%--
		
		elseif isfield(presets(1).values, field{j})

			for k = length(presets):-1:1
				
				if ~isequal(presets(k).values.(field{j}), value{j})
					presets(k) = [];
				end
				
			end
			
		end
		
		
	end
	
end
