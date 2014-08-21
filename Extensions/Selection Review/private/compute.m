%% TO DO:
%- Add brightness/contrast to images
%- Use inputbox for butterworth bandpass frequencies

%%
function [result, context] = compute(log, parameter, context)
% Selection Review - compute
% Written by David Barker as an extension for XBAT.
% Co-Authored by Sara Keen. Thanks for the Help!
% XBAT is protected by Copyright (C) 2002-2012 Cornell University


%Number of bins =(FFT length/2)+1
%Resolution is actually just Fs/N (sampling/# of FFT)
FFT_Len=log.sound.specgram.fft;
Fs=log.sound.samplerate;
spect_res=Fs/FFT_Len;
sound_file = fullfile(log.sound.path,log.sound.file);

%% TO DO: Add Dialog to allow the user to set the buffer around calls and playback speed!!!!!!!!!!!!!!!!!
defAns = {'0.05' '18000' '80000'};
prompt={'Amount of time(s) to pad around each selection','Low Freq for BandPass',...
    'High Freq for BandPass'};
answer = inputdlg(prompt,'Settings:',1,defAns);
pad = abs(str2num(answer{1}))*Fs;
%%
log.playback={};
%Creates the spectrogram for each identified clip found in the log file
for i=1:length(log.event)
    sample_bounds = round(log.event(i).time*Fs);
    %sample_freq= round(log.event(i).freq);
    sample_freq=[0 Fs];
    sample_bins=round(sample_freq/spect_res);
    if (sample_bounds(1)-pad) > 0
    event_clip = wavread(sound_file, [sample_bounds(1)-pad sample_bounds(2)+pad]);
    else
        event_clip = wavread(sound_file, [sample_bounds(1) sample_bounds(2)]);
        warning('No Pad Added');
    end
    %Butterworth filter set for USVs
    [b,a]=butter(3,[str2num(answer{2})+0.1 str2num(answer{3})-0.1]/(Fs/2),'bandpass');
    event_clip2=filter(b,a,event_clip);
    [B, freq, time] = fast_specgram(event_clip2, Fs, 'norm',log.sound.specgram);
    
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
    log.freq{i}=freq;
    log.time{i}=time;
    %pause
end
%NEED TO CHANGE SELECT REVIEW WITH THIS INPUT.
log=SelectReview(log);
[path,name,ext]=fileparts(log.file);
[savename pathname]=uiputfile('*.m','Save file as...',[log.path name '_REVIEWED.mat']);
log.file=savename;
log_save(log);
result = [];