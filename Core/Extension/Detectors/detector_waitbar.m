function pal = detector_waitbar(context)

% detector_waitbar - create detection waitbar
% --------------------------------------
%
% pal = detector_detect_wait(context)
%
% Input:
% ------
%  context - detector context
%
% Output:
% -------
%  pal - waitbar palette handle

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
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

name = [context.ext.name, ' - ', sound_name(context.sound)];

pal = find_waitbar(name);

if ~isempty(pal)
	return;
end

%-------------------------------------------------
% WAITBAR CONTROLS
%-------------------------------------------------

control = control_create( ...
	'name', 'PROGRESS', ...
	'style', 'waitbar', ...
	'units', context.scan.duration, ...
	'confirm', 1, ...
	'lines', 1.15, ...
	'space', 2 ...
);

control(end + 1) = control_create( ...
	'name', 'close_after_completion', ... 
	'style', 'checkbox', ...
	'space', 0.75, ...
	'value', 1 ...
);

control(end + 1) = control_create( ...
	'string', 'Details', ...
	'style', 'separator', ...
	'type', 'header' ...
);

% NOTE: serves as text display for results of detection

control(end + 1) = control_create( ...
	'name', 'events', ...
	'lines', 8, ...
	'space', 1, ...
	'confirm', 0, ...
	'style', 'listbox' ...
);
	
%-------------------------------------------------
% CREATE WAITBAR
%-------------------------------------------------

%--
% setup waitbar
%--

opt = waitbar_group; opt.show_after = 1;

if ~isempty(context.par)
	par = context.par; pos = 'bottom right';
else
	par = 0; pos = 'center';
end

%--
% create waitbar
%--

pal = waitbar_group(name, control, par, pos, opt);

