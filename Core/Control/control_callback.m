function [flag, handles] = control_callback(par, pal, control, data)

% control_callback - update control in palette
% ------------------------------------------
%
% [flag, handles] = control_callback(par, pal, control)
%
% Input:
% ------
%  par - parent figure of control if using palette name
%  pal - palette name or handle
%  control - control name
%
% Output:
% -------
%  flag - callback evaluation success
%  handles - control handles

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

%-------------------------------------
% HANDLE INPUT
%-------------------------------------

%--
% check control input
%--

if ~ischar(control)
	error('Control name must be a string.'); 
end

% NOTE: return quickly if we don't have the control

flag = 0; handles = []; 

if ~has_control(pal, control)
	return;
end

%--
% get palette from parent if needed
%--

if ischar(pal)
	
	if isempty(par)
		error('Can''t get palette from name, parent is empty.'); 
	else
		pal = get_palette(par, pal);
	end
	
end

if isempty(pal)
	error('Can''t find control, palette is empty.');
end

%-------------------------------------
% EXECUTE CONTROL CALLBACK
%-------------------------------------

%--
% get handles and callback
%--

handles = get_control(pal, control, 'handles');

callback = get_callback(handles.obj);

%--
% evaluate callback
%--

try
	
	switch get(handles.obj, 'type')

		case 'uicontrol'
			eval_callback(callback.Callback, handles.obj, []);

		case 'axes'
			eval_callback(callback.ButtonDownFcn, handles.obj, []);

	end

catch 
	
	flag = 1; nice_catch(lasterror, ['Callback execution failed for ''', control, '''.']);
	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% OLD CODE %%%%%%%%%%%%%%%%%%%%%%%%%%%

return;

%--
% try to get parent userdata
%--

if (nargin < 4) || isempty(data)
	
	if ~isempty(par)
		data = get(par,'userdata');
	else
		data = [];
	end
	
end


g = handles.all;

g = control_update(par, pal, control, [], data);

%--
% warn and return if we do not find the control
%--

if isempty(g)
	
	warning(['Unable to find control ''' control ''' in parent figure.']);
	
	flag = 0; return;
	
end

%-------------------------------------
% TRY TO EVALUATE CALLBACK
%-------------------------------------

% NOTE: each control contains various uicontrol objects

flag = 0;

for k = 1:length(g)
	
	%--
	% get callback from objects that have callbacks
	%--
		
	% NOTE: for multiple uicontrols with callbacks, the first is evaluated
	
	callback = [];
	
	switch get(g(k),'type')
		
		case 'uicontrol'
			callback = get(g(k), 'callback');
			
		case 'axes'
			callback = get(g(k), 'buttondown');
			
	end
		
	%--
	% continue if no callback
	%--
	
	if isempty(callback)
		continue;
	end
	
	%--
	% evaluate function handle callback
	%--
	
	switch class(callback)
		
		%--
		% function handle based forms
		%--
		
		case 'cell'
			
			% NOTE: separate arguments and callback function handle
			
			args = callback(2:end); callback = callback{1}; 
			
			callback(g(k), [], args{:});
			
		case 'function_handle'
	
			callback(g(k), []);
			
		%--
		% string to evaluate callback
		%--
		
		case 'char', eval(callback);
								
	end
	
end

flag = 1;
