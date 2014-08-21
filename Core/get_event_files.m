function result = get_event_files(log)

[starttime, duration]=get_file_times(log.sound);
log.sound.startTime=[]; log.sound.fileDuration=[];

if ~iscellstr(log.sound.file)
    len=1;
else
    len=length(log.sound.file);
end
for i=1:len
    log.sound.startTime(i)=starttime(i);
    log.sound.fileDuration(i)=duration(i);
end

for i=1:length(log.event)
    if len==1
        log.event(1,i).file=log.sound.file;
        log.event(1,i).SR_time=log.event(1,i).time;
    else
        tmp=log.event(1,i).time(1);
        I=find(tmp>log.sound.startTime,1,'last');
        log.event(1,i).file=log.sound.file{I};
        log.event(1,i).SR_time=log.event(1,i).time-...
            log.sound.startTime(find(strcmp(log.sound.file,log.event(1,i).file)));
    end
end
 result=log;