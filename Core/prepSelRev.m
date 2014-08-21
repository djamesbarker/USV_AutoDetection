function result = prepSelRev(log,fs,answer,pad)

for i=1:length(log.event)
    disp(['Currently Analyzing Event: ' num2str(i)]);
    file_idx = strcmp(log.sound.file,log.event(1,i).file);
    
    sound_file = fullfile(log.sound.path,log.event(1,i).file);
    sample_bounds = round(log.event(i).SR_time*fs);
    sample_freq=[0 fs];
    
    if ((sample_bounds(1)-pad) > 0) && ((sample_bounds(2)+pad) < (log.sound.fileDuration(file_idx)*fs))
        event_clip = wavread(sound_file, [(sample_bounds(1)-pad) (sample_bounds(2)+pad)]);
    elseif (sample_bounds(1)-pad) < 0
        event_clip = wavread(sound_file, [sample_bounds(1) (sample_bounds(2)+pad)]);
        warning(['No Pad Added to Start of Event ' num2str(i)]);
    else
        event_clip = wavread(sound_file, [(sample_bounds(1)-pad) log.sound.fileDuration(file_idx)*fs]);
        warning(['No Pad Added to End of Event ' num2str(i)]);
    end
    
    %Butterworth filter set for USVs
    [b,a]=butter(3,[str2double(answer{2})+0.1 str2double(answer{3})-0.1]/(fs/2),'bandpass');
    event_clip2=filter(b,a,event_clip);
    [B, freq, time] = fast_specgram(event_clip2, fs, 'norm',log.sound.specgram);
    
    %  PLOT EVENTS HERE IF NEEDED DURING TROUBLESHOOTING
    %     newImage = imadjust(B, [0 1], [.9 1]);
    %     figure;imagesc(newImage);
    %     set(gca,'Ydir','normal');
    %     shading flat;
    
    log.playback{i}=event_clip;
    log.playspeed=.05;
    log.contrast= [0 .01];
    log.brightness=[0 1];
    log.playsample=sample_freq;
    log.clips{i}=abs(B);
    log.noise{i}=mean(mean(B(200:257,:)));
    log.freq{i}=freq;
    log.time{i}=time;
end

result=log;