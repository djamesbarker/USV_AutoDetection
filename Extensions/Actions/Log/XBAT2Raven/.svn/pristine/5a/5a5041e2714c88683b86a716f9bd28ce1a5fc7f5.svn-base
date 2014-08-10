function sound = PRBA_set_date_time(sound)

% SET DATE-TIME ATTRIBUTE - compute
%
% Sets Date-Time attribute using time stamps in sound file names
%
% Note that this function writes date_time.csv only.  
%
% This action consists of modified XBAT code activated with
%   XBAT palette > Attributes > Add Attribute > Date Time
% which was written by Harold Figueroa (hkf1@cornell.edu) and 
% Matthew Robbins (mer34@cornell.edu)
%
% Michael Pitzrick
% msp2@cornell.edu
% 23 Dec 08

%list AIFF's in sound file stream
file = sound.file;

%select first file in file stream
if iscell(file)
  file = file{1};
end

%calculate datenum from time stamp in name of first AIFF
num = file_datenum(file);

if isempty(num)    
    return;    
end

%update attributes in sound struc variable
sound.realtime = num;

flag = 0;

for i = 1:length(sound.attributes)
  if strcmpi(sound.attributes(i).name, 'date_time')
    sound.attributes(i).value.datetime = num;
    flag = 1;
  end
end

if ~flag
  date_time.name = 'date_time';
  date_time.value.datetime = num; 
  sound.attributes = [sound.attributes, date_time];
end




%% Update date-time.csv

% %convert date vector into CSV string
% lines{1} = 'Date and Time';
% lines{2} = '(MATLAB date vector)';
% line = '';
% 
% %convert datenum of first AIFF into date vector
% vec = datevec(num);
% 
% for k = 1:length(vec)
% 	line = [line, num2str(vec(k)), ', '];
% end
% 
% line(end-1:end) = '';
% lines{3} = line;
% 
% % if no '__XBAT\Attributes\' directory, then create
% sPath = sound.path;
% if ~exist([sPath '__XBAT\Attributes'], 'dir')
%   mkdir([sPath '__XBAT\Attributes']);
% end
% 
% %write new date-time.csv
% store = [sound.path '__XBAT\Attributes\date_time.csv'];
% file_writelines(store, lines);
