function figure_resize(par)

% figure_resize - apply figure resize function
% --------------------------------------------
%
% figure_resize(par)
%
% Input:
% ------
%  par - figure handle

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

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% handle input
%--

if any(~ishandle(par))
	error('Input must be handles.');
end

%--
% handle multiple handles recursively
%--

if numel(par) > 1
	
	for k = 1:numel(par)
		figure_resize(par(k));
	end
	
	return;
	
end

%--
% check handle type
%--

if ~strcmp(get(par, 'type'), 'figure')
	return;
end

%---------------------------
% GET AND APPLY RESIZE
%---------------------------

%--
% get figure resize function
%--

fun = get(par, 'resizefcn');

if isempty(fun)
	return;
end

%--
% apply resize function
%--

switch class(fun)
	
	case ('cell'), args = fun(2:end); fun = fun{1}; fun(par, [], args{:});
		
	case ('char'), eval(fun);
		
	case ('function_handle'), fun(par, []);
		
end
