function ext = extension_inherit(par)

% extension_inherit - create extension from parent
% ------------------------------------------------
%
% ext = extension_inherit(par)
%
% Input:
% ------
%  par - parent name
%
% Output:
% -------
%  ext - new child extension

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% get caller and computable fields
%--

caller = get_caller;

if (~isempty(caller))
	
	% NOTE: these 'get' functions are all private because of the fragility of stack use
	
	type = get_type(caller);
	
	name = get_name(caller);
	
	info = get_info(caller); modified = info.date;
	
	main = get_main(caller);

else
	
	type = []; name = ''; modified = ''; main = [];
	
end

%--
% check parent type
%--

if (~strcmp(par.subtype,type))
	error('Parent and child must have the same type.');
end

%-------------------------------------------------
% CREATE EXTENSION
%-------------------------------------------------

%--
% copy parent
%--

ext = par;

%--
% save link to parent
%--

% NOTE: storing name and handle to parent allows multiple ways of access

ext.parent.name = par.name;

ext.parent.main = par.fun.main;

%--
% update functions
%--

% NOTE: we update parent functions with new available functions, inheritance

fun = flatten_struct(ext.fun);

fun_new = flatten_struct(attach_fun(main,type));

field = fieldnames(fun_new);

for k = 1:length(field)
	
	if (isfield(fun,field{k}) && ~isempty(fun_new.(field{k})))
		fun.(field{k}) = fun_new.(field{k});
	end
	
end

ext.fun = unflatten_struct(fun);

%--
% update relevant fields
%--

ext.name = name;

ext.modified = modified;

ext.fun.main = main;

