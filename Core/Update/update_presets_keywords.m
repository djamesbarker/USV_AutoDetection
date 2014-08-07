function update_presets_keywords

% update_presets_keywords - add keywords field to extension presets
% -----------------------------------------------------------------

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

% TODO: add other preset updates to this function and rename

%--
% create current new empty preset
%--

% NOTE: this should contain the keywords field

temp = preset_create;

%--
% get and loop over extensions
%--

ext = get_extensions;

for i = 1:length(ext)
	
	% NOTE: skip over disabled extensions

	if (~ext(i).enable)
		continue;
	end
	
	%--
	% get extension presets location
	%--
	
	info = functions(ext(i).fun.main);
	
	p = [path_parts(info.file), filesep, 'Presets'];
	
	%--
	% get extension presets
	%--
		
	presets = get_presets(ext(i));
	
	if (isempty(presets))
		continue;
	end
	
	%--
	% loop over and update presets
	%--
	
	str = [upper(ext(i).subtype), ': ', ext(i).name, ' Presets'];
	
	disp(' '); 
	disp(str_line(length(str)));
	disp(str);
	disp(str_line(length(str)));
	
	for j = 1:length(presets)
				
		%--
		% update preset if needed
		%--
		
		% NOTE: we add the keywords field and update the order
		
		% TODO: develop this into a separate function that harmonizes structures
		
		preset = presets(j);

		if (isfield(preset,'keywords'))
			continue;
		end
		
		preset.keywords = cell(0);
		
		preset = orderfields(preset,temp); 
		
		%--
		% save preset
		%--
		
		out = [p, filesep, preset.name, '.mat'];
		
		save(out,'preset');
		
		disp(out);
		
	end
	
end
