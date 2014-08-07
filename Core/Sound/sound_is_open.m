function [value, par] = sound_is_open(sound, lib)

% sound_is_open - test if a sound is open
% ---------------------------------------
%
% [value, par] = sound_is_open(sound, lib)
%
% sound_is_open(par)
% 
% Input:
% ------
%  sound - sound or name
%
% Output:
% -------
%  par - handle to open sound browser

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
% Author: Matt Robbins, Harold Figueroa
%--------------------------------
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%-------------------
% SETUP
%-------------------

%--
% create persistent sounds opening list
%--

persistent OPENING_SOUNDS;

if isempty(OPENING_SOUNDS)
	OPENING_SOUNDS = {};
end

%-------------------
% HANDLE INPUT
%-------------------

%--
% for browser tag input, declare sound to be opening
%--

if ischar(sound)
	OPENING_SOUNDS{end + 1} = sound; value = 1; par = []; return;
end

%--
% parent handle is input declare sound open
%--

if ishandle(sound)
	
	par = sound; 
	
	OPENING_SOUNDS = setdiff(OPENING_SOUNDS, get(par, 'tag')); 
	
	value = 1; return;

end

%--
% set library
%--

if nargin < 2
	lib = get_active_library;
end

%-------------------
% CHECK FOR OPEN
%-------------------

%--
% check for opening
%--

tag = browser_tag(sound, lib, get_active_user);

if ismember(tag, OPENING_SOUNDS)
	value = 1; par = []; return;
end

%--
% get open sound browsers
%--

handles = get_xbat_figs('type', 'sound');

%--
% look for one with this sound
%--

par = [];

for k = 1:length(handles)
	
	handle = handles(k);
	
	info = parse_browser_tag(get(handle, 'tag')); 
	
	if ~strcmp(info.sound, sound_name(sound)) || ~strcmp(info.library, get_library_name(lib))
		continue;
	end
	
	par(end + 1) = handle;
	
end

%--
% answer question
%--

value = ~isempty(par);
