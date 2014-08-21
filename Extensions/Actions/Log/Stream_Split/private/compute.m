function [result, context] = compute(log, parameter, context)

%Stream Split - Compute:
%Takes a log from a filestream and makes a log for each sound file in the
%filestream with events specific to that sound file only
%Logs are named the same as the individual sound files

result = get_event_files(log);

%% Make Duplicate Logs where each log has events from only one sound file
% (Only certain fields really need to be changed i.e. event, sound, length, curr_id)
cd(log.path);
for i=1:length(result.sound.file)
    tmp_log = result;
    tmp_log.file =  [result.sound.file{i}(1:strfind(result.sound.file{i},'.')) 'mat'];
    
    tmp_log.event = struct;
    event_idx = [];
    for j=1:length(result.event)
        if strcmp(result.sound.file(i),result.event(j).file)
            event_idx = [event_idx j];
        end
    end
    
    tmp_log.event = result.event(min(event_idx):max(event_idx));
    tmp_log.length = length(tmp_log.event);
    tmp_log.curr_id = 1;
    log = tmp_log;
    log_save(log);
    
end