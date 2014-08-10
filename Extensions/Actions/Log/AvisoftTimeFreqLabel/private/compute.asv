function [result, context] = compute(log, parameter, context)
% AVISOFTTIMEFREQLABEL - compute

if isfield(log,'peakHz') && isfield (log,'peakTime')

    AviOut(:,1)=log.peakTime;
    AviOut(:,2)=log.peakHz;
else
    error('peakHz or peakTime variable missing')
end

[filename, pathname] = uiputfile('*.txt', 'pick text file');
dlmwrite(fullfile(pathname,filename), AviOut, 'delimiter', '\t',...
    'precision',6,'newline','pc')

result = struct;
