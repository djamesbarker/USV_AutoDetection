function [result, log] = compute(log, parameter, context)

% GETFILES - compute

%Get Start Time and Duration for each File in Filestream
if ischar(log.sound.file) == 1
    starttime = 0;
    duration = get_sound_duration(log.sound);
    x = 1;
else
    [starttime duration] = get_file_times(log.sound);
    x = length(log.sound.file);
end

log.sound.time_stamp=[];log.sound.fileduration=[];
for p = 1:x
    log.sound.time_stamp(p) = starttime(p);
    log.sound.fileduration(p) = duration(p);
end

for r=1:length(log.event)
    log.event(1,r).file = [];
    if x == 1
        log.event(1,r).file = log.sound.file;
    else
    temp = log.event(1,r).time(1);
    I = find(temp > log.sound.time_stamp,1,'last');
    log.event(1,r).file = log.sound.file{I};
    end
end

temp_event = log.event;
for q=1:length(log.event);
    log.event(q) = temp_event(end+1-q);
end

result = log;
[savename pathname]=uiputfile([result.path '*.mat']);
result.file = savename;
log_save(result)

result = struct;
