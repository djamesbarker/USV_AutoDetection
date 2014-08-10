function export = prepare_csv_event(event, context)

% NOTE: this function prepares an export event that we can use 'struct_to_csv' on

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

% TODO: consider providing a field selection control for this operation

export = struct;

%--
% parent log and id
%--

export.log = context.log;

export.id = event.id;

%--
% channel, time, and frequency information
%--

% channel

export.channel = event.channel;

% time

% TODO: ensure that the context is right to get the real time

export.real_start = get_browser_time_string([], event.time(1), context)';

export.real_stop = get_browser_time_string([], event.time(2), context)';

export.record_start = event.time(1); export.record_stop = event.time(2);

export.duration = diff(event.time);

% frequency

export.min_freq = event.freq(1); export.max_freq = event.freq(2);

export.bandwidth = diff(event.freq);

%--
% metadata
%--

export.score = event.score; export.rating = event.rating;

export.tags = event.tags; export.notes = event.notes;

%--
% file reference
%--

% NOTE: these lines were added to provide explicit file reference information


%--- MSP - fix bug active when time stamp attribute set

fix_sound = context.sound;

fix_sound.time_stamp = [];

fix_sound.attributes = [];

export.file = get_current_file(fix_sound, event.time(1));

export.file_time = event.time(1) - get_file_times(fix_sound, export.file);


% export.file = get_current_file(context.sound, event.time(1));
% 
% export.file_time = event.time(1) - get_file_times(context.sound, export.file);

%--- end MSP
