function [value, offset] = event_in_page(event, page, sound)

% event_in_page - check whether events are in page
% ------------------------------------------------
%
% [value, offset] = event_in_page(event, page, sound)
%
% Input:
% ------
%  event - event
%  page - page
%  sound - sound
%
% Output:
% -------
%  value - in page indicator
%  offset - time offset direction in relation to page

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

% TODO: consider adding boundary hits and selection information to output

%--------------------
% HANDLE INPUT
%--------------------

% TODO: 'is_proper_page' function, this could be useful for ducks everywhere

%--------------------
% PERFORM TEST
%--------------------

%--
% TIME SELECTION
%--

%--
% get event times
%--

% NOTE: this is the selection case, selection event times are in 'slider' time

if isempty([event.id])
	
	time = event.time;
	
else
	
	% NOTE: logged event times are in 'record' time, page in 'slider' time map!
	
	time = reshape([event.time]', 2, [])';
		
	time = map_time(sound, 'slider', 'record', time);

end

%--
% check page time
%--	

% NOTE: a page struct contains start and duration fields, possibly stop

page.stop = page.start + page.duration;

% NOTE: events can have either end in-page, or can straddle the page

value = ...
	((time(:,1) > page.start) & (time(:,1) < page.stop)) + ... start in-page
	(((time(:,2) > page.start) & (time(:,2) < page.stop)) * 2) + ... end in-page
	(((time(:,1) < page.start) & (time(:,2) > page.stop)) * -1) ...   straddle page
;

% NOTE: collect offset information if needed

if nargout > 1
	
	% NOTE: we use the numerical logical inversion '1 - x', the '~' produces a warning?
	
	offset = 1 - value; offset(time(:, 2) <= page.start) = -1;	
	
end

if ~any(value)
	return;
end

%--
% CHANNEL SELECTION
%--

% NOTE: return if there is no channel selection to be done

if ~isfield(page, 'channel')
	return;
end

if isempty(page.channel)
	return;
end

%--
% get event channels
%--

% NOTE: we convert to integers to use the faster table lookup, note the transpose

channel = uint8([event(value ~= 0).channel])';

%-- 
% check channels and update test
%--

% NOTE: build a channel indicator table considering zero offset

table = zeros(1, length(sound.channels) + 1); table(page.channel + 1) = 1;

% NOTE: this is an interesting use of logical indexing

value(value ~= 0) = value(value ~= 0) .* lut_apply(channel, table);

