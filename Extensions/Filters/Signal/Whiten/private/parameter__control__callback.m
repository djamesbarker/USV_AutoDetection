function result = parameter__control__callback(callback, context)

% WHITEN - parameter__control__callback

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

% result = struct;

switch callback.control.name

	case 'use_log'
		
		value = get_control(callback.pal.handle, callback.control.name, 'value');
			
		set_control(callback.pal.handle, 'noise_log', 'enable', value);

		% NOTE: this is mostly used during 'onload', it has a global effect	
		if ~isempty(callback.par.handle)
            update_extension_palettes(callback.par.handle);
        end
        
	case 'lowpass'
		
		value = get_control(callback.pal.handle, callback.control.name, 'value');
			
		set_control(callback.pal.handle, 'max_freq', 'enable', value);
		
end

% TODO: we need to update filter so that there is something to update in display

%--
% call parent callback
%--

fun = parent_fun; result = fun(callback, context);
