function callback = get_computed_callback(control,fun,pal,par,opt)

% get_computed_callback - compute control callback
% ------------------------------------------------
%
% control = get_computed_callback(control,fun,pal,par,opt)
%
% Input:
% ------
%  control - control
%  pal - control palette
%  par - palette parent
%  opt - palette options 
%
% Output:
% -------
%  callback - computed control callback

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
% $Revision: 3397 $
% $Date: 2006-02-03 19:55:30 -0500 (Fri, 03 Feb 2006) $
%--------------------------------

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% handle grouped controls recursively
%--

if (iscell(control.name))

	%--
	% create a callback for each control
	%--
	
	name = control.name; 
	
	callback = cell(size(name));

	%--
	% check for direct callback
	%---
	
	if (isempty(control.callback))
		
		%--
		% handle callback handler case recursively
		%--

		for k = 1:numel(name)
			control.name = name{k}; callback{k} = get_computed_callback(control,fun,pal,par,opt);
		end

	else
		
		%--
		% handle direct callbacks recursively
		%--

		call = control.callback;
		
		if (~iscell(call))

			% NOTE: single callback for all controls
			
			for k = 1:numel(name)
				control.name = name{k}; callback{k} = get_computed_callback(control,fun,pal,par,opt);
			end
			
		else

			% NOTE: individual callbacks
			
			for k = 1:numel(name)
				control.name = name{k}; control.callback = call{k};
				callback{k} = get_computed_callback(control,fun,pal,par,opt);
			end
	
		end

	end
	
	return;
	
end

%---------------------------------------------
% COMPUTE CALLBACK
%---------------------------------------------

%--
% control callback is set directly
%--

if (~isempty(control.callback))
	callback = control.callback; return;
end

%--
% return empty on empty palette callback
%--

if (isempty(fun))
	callback = []; return;
end

%--
% palette callback follows mathworks function handle callback framework
%--

if (isa(fun,'function_handle') || (iscell(fun) && isa(fun{1},'function_handle')))	
	callback = fun; return;
end

%--
% old string callbacks
%--

% NOTE: create function part of callback

pal_name = get(pal,'name');

if (opt.handle_to_callback)

	if (opt.palette_to_callback)
		callback = [fun '(' num2str(par), ',''', pal_name, '::', control.name, ''',__HANDLE__);'];
	else
		callback = [fun '(' num2str(par), ',''', control.name, ''',__HANDLE__);'];
	end

else

	if (opt.palette_to_callback)
		callback = [fun '(' num2str(par), ',''', pal_name, '::', control.name, ''');'];
	else
		callback = [fun '(' num2str(par), ',''', control.name, ''');'];
	end

end

% NOTE: add parent focus handling to callback

if (~isempty(par))

	par_focus = ['set(0,''currentfigure'',', num2str(par), ');'];

	pal_focus = ['set(0,''currentfigure'',', num2str(pal), ');'];

	callback = [par_focus, ' ', callback, ' ', pal_focus];

end
