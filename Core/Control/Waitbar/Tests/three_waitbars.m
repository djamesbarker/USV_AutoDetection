function pal = three_waitbars(opt)

% TODO: parametrize code with steps colors and pauses

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

%-----------------------------
% HANDLE INPUT
%-----------------------------

N = 2 * [10, 10, 20]; 

if ~nargin
	opt = waitbar_group;
end

%-----------------------------
% DEFINE CONTROLS
%-----------------------------

% NOTE: confirm is used to add time display

%--
% progress bar
%--

% NOTE: having a 'PROGRESS' bar automatically provides updating progress header

% NOTE: for this slow moving and central waitbar we force the update

control = control_create( ...
	'name', 'PROGRESS', ...
	'alias', 'Overall progress bar', ...
	'style', 'waitbar', ...
	'confirm', 1, ...
	'update_rate', [], ...
	'space', 2 ...
);

control(end + 1) = control_create( ...
	'name', 'close_after_completion', ...
	'style', 'checkbox', ...
	'value', 1, ...
	'space', 1 ...
);

%--
% details header
%--

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'string', 'Details' ...
);

%--
% secondary waitbar
%--

control(end + 1) = control_create( ...
	'name', 'Second Bar', ...
	'space', 1.5, ...
	'confirm', 1, ...
	'style', 'waitbar' ...
);

%--
% tertiary waitbar
%--

control(end + 1) = control_create( ...
	'name', 'Third Bar', ...
	'space', 2, ...
	'confirm', 0, ...
	'style', 'waitbar', ...
	'update_rate', 0.25, ...
	'space', 0 ...
);

%-----------------------------
% CREATE WAITBAR
%-----------------------------

name = 'Three Waitbars';

pal = waitbar_group(name, control, [], [], opt);

position_palette(pal, 0, 'center');

%-----------------------------
% UPDATE WAITBAR
%-----------------------------

%---------------
% PROGRESS
%---------------

waitbar_update(pal, 'PROGRESS', 'value', 0);

for i = 1:N(1)

	%---------------
	% SECOND BAR
	%---------------

	c2_initial = [1, 0, 0]; c2_final = [0.75, 1, 0.1];

	waitbar_update(pal, 'Second Bar', 'value', 0, 'color', c2_initial);

	for j = 1:N(2)

		%---------------
		% THIRD BAR
		%---------------

		% NOTE: value is updated for 'Third Bar', also no confirm display

		waitbar_update(pal, 'Third Bar', 'value', 0);

		for k = 1:N(3)
			waitbar_update(pal, 'Third Bar', 'value', k/N(3));
		end

		% NOTE: value and message are updated for 'Second Bar'

		waitbar_update(pal, 'Second Bar', ...
			'value', j/N(2), ...
			'color', (1 - j/N(2)) * c2_initial + (j/N(2)) * c2_final, ...
			'message', ['A relatively long test message #', int2str(j)] ...
		);

	end

	% NOTE: only value of PROGRESS waitbar is updated

	waitbar_update(pal, 'PROGRESS', 'value', i/N(1));

end

%--
% conditionally close waitbar
%--

if get_control(pal, 'close_after_completion', 'value')
	close(pal); return;
end
