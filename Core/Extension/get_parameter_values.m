function [param, values] = get_parameter_values(pal, type)

% get_parameter_values - get extension parameter values from controls
% -------------------------------------------------------------------
%
% [param,values] = get_parameter_values(pal, ext)
%                = get_parameter_values(pal, type)
%
% Input:
% ------
%  pal - parent figure handle
%  ext - extension structure
%  type - type of extension
%
% Output:
% -------
%  param - parameter values reflecting control states
%  values - palette control values

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
% $Revision: 6335 $
% $Date: 2006-08-28 18:03:45 -0400 (Mon, 28 Aug 2006) $
%--------------------------------

%-------------------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------------------

%--
% handle extension type input
%--
	
if isstr(type)
	
	% NOTE: extension name is palette name

	ext = get_extensions(type, 'name', get(pal, 'name'));

	if (length(ext) ~= 1)
		error('Unable to find extension using palette name.'); 	
	end
	
%--
% extension input
%--

else
	
	ext = type;
	
end

%-------------------------------------------------------------
% GET PARAMETER VALUES
%-------------------------------------------------------------

%--
% get control values from palette
%--

values = get_control_values(pal);

%--
% get parameters from create function
%--

% NOTE: this will change as interfaces develop

try
	fun = ext.fun.parameter.create;
catch
	fun = ext.fun.parameter_create;
end

% NOTE: return if there are no parameters

if isempty(fun)
	param = []; return;
end

%--
% get context from parent
%--

par = get_xbat_figs('child', pal); 

if isempty(par)
	context = [];
else
	context.sound = get_field(get(par, 'userdata'), 'browser.sound', []);
end

param = fun(context); 

%--
% update parameter values using palette values
%--

% TODO: update to use 'struct_update'

param_fields = fieldnames(param);

fields = fieldnames(values);

% NOTE: we update parameter fields that match value fields

for k = 1:length(param_fields)
	
	ix = find(strcmp(param_fields{k},fields));

	if ~isempty(ix)
		param.(fields{ix}) = values.(fields{ix});
	end

end
