function [result, context] = compute(log, parameter, context)

% USV_XBAT2EXCEL - compute

header={'EventID' 'StartTime' 'EndTime' 'LowerBound' ...
    'UpperBound' 'PeakTime' 'PeakHz' 'Correlation' 'SampleRate'};


for i=1:length(log.event)
    if isfield(log.event(1,i),'peakHz')
        A(i,1)=i;
        A(i,2:3)=log.event(1,i).time; %Window start and end time
        A(i,4:5)=log.event(1,i).freq; %Window lower and upper Frequency
        A(i,7)=log.event(1,i).peakHz;
        A(i,6)=log.event(1,i).peakTime;
        if isempty(log.event(1,i).score)
            A(i,8)=nan;
        else
            A(i,8)=log.event(1,i).score;  % Correlation Score
        end
        A(i,9)=log.sound.samplerate;
    else
    h = warndlg('Log is not ready for export. Please run Selection Review First.');
    error('Log is not ready for export. Please run Selection Review First.');
    end
end

 [filename, pathname] = uiputfile('*.xls', 'Input File Name');
% dlmwrite(fullfile(pathname,filename), AviOut, 'delimiter', '\t',...
%     'precision',6,'newline','pc')

xlswrite(fullfile(pathname,filename),A,'Sheet1','A2');     %Write data
xlswrite(fullfile(pathname,filename),header,'Sheet1','A1'); 

result = struct;
