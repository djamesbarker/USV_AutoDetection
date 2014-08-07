function measurement_menu(menus, event, par, m, ix)

% measurement_menu - construct a measurement context menu for an event
% --------------------------------------------------------------------
%
% measurement_menu(m, event)
%
% Input:
% ------
%  m - parent context menu
%  event - event

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


measurements = get_measurements(par);

measurement_names = {measurements.name};
	
%--
% Add measurement values
%--

meas_menu = get_menu(menus, 'Measure');

for k  = 1:length(event.measurement)

	%--
	% do nothing for no-name measurements
	%--
	
	if isempty(event.measurement(k).name)	
		continue;
	end

	%--
	% try to produce the measurement's context menu
	%--
	
	try
		
		feval(event.measurement(k).fun, 'menu', par, m, ix);
	
	catch
		
		nice_catch(lasterror, ['Measurement Menu Creation failed for ', event.measurement(k).name, '.']);
		
        try      
            
            callback = {@measurement_recompute_wrapper, event.measurement(k).fun, 'events', par, m, ix};
            
            measurement_struct_menu(meas_menu, event.measurement(k), callback);
            
        catch
            nice_catch(lasterror, 'Can''t generate measurement menu for selected event');    
        end
            
	end

end

%--
% Measures to Add ...
%--

L = setdiff(measurement_names,struct_field(event.measurement,'name'));

if ~isempty(L)
	
	L = strcat(L,' ...');

	tmp = menu_group(meas_menu, '', {'Add Measure'});

	if (get(tmp,'position') > 1)
		set(tmp,'separator','on'); 
	end

	n = length(L);

	S = bin2str(zeros(1,n));
	
	if (n > 1)
		mg = menu_group(tmp,'event_menu',L,S);
	else
		mg = menu_group(tmp,'event_menu',L);
	end

end

set(get_menu(menus,'Template'),'enable','off');

%--
% Hierarchy
%--

L = { ...
	['Level:  ' int2str(event.level)], ...
	'Children', ...
	'Parents' ...
};

n = length(L);

S = bin2str(zeros(1,n)); S{2} = 'on';

tmp = menu_group(get_menu(menus,'Hierarchy'),'',L,S);

%--
% Children
%--

if isempty(event.children)
	
	L = {'(No Children)'};
	
	set(menu_group(get_menu(tmp,'Children'),'',L),'enable','off');
	
else

end

%--
% Parents
%--

% TODO: update old logs that have events with 'parents' fields

if isempty(event.parent)
	
	L = {'(No Parents)'};
	
	set(menu_group(get_menu(tmp,'Parents'),'',L),'enable','off');
	
else

end

%--
% Copy Event To
%--

logs = get_browser(par, 'log'); logs(m) = [];

L = {};

for k = 1:length(logs)
	L{k} = log_name(logs(k));
end
	
if length(L)
	menu_group(get_menu(menus,'Copy Event To'),'event_menu',L);
end


%----------------------------------
% MEASUREMENT_STRUCT_MENU
%----------------------------------

function measurement_struct_menu(meas_menu, measurement, callback)

%--
% create new menu and attach measurement values
%--

h = uimenu(meas_menu, ...
    'Label', measurement.name ...
);

value_struct.value = measurement.value;

struct_menu(h, value_struct);

%--
% create 'Edit ...' option
%--	

uimenu(meas_menu, 'Label', 'Edit ...', 'callback', callback);


%----------------------------------
% MEASUREMENT_RECOMPUTE_WRAPPER
%----------------------------------

function measurement_recompute_wrapper(obj, eventdata, fh, varargin)

fh(varargin{:});



