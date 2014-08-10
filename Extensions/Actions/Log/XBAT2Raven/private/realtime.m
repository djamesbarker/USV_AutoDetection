function dn = realtime(sound, t)
%
% function dn = realtime(sound, t)
%
% Calculates MATLAB datenums from input matrix of times from events in XBAT
% log (in seconds of recording time).  Note the this function ignores XBAT
% sound attributes, calculating dn from datestamps in sound file names.
% Note also that matrix input is supported for t.
%
% input variables
%
%   sound = XBAT sound struct
%
%   t = event times in seconds (from XBAT log.event().time)
%
% output variable
%
%   dn = MATLAB datenums corresponding to t
%
%
% Note: this function simplifies realtime calculation in XBAT, replacing:
%
%   log.sound = PRBA_set_date_time(log.sound);
%
%   log.sound = PRBA_set_time_stamps(log.sound);
%
%   dn = log.sound.realtime + map_time(log.sound,'real','record',t)./86400;
%
%
% Note: precision of this function is about 10e-5 seconds
%
%
% Michael Pitzrick and Sara Keene, 17 September 2012


% get rid of time stamp attribute so get_current_file will work if
% time-stamps attribute is set

sound.time_stamp = [];

sound.attributes = [];


% calculate MATLAB datenum of t without resorting XBAT sound attributes

[m,n] = size(t);

dn = zeros(m,n);


% loop through rows and columns of input matrix t

for i = 1:m
  
  for j = 1:n
    
    curr_t = t(i,j);
    
    
    %--- find sound file name at current time

    if ischar(sound.file) %XBAT sound is single sound file
      
      ix = 1; 
      
    else                  %XBAT sound is sound file stream
    
      start = [0; sound.cumulative(1:end)] / sound.samplerate;

      ix = find(curr_t >= start, 1, 'last'); 
      
    end

    fn = sound.file{ix};
    
    
    %--- find begin time of file as recording seconds
    
    record_time = [0; sound.cumulative(1:end)] / sound.samplerate;
    
    record_filetime = record_time(ix); 
    
    
    %--- find begin time of sound file as real MATLAB date number

    real_filetime = file_datenum(fn);
    
    
    %--- calculate real MATLAB date number

    file_offset = curr_t - record_filetime;

    dn(i,j) = real_filetime + file_offset / 86400;

  end
  
end












