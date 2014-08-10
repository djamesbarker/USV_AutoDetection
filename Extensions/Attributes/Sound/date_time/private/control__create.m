function control = control__create(attribute, context)

% DATE_TIME - control__create

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

string = datestr(attribute.datetime, 0);

control(end + 1) = control_create( ...
	'name', 'get_from_files', ...
	'style', 'buttongroup', ...
	'lines', 1.5, ...
	'width', 0.5, ...
	'space', -0.5, ...
	'align', 'right' ...
);

control(end + 1) = control_create( ...
	'style', 'edit', ...
	'name', 'datetime', ...
	'string', string ...
);
	
		
