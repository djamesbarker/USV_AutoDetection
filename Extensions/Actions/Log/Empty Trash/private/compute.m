function [result, context] = compute(log, parameter, context)

% EMPTY TRASH - compute

result = struct;

%--
% check if log is open and there are deleted events to clear
%--

if log_is_open(log)
    disp(['Close log ''', log_name(log), ' before emptying trash.']); return;
end

if isempty(log.deleted_event)
    return;
end

%--
% clear deleted events and save log
%--

log.deleted_event = empty(event_create);

log_save(log);

