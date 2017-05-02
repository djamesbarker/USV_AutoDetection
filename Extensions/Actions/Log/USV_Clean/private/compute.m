function [result, context] = compute(log, parameter, context)

% USV_CLEAN - compute


for i=1:length(log.event);
   data(i,1:2)=log.event(i).time(1:2);
   data(i,3:4)=log.event(i).freq(1:2);
end

newlog=[];
data(:,5)=0;
for i=1:length(data(:,1))
if data(i,5)==1
else
    currtime=data(i,1);
    currtime2=data(i,2);
    data(:,5)= ...
        data(:,1)>=currtime & data(:,1)<=currtime2|...
        data(:,2)>=currtime & data(:,2)<=currtime2|...
        data(:,1)<=currtime & data(:,2)>=currtime|...
        data(:,1)<=currtime2 & data(:,2)>=currtime2;
        
    tmp=data(data(:,5)==1,:);
    
    newlog(end+1,1)=min(tmp(:,1));
    newlog(end,2)=max(tmp(:,2));
    newlog(end,3)=min(tmp(:,3));
    newlog(end,4)=max(tmp(:,4));
    newlog(end,5)=i;
end
end

result=log;
[savename pathname]=uiputfile([result.path '*.mat']);
result.file=savename;

if length(newlog(:,1))>1
for i=1:length(newlog(:,1))
event(i).id=i;
event(i).tags=log.event(newlog(i,5)).tags;
event(i).rating=log.event(newlog(i,5)).rating;
event(i).notes=log.event(newlog(i,5)).notes;
event(i).score=log.event(newlog(i,5)).score;
event(i).channel=log.event(newlog(i,5)).channel;
event(i).time(1,1:2)=newlog(i,1:2);
event(i).freq(1,1:2)=newlog(i,3:4);
event(i).duration=newlog(i,2)-newlog(i,1);
event(i).bandwidth=newlog(i,4)-newlog(i,3);
event(i).samples=log.event(newlog(i,5)).samples;
event(i).rate=log.event(newlog(i,5)).rate;
event(i).level=log.event(newlog(i,5)).level;
event(i).children=log.event(newlog(i,5)).children;
event(i).parent=log.event(newlog(i,5)).parent;
event(i).author=log.event(newlog(i,5)).author;
event(i).created=log.event(newlog(i,5)).created;
event(i).modified=log.event(newlog(i,5)).modified;
event(i).userdata=log.event(newlog(i,5)).userdata;
event(i).detection=log.event(newlog(i,5)).detection;
event(i).annotation=log.event(newlog(i,5)).annotation;
event(i).measurement=log.event(newlog(i,5)).measurement;
end
else 
error('No events in log,No action taken')
return
end    


%% Second run

result.event=event;
result.length=length(event);
result.curr_id=1;
log=result;

data=[];
for i=1:length(log.event);
   data(i,1:2)=log.event(i).time(1:2);
   data(i,3:4)=log.event(i).freq(1:2);
end

newlog=[];
data(:,5)=0;
for i=length(data(:,1)):-1:1;
if data(i,5)==1
else
    currtime=data(i,1);
    currtime2=data(i,2);
    data(:,5)=...
        data(:,1)>=currtime & data(:,1)<=currtime2|...
        data(:,2)>=currtime & data(:,2)<=currtime2|...
        data(:,1)<=currtime & data(:,2)>=currtime|...
        data(:,1)<=currtime2 & data(:,2)>=currtime2|...
        ...Edit added here to help reduce double detections
        ...Events within 10ms of one another are now combined
        data(:,1)>=currtime2 & data(:,2)<=currtime2+0.03|...
        data(:,2)>=currtime-0.03 & data(:,2)<=currtime;
    
    tmp=data(data(:,5)==1,:);
    
    newlog(end+1,1)=min(tmp(:,1));
    newlog(end,2)=max(tmp(:,2));
    newlog(end,3)=min(tmp(:,3));
    newlog(end,4)=max(tmp(:,4));
    newlog(end,5)=i;
end
end

result=log;
clear event
for i=1:length(newlog (:,1))
event(i).id=i;
event(i).tags=log.event(newlog(i,5)).tags;
event(i).rating=log.event(newlog(i,5)).rating;
event(i).notes=log.event(newlog(i,5)).notes;
event(i).score=log.event(newlog(i,5)).score;
event(i).channel=log.event(newlog(i,5)).channel;
event(i).time(1,1:2)=newlog(i,1:2);
event(i).freq(1,1:2)=newlog(i,3:4);
event(i).duration=newlog(i,2)-newlog(i,1);
event(i).bandwidth=newlog(i,4)-newlog(i,3);
event(i).samples=log.event(newlog(i,5)).samples;
event(i).rate=log.event(newlog(i,5)).rate;
event(i).level=log.event(newlog(i,5)).level;
event(i).children=log.event(newlog(i,5)).children;
event(i).parent=log.event(newlog(i,5)).parent;
event(i).author=log.event(newlog(i,5)).author;
event(i).created=log.event(newlog(i,5)).created;
event(i).modified=log.event(newlog(i,5)).modified;
event(i).userdata=log.event(newlog(i,5)).userdata;
event(i).detection=log.event(newlog(i,5)).detection;
event(i).annotation=log.event(newlog(i,5)).annotation;
event(i).measurement=log.event(newlog(i,5)).measurement;
end


result.event=event;
result.length=length(event);
result.curr_id=1;
log_save(result);


result = struct;
