function [start, stop, duration] = event_time_str(event, sound, mode, format)

if nargin < 4
    format = 'yyyymmddTHHMMSS.FFF';
end

if nargin < 3
    mode = 'datetime';
end

if nargin < 2
    mode = 'clock'; sound = [];
end

if ~isempty(sound)
    
    if isempty(sound.realtime)
        mode = 'clock';
    end

    event.time = map_time(sound, 'real', 'record', event.time);

end

switch mode
    
    case 'sec'
        
        start = num2str(event.time(1));
        
        stop = num2str(event.time(2));
        
        duration = num2str(diff(event.time));
        
    case 'clock'
        
        start = sec_to_clock(event.time(1));
        
        stop = sec_to_clock(event.time(2));
        
        duration = sec_to_clock(diff(event.time));  
        
    case 'datetime'
        
        time = (event.time ./ 86400) + sound.realtime;
        
        start = datestr(time(1), format);
        
        stop = datestr(time(2), format);
        
        duration = sec_to_clock(diff(event.time));
        
end
        
