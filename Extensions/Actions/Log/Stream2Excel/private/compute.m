function [result, context] = compute(log, parameter, context)
%Stream2Excel - Compute:
%Takes a log from a filestream and makes an excel file for each sound
%within the Stream log

if ischar(log.sound.file) || iscellstr(log.sound.file) == 1 %Make sure the name of the file is a string
    [starttime duration] = get_file_times(log.sound); %Function that outputs start time of each sound and its duration
    x = length(log.sound.file);
    
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
else %If the sound file name is not a string, events won't get file names and this code cannot run
    %This code should be modified in the future to work around this problem
    error('Error: Sound File Name (located in log structure: log.sound.file) is not a string');
end

result = log;

%% Make Duplicate Logs where each log has events from only one sound file
% (Only certain fields really need to be changed i.e. event, sound, length, curr_id)

cd(log.path(1:end-5));
mkdir('Output Logs');
Rav_dir = [log.path(1:end-5) 'Output Logs'];

for i=1:length(result.sound.file)
    [~,file_name]=fileparts(result.sound.file{i});
    Rav_name=[file_name];
    
write_data = {}; write_data{1} = 'Selection';
write_data{2} = 'View'; write_data{3} = 'Channel';
write_data{4} = 'Begin Time (s)'; write_data{5} = 'End Time (s)';
write_data{6} = 'Low Freq (Hz)'; write_data{7} = 'High Freq (Hz)';
write_data{8} = 'Peak Freq (Hz)';write_data{9} = 'Peak Time (Hz)';
    
    
    %Rav_name = [result.sound.file{i}(1:end-8) '.txt'];
    cd(log.path);
    tmp_log = result;
    tmp_log.file = [result.sound.file{i}(1:end-8) '.mat'];
    tmp_log.sound.samples = result.sound.samples(i);
    tmp_log.sound.file = result.sound.file(i);
    tmp_log.sound.cumulative = result.sound.cumulative(i);
    tmp_log.sound.time_stamp = result.sound.time_stamp(i);
    tmp_log.sound.fileduration = result.sound.fileduration(i);
    
    tmp_log.event = struct;
    event_idx = [];
    for j=1:length(result.event)
        if strcmp(result.sound.file(i),result.event(j).file) == 1
            event_idx = [event_idx j];
        end
    end
    
    tmp_log.event = result.event(min(event_idx):max(event_idx));
    for k=1:length(event_idx)
        tmp_log.event(k).time = (tmp_log.event(k).time - result.sound.time_stamp(i));
        tmp_log.event(k).id = k;
    end
    tmp_log.length = length(tmp_log.event);
    tmp_log.curr_id = 1;
    
    for a=1:length(tmp_log.event)
        write_data{a+1,1} = a;
        write_data{a+1,2} = 'Spectrogram 1'; write_data{a+1,3} = 1;
        write_data{a+1,4} = tmp_log.event(a).time(1); write_data{a+1,5} = tmp_log.event(a).time(2);
        write_data{a+1,6} = tmp_log.event(a).freq(1); write_data{a+1,7} = tmp_log.event(a).freq(2);
        write_data{a+1,8} = tmp_log.event(a).peakHz;
        write_data{a+1,9} = tmp_log.event(a).peakTime;
        
    end
    
    cd(Rav_dir);
    xlswrite([Rav_name '.xls'],write_data)
%% Original Stream2Raven Output Code   
%     dlmwrite(Rav_name,'');  %Create text file to write to
%     Rav_ID = fopen(Rav_name,'w');   %Open the text file we just made
%     fprintf(Rav_ID,'%s \t',write_data{1,1},write_data{1,2},write_data{1,3},write_data{1,4},write_data{1,5},write_data{1,6});
%     fprintf(Rav_ID,'%s \n',write_data{1,7});
%     for b = 2:(length(tmp_log.event)+1)
%         fprintf(Rav_ID,'%1.0f\t %s\t %1.0f\t %3.21f\t %3.21f\t %5.23f\t %5.23f\n',...
%             write_data{b,1},write_data{b,2},write_data{b,3},write_data{b,4},write_data{b,5},write_data{b,6},write_data{b,7});
%     end
end

    

    
end

