function event = get_noise_events(parameter, context)

% get_noise_events - get noise events relevant to context
% -------------------------------------------------------
%
% event = get_noise_events(parameter, context)
%
% Input:
% ------
%  parameter - parameter struct
%  context - context
%
% Output:
% -------
%  event - relevant noise events

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

% NOTE: this is called from the compilation function, it is context heavy!

event = empty(event_create);

%--
% get noise log
%--

log = get_noise_log(parameter, context);

if isempty(log)
	return;
end

%--
% get page-relevant noise-events
%--

event = log.event; 

page = context.page;

event([event.channel] ~= page.channels) = [];

[in_page, offset] = event_in_page(event, page, context.sound);

% NOTE: we can use events in page

if any(in_page)
	event(~in_page) = []; return;
end

% NOTE: we will use events near to page, this can be trickier than it seems

time = struct_field(event, 'time');

[ignore, ix1] = max(time(offset < 0, 2));

before = event([offset < 0]);

[ignore, ix2] = min(time(offset > 0, 1));

after = event([offset > 0]);

event = [before(ix1), after(ix2)];

