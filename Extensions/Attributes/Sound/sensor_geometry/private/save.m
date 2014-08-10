function save(attribute, store, context)

% SENSOR_GEOMETRY - save

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

result = context.dialog_result;

%--
% check for toolbox
%--

if isempty(which('m_ll2xy'))
	attribute.global = [];
end

%--
% check for save format
%--

switch result.units{1}
	
	case 'lat-lon'
	
		lines{1} = 'lat, lon, elev';

		lines{2} = ['ll, ', attribute.ellipsoid];
	
		type = 'global';
	
	otherwise
	
		lines{1} = 'x, y, z';
	
		lines{2} = 'xyz';
	
		type = 'local';
	
end

%--
% write geometry to lines
%--

[ignore, ref] = min(sum(attribute.local.^2, 2));

for k = 1:size(attribute.local, 1)
	
	line = '';
	
	if k == ref
		line = '*';
	end
		
	for j = 1:3
	
		if numel(attribute.(type)(k, :)) >= j
			value = attribute.(type)(k, j);
		else
			value = 0;
		end
					
		line = [line, num2str(value), ', '];
		
	end
	
	line(end-1:end) = [];
	
	lines{end + 1} = line;
	
end
	
file_writelines(store, lines);


