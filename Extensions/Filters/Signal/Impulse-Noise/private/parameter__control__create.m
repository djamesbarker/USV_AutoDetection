function control = parameter__control__create(parameter, context)

% IMPULSE-NOISE - parameter__control__create

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

control = empty(control_create);

%--
% type
%--

types = get_impulse_types;

[known, ix] = ismember(parameter.type{1}, types);

if ~known
	error('Unknown impulse type.');
end

control(end + 1) = control_create( ...
	'name', 'type', ...
	'style', 'popup', ...
	'string', title_caps(types), ...
	'value', ix ...
);

%--
% percent
%--

control(end + 1) = control_create( ...
	'name', 'percent', ...
	'style', 'slider', ...
	'min', 0, ...
	'max', 100, ...
	'value', parameter.percent, ...
	'space', 1.5 ...
);
