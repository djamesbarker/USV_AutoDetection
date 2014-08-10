function result = parameter__control__callback(callback, context)

% STRIP - parameter__control__callback

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
% setup
%--

result = [];

pal = callback.pal;

%--
% control switch
%--

switch callback.control.name
	
	case 'all'
		
		value = get(callback.obj, 'value');
		
		control = get_control(pal.handle, 'measures');
		
		measures = get(control.handles.obj, 'string');
		
		if value
			
			% NOTE: if we have measures select all, otherwise return
			
			if ~isempty(measures)
				set(control.handles.obj, 'value', 1:length(measures)); 
			end

			return;
		
		else
		
			% NOTE: the first time we disable all discover measures

			if isempty(measures)

				%--
				% start discovery
				%--
				
				set(callback.obj, 'enable', 'off');

				set(control.handles.obj, ...
					'string', 'Discovering measures ...', ...
					'value', [] ...
				);
			
				drawnow;
				
				%--
				% discover and update
				%--
				
				measures = discover_measures(context.target);

				set(control.handles.obj, ...
					'string', measures, ...
					'value', 1 ...
				);

				set(callback.obj, 'enable', 'on');

			end
			
		end
		
	case 'inplace'
		
		value = get(callback.obj, 'value');
		
		set_control(pal.handle, 'suffix', 'enable', ~value);
		
	case 'measures'
		
		value = get_control(pal.handle, 'all', 'value');
		
		% NOTE: keep all selected if we all button is checked
		
		if value
			set(callback.obj, ...
				'value', 1:length(get(callback.obj, 'string')) ...
			);
		end
			
end
