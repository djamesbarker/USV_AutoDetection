function control = parameter__control__create(parameter, context)

% SIMPLE RECURSIVE BACKGROUND - parameter__control__create

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

list = {'background', 'signal'};

value = find(strcmpi(parameter.output{1}, list));

if isempty(value)
	value = 2;
end

control(end + 1) = control_create( ... 
	'name', 'output', ... 
	'style', 'popup', ...
	'string', title_caps(list), ...
	'value', value ...
);

control(end + 1) = control_create( ...
	'name', 'half_life', ...
	'alias', 'half-life', ...
	'style', 'slider', ...
	'space', 1.5, ...
	'min', 0, ...
	'max', 2, ...
	'value', 0.05 ...
);
