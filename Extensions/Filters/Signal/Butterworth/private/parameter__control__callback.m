function result = parameter__control__callback(callback, context)

% BUTTERWORTH - parameter__control__callback

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
	
	case 'sel_config'
	
		%--
		% get handles
		%--
		
		pal = callback.pal.handle; par = callback.par.handle;
		
		%--
		% get selection
		%--
		
		[selection, count] = get_browser_selection(par);
		
		if ~count
			return;
		end
		
		freq = selection.event.freq;
		
		%--
		% update cutoff based on type
		%--
		
		type = get_control(pal, 'type', 'value'); type = type{1};
		
		if strcmpi(type, 'low')
			value = freq(2);
		else
			value = freq(1);
		end
		
		% NOTE: we use this control name so the parent can draw a guide
		
		set_control(pal, 'max_freq', 'value', value);
		
end

%--
% update filter response display using parent callback
%--

fun = parent_fun; result = fun(callback, context);
