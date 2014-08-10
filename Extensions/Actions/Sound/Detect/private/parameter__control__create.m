function control = parameter__control__create(parameter, context)

% DETECT - parameter__control__create

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
% output log name
%--

% TODO: come up with a good default and some tokens

control(end + 1) = control_create( ...
	'name', 'output', ...
	'style', 'edit', ...
	'type', 'filename', ...
	'string', '%SOUND_NAME%_%PRESET_NAME%_%TIME%' ...
);

%--
% detector selection
%--

names = get_detector_names;

ix = find(strcmp(parameter.detector, names));

if isempty(ix)
	ix = 1;
end

% NOTE: the callback for this control updates the preset control

control(end + 1) = control_create( ...
	'name', 'detector', ...
	'width', 2/3, ...
	'style', 'popup', ...
	'string', names, ... 
	'onload', 1, ...
	'value', ix ...
);

%--
% preset selection
%--

control(end + 1) = control_create( ...
	'name', 'preset', ...
	'style', 'listbox', ...
	'space', 1.5, ...
	'max', 2, ...
	'lines', 3 ...
);

% TODO: add some controls to display preset info, include tags and notes?
