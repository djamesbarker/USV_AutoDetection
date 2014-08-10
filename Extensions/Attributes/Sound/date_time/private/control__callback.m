function result = control__callback(callback, context)

% DATE_TIME - control__callback

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

result = [];

switch callback.control.name

	case 'datetime'
	
		value = get_control(callback.pal.handle, 'datetime', 'value');

		%--
		% enforce validity of date string
		%--
		
		try
			datevec(value);
		catch
			set_control(callback.pal.handle, 'datetime', 'string', datestr(context.attribute.datetime, 0));
		end
		
	case 'get_from_files'
		
		file = context.sound.file;
		
		if iscell(file)
			file = file{1};
		end
		
		num = file_datenum(file);
		
		if ~isempty(num)
			set_control(callback.pal.handle, 'datetime', 'string', datestr(num));
		end
		
end
