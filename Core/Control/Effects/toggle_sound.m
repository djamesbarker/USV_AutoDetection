function toggle_sound(action,name)

% toggle_sound - produce sound to indicate palette toggle action
% --------------------------------------------------------------
%
% toggle_sound(action,name)
%
% Input:
% ------
%  action - toggle action, 'open' or 'close'
%  name - toggle sound

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
% $Revision: 1160 $
% $Date: 2005-07-05 14:55:22 -0400 (Tue, 05 Jul 2005) $
%--------------------------------

% TODO: control sounds using configuration variables and preferences dialog

% TODO: consider where to check for audio devices

%---------------------------
% HANDLE INPUT AND SETUP
%---------------------------

%--
% return if palette sounds are not on
%--

value = get_env('palette_sounds');

if ~isequal(value,'on')
	return;
end

%--
% set default name
%--

if (nargin < 2)
	name = 'default';
end

%--
% set default action
%--

% NOTE: not used yet

% if (nargin < 1)
% 	action = 'open';
% end

%--
% set persistent stores
%--

persistent TOGGLE_NAME TOGGLE_SIGNAL;

if (isempty(TOGGLE_NAME))
	TOGGLE_NAME = 'default';
end

%---------------------------
% PRODUCE SOUND
%---------------------------

if (~strcmp(name,TOGGLE_NAME) || isempty(TOGGLE_SIGNAL))

	%--
	% create waveform
	%--
	
	switch (name)

		%--
		% default sound
		%--

		case ('default')

			n = 128; 
			
			X = linspace(0,0.1,n);
						
			X = 0.5 * X .* (1 - X) .* filter(ones(1,9) ./ 9, [0.5 zeros(1,16) 0.1 0 0.1], rand(1,n));
			
		%--
		% error
		%--

		% NOTE: no sound for unknown sound name, consider some display

		otherwise, return;

	end

	%--
	% store waveform
	%--
	
	TOGGLE_SIGNAL = X;
	
end

%--
% play sound
%--

if ispc
    wavplay(TOGGLE_SIGNAL,'sync');
end

