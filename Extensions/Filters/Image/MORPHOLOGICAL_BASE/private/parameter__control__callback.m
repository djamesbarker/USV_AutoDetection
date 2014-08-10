function result = parameter__control__callback(callback, context)

% MORPHOLOGICAL_BASE - parameter__control__callback

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

%--
% set default result
%--

result = [];

%--
% peform control update
%--

switch callback.control.name
	
	case {'width','height'}
		
		%--
		% consider linked controls
		%--
		
		[ignore, link] = control_update([], callback.pal.handle, 'link');
		
		if link == 1
			
			% NOTE: this line is too intimate, it is used for efficiency
		
			value = get(findobj(callback.control.handles, 'style', 'slider'), 'value');
			
			if strcmp(callback.control.name, 'width')
				other = 'height';
			else
				other = 'width';
			end
						
			control_update([], callback.pal.handle, other, value);
			
		end
	
	case 'link'
		
		%--
		% link controls if needed
		%--
		
		% NOTE: set both controls to minumum value for efficiency
		
		if get(callback.obj,'value') == 1
			
			%--
			% get width and height
			%--
			
			[ignore,width] = control_update([],callback.pal.handle,'width');
			
			[ignore,height] = control_update([],callback.pal.handle,'height');
			
			%--
			% set both controls to minimum value
			%--
			
			if (width < height)
				
				control_update([],callback.pal.handle,'height',width);
		
			elseif (width > height)
				
				control_update([],callback.pal.handle,'width',height);
				
			% TODO: clean up the handling of result
			
			else
				result.update = 0;
			end
			
		else
			result.update = 0;
		end
		
end

% TODO: develop standard result structure

%--
% update icon display of parameters
%--
	
% NOTE: previous code achieves consistency so 'get_control_values' works

plot_se(callback.pal.handle, get_control_values(callback.pal.handle));

