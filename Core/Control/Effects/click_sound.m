function click_sound

% click_sound - generate a "click" (like the iPod wheel noise)
% ------------------------------------------------------------
%
% Usage: click_sound

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

return;

persistent data

%--
% return if there are no sounds
%--

value = get_env('palette_sounds');

if ~isequal(value,'on')
	return;
end

%--
% play sound
%--

if ~isempty(data)
	wavplay(data,'async');	return;
end

%--
% create sound
%--

data = randn(1, 100);

data = 0.04 * filter([1, -1], [1 0 -0.8], data);
