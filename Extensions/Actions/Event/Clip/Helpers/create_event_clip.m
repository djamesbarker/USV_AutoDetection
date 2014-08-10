function create_event_clip(sound, event, file, pad, taper)

if nargin < 5 
    taper = 0;
end

if nargin < 4 || isempty(pad)
    pad = 0;
end

%--
% read samples if necessary
%--

if pad || isempty(event.samples)
    event = event_sound_read(event, sound, pad, taper);
end
    
%--
% write file
%--

sound_file_write(file, event.samples(:), event.rate);



