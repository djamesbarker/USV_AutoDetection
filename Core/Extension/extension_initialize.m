function ext = extension_initialize(ext, context)

% extension_initialize - set extension parameters using context
% -------------------------------------------------------------
%
% ext = ext_initialize(ext, context)
%
% Input:
% ------
%  ext - extensions
%  context - context
%
% Output:
% -------
%  ext - initialized extensions

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
% loop over input extensions and initialize
%--

for k = 1:length(ext)

	% NOTE: this exception handler picks up mostly extension type problems

	try
		ext(k) = extension_initialize_int(ext(k), context);
	catch
		extension_warning(ext, 'Failed to initialize extension', lasterror);
	end

end


function ext = extension_initialize_int(ext, context)

%--------------------
% INITIALIZE
%--------------------

%--
% extract functions and update context
%--

fun = ext.fun; context.ext = ext;

%--
% consider that we may not have parameters to initialize
%--

% TODO: there is not a clear understanding of initialization, are there other types

if ~isfield(fun, 'parameter')
	return;
end

% NOTE: what follows seems to rely on the use of 'param_fun'

%--
% create default parameters if needed
%--

if ~isempty(fun.parameter.create)

	try
		ext.parameter = fun.parameter.create(context);
	catch
		extension_warning(ext, 'Parameter creation failed.', lasterror); return;
	end

end

%--
% compile parameters if needed
%--

% NOTE: compilation should typically create new fields not clobber parameter fields

if ~isempty(fun.parameter.compile)

	try
		ext.parameter = fun.parameter.compile(ext.parameter, context);
	catch
		extension_warning(ext, 'Parameter compilation failed.', lasterror); return;
	end

end

%--
% set control values if needed
%--

if ~isempty(fun.parameter.control.create)
	
	% TODO: implement a better way of setting initial control values

	ext.control = ext.parameter;
	 
end

