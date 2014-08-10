function control = parameter__control__create(parameter, context)

% RESONANT - parameter__control__create

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
% get parent controls
%--

fun = parent_fun; control = fun(parameter, context);

%--
% create parameter controls
%--

% NOTE: it seems like this is part of the context

nyq = get_sound_rate(context.sound) / 2;

lim = 0.001;

control(end + 1) = control_create(...
	'name', 'center_freq', ...
	'style', 'slider', ...
	'type', 'integer', ...
	'min', lim * nyq, ...
	'max', (1 - lim) * nyq, ...
	'value', parameter.center_freq ...
);

control(end + 1) = control_create(...
	'name', 'width', ...
	'style', 'slider', ...
	'type', 'integer', ...
	'space', 1.5, ...
	'min', lim * nyq, ...
	'max', nyq, ...
	'value', parameter.width ...
);
