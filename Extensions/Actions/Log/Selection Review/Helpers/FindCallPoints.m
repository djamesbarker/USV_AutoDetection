function [CallPoints] = FindCallPoints(log,B)

%log.clips holds individual detection spectrogram data
%log.freq holds ylim info for each clip
%log.time holds xlim info for each clip

%find noise of the file by using the first 0.25 seconds of the file


FileNoise = wavread(fullfile(log.sound.path,log.sound.file),[1 log.sound.samplerate*0.25]);
noise_specgram = fast_specgram(FileNoise, log.sound.samplerate,'norm', log.sound.specgram);
Noise=mean(mean(noise_specgram(200:257,:)));

%find the maximum power of the call in each bin and
%its corresponding X coord

MaxPoint=[];Xloc=[];Max=[];Loc=[];
for a=1:length(B(1,:))
    [MaxPoint, Xloc]=max(B(:,a));
    Max(1,a)=MaxPoint; %Max Value
    Loc(1,a)=Xloc; %X location
end

%Logical array for points where the max value is significantly greater than
%the background noise. Currently set at 8x higher based on graphical
%analyses
Max_idx=Max(1,:)>=Noise*8;


% Gets X and Y coordinates for points that exceed the signal-to-noise
% threshold so that they can be plotted
CallPoints=[];
for a=1:length(B(1,:))
    if Max_idx(a)==1
        CallPoints(end+1,1)=a;
        CallPoints(end,2)=Loc(a);
    end
end

%Filters only points in the 50-kHz range
CallPoints=CallPoints(CallPoints(:,2)>=35,:);
end