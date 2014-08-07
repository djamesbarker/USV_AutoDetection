function update = slider_sync(obj, handles, type)

% slider_sync - set consistent slider and edit box in slider control
% ------------------------------------------------------------------
% 
% update = slider_sync(obj, handles, type)
%
% Input:
% ------
%  obj - slider callback handle
%  handles - all slider control handles
%  type - slider type ('time', 'integer')
%
% Output:
% -------
%  update - update indicator

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 6797 $
% $Date: 2006-09-25 18:41:35 -0400 (Mon, 25 Sep 2006) $
%--------------------------------

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% get slider handles if needed
%--

control = get(obj, 'tag');

if (nargin < 2) || isempty(handles)
	handles = findobj(get(obj, 'parent'), 'tag', control);
end

%--
% get slider type if not provided
%--

if (nargin < 3)
	type = get_slider_type(handles);
end

%--------------------------------------
% SYNC SLIDER
%--------------------------------------

switch get(obj, 'style')
	
	%--
	% edit updates slider
	%--
	
	case 'edit'
		
		%--
		% get value from edit box string
		%--

		value = slider_str2num(get(obj, 'string'), type);
		
		%--
		% if edit box content is nonsense set previous value and return
		%--
				
		if isempty(value)
			
			control_flash(obj, 'backgroundcolor', [1, 0.6, 0.6]);
			
			% get value from slider
			
			value = get(findobj(handles, 'style', 'slider'), 'value');

			set(obj, 'string', slider_num2str(value, type));
			
			update = 0; return;
			
		else
		
			%--
			% enforce slider bounds on value
			%--
			
			slider = findobj(handles, 'style', 'slider');
			
			if value < get(slider, 'min')
				
				value = get(slider, 'min');

			elseif value > get(slider, 'max')
				
				value = get(slider, 'max');

			end
			
			%--
			% update slider and edit box
			%--
			
			set(slider, 'value', value); set(obj, 'string', slider_num2str(value, type));
					
		end
				
	%--
	% slider affects edit box
	%--
	
	case 'slider'
		
		%--
		% get value from slider
		%--
		
		value = get(obj, 'value');
		
		% NOTE: we round in the case of integer sliders
		
		if strcmp(type, 'integer')	
			
			value = round(value); set(obj, 'value', value);	
			
		end
		
		%--
		% update edit string according to type
		%--
				
		set(findobj(handles, 'style', 'edit'), 'string', slider_num2str(value, type));
		
end

%--
% indicate update
%--

update = 1;


%----------------------------------------
% GET_SLIDER_TYPE
%----------------------------------------

function type = get_slider_type(handles)

% HACK: there are some naming problems to be resolved, remove non control handles

ix = find(~strcmp(get(handles, 'type'), 'uicontrol')); handles(ix) = [];

%--
% find slider in handles
%--

ix = find(strcmp('slider', get(handles, 'style')), 1);

if isempty(ix)
	error('There is no slider in handles.');
end

slider = handles(ix);

%--
% get type from slider
%--

% NOTE: the slider type is stored in the slider handle userdata

type = get(slider, 'userdata');

% NOTE: generic slider has empty type

if isempty(type)
	type = ''; return;
end

%--
% check slider type
%--

if isstruct(type) && isfield(type, 'type')
	type = type.type;
end

if ~ischar(type)
	error('Non-empty slider type should be a string.');
end

if ~ismember(type, get_slider_types)
	error(['Unrecognized slider type ''', type, '''.']);
end


%----------------------------------------
% SLIDER_STR2NUM
%----------------------------------------

function num = slider_str2num(str, type)

%--
% set default type
%--

if (nargin < 2) || isempty(type)
	type = '';
end

%--
% make eval just a little bit safe
%--

% NOTE: we do not allow evaluation of strings with any of these

censored = {'quit', 'close', 'delete', 'set', 'stop', 'figure', 'uicontrol'};

for k = 1:numel(censored)
	
	if strfind(str, censored{k})
		str = ''; break;
	end
	
end

%--
% convert string to number
%--

switch type

	case 'time'
		num = clock_to_sec(str);

	case 'integer'
		try
			num = round(eval(str));
		catch
			num = [];
		end

	otherwise
		try
			num = eval(str);
		catch
			num = [];
		end
		
end

		
%----------------------------------------
% SLIDER_NUM2STR
%----------------------------------------

function str = slider_num2str(num, type)

%--
% set default type
%--

if (nargin < 2) || isempty(type)
	type = '';
end

%--
% convert number to string
%--

switch type

	case 'time'
		str = sec_to_clock(num); 

	case 'integer'
		str = int2str(num);

	otherwise
		str = num2str(num);
		
end
