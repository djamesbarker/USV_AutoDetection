%% TO DO:
% Create safety measure in case the log is not saved

%%
function [result, context] = compute(log, parameter, context)
% Selection Review - compute
% Written by David Barker as an extension for XBAT.
% Co-Authored by Sara Keen. Thanks for the Help!
% XBAT is protected by Copyright (C) 2002-2012 Cornell University


%Number of bins =(FFT length/2)+1
%Resolution is actually just Fs/N (sampling/# of FFT)
%FFT_Len=log.sound.specgram.fft;
Fs=log.sound.samplerate;
%spect_res=Fs/FFT_Len;

%% Dialog to allow the user to set the buffer around calls and playback speed!!!!!!!!!!!!!!!!!
defAns = {'0.05' '18000' '80000'};
prompt={'Amount of time(s) to pad around each selection','Low Freq for BandPass',...
    'High Freq for BandPass'};
answer = inputdlg(prompt,'Settings:',1,defAns);
padval=abs(str2double(answer{1}));
pad = round(abs(str2double(answer{1}))*Fs);

% Creates log.sound.startTime,log.fileDuration,log.event.file,log.event.SR_time
%   startTime = start of sound with respect to filestream
%   fileDuration = duration of each sound within a filestream
%   file = String containing name of original sound file
%   SR_time = time of each event with respect to their original sound file
log = get_event_files(log);

%% Creates the spectrogram for each identified clip found in the log file
log=prepSelRev(log,Fs,answer,pad)
log.pad=padval

%NEED TO CHANGE SELECT REVIEW WITH THIS INPUT.
log=SelectReview(log);
[path,name,ext]=fileparts(log.file);
[savename pathname]=uiputfile('*.mat','Save file as...',[log.path name '_REVIEWED.mat']);
log.file=savename;
log_save(log);


result = [];
end