function pos = event_to_position(event)

% event_to_position - get position bounds from event array
% --------------------------------------------------------
%
% pos = event_to_position(event)
%
% Input:
% ------
%  event - event array
%
% Output:
% -------
%  pos - position rows for events

event = struct_field(event, 'time', 'freq');

% NOTE: each row is of the form [left, bottom, width, height]

pos = [event.time(:, 1), event.freq(:, 1), diff(event.time, 1, 2), diff(event.freq, 1, 2)];
