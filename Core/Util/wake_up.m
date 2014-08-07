function timers = wake_up

% wake_up - application by restarting timers
% ------------------------------------------
%
% wake_up
%
% See also: timerfind

timers = timerfind;

stop(timers); start(timers);
