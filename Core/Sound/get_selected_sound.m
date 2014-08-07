function [sound, lib] = get_selected_sound(pal)

% get_selected_sound - get sound selected in XBAT palette
% -------------------------------------------------------
%
% [sound, lib] = get_selected_sound(pal)
%
% Input:
% ------
%  pal - palette
%
% Output:
% -------
%  sound - sound
%  lib - library containing sound

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
% initialize output
%--

lib = get_active_library;

%--
% check for XBAT palette
%--

if ~nargin || isempty(pal)
	pal = get_palette(0, 'XBAT');
end

% NOTE: no palette no selection

if isempty(pal)
	sound = []; return;
end

%--
% get selected sounds in XBAT palette
%--

name = get_control(pal, 'Sounds', 'value'); sound = {};

for k = 1:length(name)

	try
		contents = sound_load(lib, name{k}); sound{k} = contents.sound;
	catch
		nice_catch(lasterror, ['Problem loading sound ''', name{k}, '''.']);
	end

end

sound = [sound{:}];

