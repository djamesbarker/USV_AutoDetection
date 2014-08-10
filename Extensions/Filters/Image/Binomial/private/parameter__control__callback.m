function result = parameter__control__callback(callback, context)

% BINOMIAL - parameter__control__callback

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

result = struct;

%--
% update state
%--

handle = callback.pal.handle;

link = get_control(handle, 'link', 'value');

% NOTE: we only need to do something substantial when link is on

if link
	
	value = get_control(handle, callback.control.name, 'value');

	switch callback.control.name

		case 'width'
			set_control(handle, 'height', 'value', value);

		case 'height'
			set_control(handle, 'width', 'value', value);

		case 'link'

			width = get_control(handle, 'width', 'value');
				
			height = get_control(handle, 'height', 'value');

			% NOTE: no need for update anything if link caused no change
			
			if height == width
				return;
			else
				if height < width
					set_control(handle, 'width', 'value', height);
				else
					set_control(handle, 'height', 'value', width);
				end
			end

	end

end

%--
% update and compile parameters
%--

% NOTE: this approach seems a bit cumbersome

context.ext.parameter = struct_update(context.ext.parameter, get_control_values(handle));

% NOTE: we can call extension methods directly by name, not inherited ones

context.ext.parameter = parameter__compile(context.ext.parameter);

%--
% call parent function to display mask
%--

fun = parent_fun; result = fun(callback, context);
