function [result, context] = compute(log, parameter, context)

% Thumbnail Review - compute
% Written by David Barker as an extension for XBAT.
% XBAT is protected by Copyright (C) 2002-2012 Cornell University

%To do:
% Set up spectrogram control 


%Number of bins =(FFT length/2)+1
%Resolution is actually just Fs/N (sampling/# of FFT)
FFT_Len=512;
Fs=log.sound.samplerate;
spect_res=Fs/FFT_Len;
sound_file = fullfile(log.sound.path,log.sound.file);


figure
for i=1:length(log.event)
    
    sample_bounds = round(log.event(i).time*Fs);
    sample_freq= round(log.event(i).freq);
    sample_bins=round(sample_freq/spect_res);
    event_clip = wavread(sound_file, [sample_bounds(1) sample_bounds(2)]);
    S = spectrogram(event_clip,FFT_Len,500,FFT_Len,Fs);
    scrollsubplot(2,2,i)
    imagesc(abs(S));
    pcolor(abs(S))
    shading flat
%     figure
%     signal=S(sample_bins(1):sample_bins(2),:);
%     pcolor(abs(signal))
%     shading flat
end

result = [];






