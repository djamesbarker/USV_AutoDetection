function [result, context] = prepare(parameter, context)

% XBAT2RAVEN_V33 - prepare

result = struct;
%% REFRESH log.file and log.path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XBAT2RAVEN V3-1 - compuate
%
% XBAT2Raven v3.2
%
% Makes Raven Selection Tables for all selected logs
%
% Note: Refreshes log.file and log.path to current log name and
%       current path
%
% designed for use in XBAT Pallet Log window
%
% Exports selected XBAT log to Raven selection table
%
% Ignores "Date Time" and "Time Stamp" attributes
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Michael Pitzrick
%  msp2@cornell.edu
%  21 Sep 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Changes:
%
%  1. All Raven selection tables go to the same directory (the default
%     directory for each log is log.path as XBAT logs)
%
%  2. All Raven selection tables output to the same directory.
%
%  3. If Raven selection table already exists, give user opportunity to
%  overwrite or rename.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DISCLAIMER OF WARRANTIES

% THE SOFTWARE AND DOCUMENTATION ARE PROVIDED AS IS AND BRP MAKES NO
% REPRESENTATIONS OR WARRANTIES (WRITTEN OR ORAL). TO THE MAXIMUM EXTENT
% PERMITTED BY APPLICABLE LAW, BRP DISCLAIMS ALL WARRANTIES AND CONDITIONS,
% EXPRESS OR IMPLIED, AS TO ANY MATTER WHATSOEVER AND TO ANY PERSON OR
% ENTITY, INCLUDING, BUT NOT LIMITED TO, ALL IMPLIED WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND
% NON-INFRINGEMENT OF THIRD PARTY RIGHTS AND THOSE ARISING FROM A COURSE OF
% DEALING OR USAGE IN TRADE. NO WARRANTY IS MADE THAT ANY ERRORS OR DEFECTS
% IN THE SOFTWARE WILL BE CORRECTED, OR THAT THE SOFTWARE WILL MEET YOUR
% REQUIREMENTS.  END USERS SHALL NOT COPY OR REDISTRIBUTE THE SOFTWARE
% WITHOUT WRITTEN PERMISSION FROM BRP.

% LIMITATION OF LIABILITY

% IN NO EVENT SHALL BRP OR ITS DIRECTORS, FACULTY, OR EMPLOYEES, BE LIABLE
% FOR DAMAGES TO OR THROUGH YOU OR ANY OTHER PERSON OR ENTITY FOR BREACH
% OF, ARISING UNDER, OR RELATED TO THIS AGREEMENT OR THE USE OF SOFTWARE OR
% DOCUMENTATION PROVIDED HEREUNDER, UNDER ANY THEORY INCLUDING, BUT NOT
% LIMITED TO, DIRECT, SPECIAL, INCIDENTAL, INDIRECT, CONSEQUENTIAL, OR
% SIMILAR DAMAGES (INCLUDING WITHOUT LIMITATION, DAMAGES FOR LOSS OF
% BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION OR
% DATA, OR ANY OTHER LOSS) WHETHER FORESEEABLE OR NOT, REGARDLESS OF THE
% FORM OF ACTION, WHETHER IN CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT
% LIABILITY OR OTHERWISE.


% list names of selected logs
if isfield(context, 'target')   %check if context.target is available
    logs = context.target;
else
    fprintf(2,'API supplied no context.target in prepare.m \n');
    context.state.kill = 1;
    return;
end

% Make sure logs aren't open in sound window
[log_list, sound_list, ver_status] = list_logs(context);
[status] = ASE_log_is_open(log_list);

if any(status)
    d = sprintf('XBAT2Raven cannot run because the following logs are open:\n\n');
    for i = 1:length(log_list)
       if status(i)
           d = [d sprintf('%s\n\n',log_list{i})];
       end
    end   
    ds = [sprintf('WARNING\n\n') d];
    fprintf(2,ds);
    h=warndlg(d, 'XBAT2Raven');
    movegui(h, 'center') 
    context.state.kill = 1;
    return;
end


%-- begin pitz - add header for optional fields, if any

empty_fields = {parameter.empty_field1; 
                parameter.empty_field2; 
                parameter.empty_field3; 
                parameter.empty_field4; 
                parameter.empty_field5};
  
num_empty_fields = 0;
  
header3 = '';
  
pad = '';

for k = 1:5

  if ~isempty(empty_fields{k})
    
    num_empty_fields = num_empty_fields + 1;

    header3 = [header3, char(9), empty_fields{k}];

  end

end

if num_empty_fields
  
  for k = 1:num_empty_fields

    pad = [pad, '\t'];

  end
  
end

%-- end pitz



%% ask user for output directory

out_path = uigetdir2('','Choose output directory');

if out_path == 0
    context.state.kill = 1;
    return;
else
    context.state.kill = 0;
end

%% Begin log calculations
if ~iscell(logs)
    logs = {logs};
end

context.state.out_path = out_path;
out_path = context.state.out_path;

% loop through logs to make sure names are acceptable
NumLogs = length(logs);
for i = 1:NumLogs
    
    log = logs{i};
    divpt = strfind(log,'\');
    log_name{i} = log(divpt+1:end);
    log_name{i} = strcat(log_name{i},'.selections');
    out_file{i} = fullfile(out_path, [log_name{i} '.txt']);
    
    % open exported Raven Selection Table
    if exist(out_file{i},'file')==2
        %         dial = uigetdir(out_path,'Raven Selection Table already exists. Pick a different name or folder.');
        % %         [fn, out_path] = uiputfile2_SCK('*.txt', dial, out_file{i});
        %  [fn, out_path] = uiputfile(log_name, dial);
        [fn, out_path] = uiputfile(out_file{i}, 'Raven Selection Table already exists. Pick a different name or folder.');
        if not(ischar(fn)) && not(ischar(out_path))
            disp('Log name not chosen. XBAT2Raven cancelled');
            context.state.kill = 1;
            return;
        end
        out_file{i} = fullfile(out_path, fn);
    end
    
end

if length(unique(log_name)) < length(log_name)
    same_ix = [];
    for i = 1:NumLogs
        for j = i+1:NumLogs
            if strcmp(log_name{i},log_name{j})
                same_ix = [same_ix i];
            end
        end
    end
    same_ix = unique(same_ix);
    rep_logs = unique(log_name(same_ix));
    log_list = '';
%     for i = 1:length(rep_logs)
%         log_list = strcat(log_list,'\n',rep_logs{i},'\n');
%     end
    d = sprintf('More than one XBAT log has the following name: \n\n' );
      for i = 1:length(rep_logs)
        d = [d sprintf('%s\n',rep_logs{i})];
      end
     d = [d sprintf('\n\nXBAT2Raven cancelled. No selection tables created due to naming conflict.')];
    ds = [sprintf('WARNING\n\n') d sprintf('\n')];
    fprintf(2,ds);
    h= warndlg(d, 'XBAT2Raven');
    movegui(h, 'center') 
    context.state.kill = 1;
    return;
end



% make selection table for each log
for i = 1:NumLogs
    
    %determine new log name and display
    CurrentLog = logs{i};
    
    % load log structure
    [SoundName fn] = fileparts(CurrentLog);
    NewLog = get_library_logs('logs',[],SoundName,CurrentLog);
    
    %check if a single, valid log is specified
    if ischar(SoundName) && ischar(fn) && isequal(length(NewLog),1)
        
        % make separate event struct
        event = NewLog.event;
        
        % If we are getting real times from the sound attributes that previously existed,
        if parameter.datetime_flag || parameter.realtime_flag || parameter.realdate_flag
            %%% FIX~
            %set date-time attribute in log for any of these conditions
           
%             NewLog.sound = PRBA_set_date_time(NewLog.sound);
            
            % Mike's new function that can read new time formats
            NewLog.sound.realtime = file_datenum(NewLog.sound.file{1});
            
            % set timestamps based on log name format
             NewLog.sound = PRBA_set_time_stamps(NewLog.sound);
             
%             switch char(parameter.datetime_format)
%                 
%                 case 'yyyymmdd_HHMMSS'
%                     
%                     %set time-stamp attribute in log
%                     NewLog.sound = PRBA_set_time_stamps(NewLog.sound);
%                     
%                 case 'yyyymmddTHHMMSS'
%                     
%                     %set time-stamp attribute in log
%                     NewLog.sound = PRBA_set_time_stampsT(NewLog.sound);
%                     
%                 case 'yyyymmddTHHMMSSmFFF'
%                     
%                     %set time-stamp attribute in log
%                     NewLog.sound = PRBA_set_time_stampsF(NewLog.sound);
%                 case 'yyyymmddTHHMMSSmFFFFFFF'
%                     
%                     %set time-stamp attribute in log
%                     NewLog.sound = PRBA_set_time_stampsF2(NewLog.sound);
%             end
            
            for ev_cnt = 1: length(NewLog.event)
                %convert time in XBAT log to a MATLAB datenumber, which reflects the date and time the recorder turned on, and the duty cycle schedule
                event(1,ev_cnt).real_start =  NewLog.sound.realtime + map_time(NewLog.sound,'real','record',NewLog.event(1,ev_cnt).time(1))./86400;
                event(1,ev_cnt).real_stop =  NewLog.sound.realtime + map_time(NewLog.sound,'real','record',NewLog.event(1,ev_cnt).time(2))./86400;
            end
            
            %%% New way of calculating realtime with MP fix 9/18/12 NEEDS TESTING
%             for ev_cnt = 1: length(NewLog.event)
%                 %convert time in XBAT log to a MATLAB datenumber, which reflects the date and time the recorder turned on, and the duty cycle schedule
%                 event(1,ev_cnt).real_start =  NewLog.sound.realtime + map_time(NewLog.sound,'real','record',NewLog.event(1,ev_cnt).time(1))./86400;
%                 event(1,ev_cnt).real_stop =  NewLog.sound.realtime + map_time(NewLog.sound,'real','record',NewLog.event(1,ev_cnt).time(2))./86400;
%             end


%             if parameter.modify_logs
%                 % save log
%                 log_save(NewLog);
%             end
        end
        
%         if parameter.filetime_flag
%             for ev_cnt = 1: length(NewLog.event)
%                
% %                 export_file = get_current_file(NewLog.sound, event(1,ev_cnt).time(1));
% %                 event(1,ev_cnt).file = export_file;
% %                 event(1,ev_cnt).filetime = event(1,ev_cnt).time(1) - get_file_times(NewLog.sound, export_file);
% %                 event(1,ev_cnt).offset_path = NewLog.sound.path;
%                 
%                 % Mike Pitzrick's fix for negative file offsets
%                 fixed_sound = NewLog.sound;
%                 % clear time stamps attributes just in case--so get_file_times and get_current_file work correctly
%                 fixed_sound.time_stamp = [];
%                 fixed_sound.attributes = [];
%                  % get event offset times from beginning of current sound file in filestream
%                 export_file = get_current_file(fixed_sound, event(1,ev_cnt).time(1));
%                 event(1,ev_cnt).file = export_file;
%                 event(1,ev_cnt).filetime = event(1,ev_cnt).time(1) - get_file_times(fixed_sound, export_file);
%                 event(1,ev_cnt).offset_path = NewLog.sound.path;
%                 
%             end
%         end
        
        
        % extract column names saved in notes section
        if isfield(NewLog.userdata, 'notes_categories')
            col_names = NewLog.userdata.notes_categories;
        else col_names = {};
        end
        
        % test to see if log is empty
        if NewLog.length == 0 && parameter.empty_logs_ok
            
            header1 =  ['Selection	View	Channel	Begin Time (s)	End Time (s)' char(9) 'Low Freq (Hz)' char(9) 'High Freq (Hz)'];
            f1 = char();
            f1='%.0f\t%s\t%.0f\t%.3f\t%.3f\t%.1f\t%.1f\t';
            if parameter.scores_flag
                header1 = [header1  char(9) 'XBAT Scores'];
                f1 = [f1 '%s\t'];
            end
            if parameter.ratings_flag
                header1 = [header1  char(9) 'XBAT Ratings'];
                f1 = [f1 '%s\t'];
            end
            if parameter.tags_flag
                header1 = [header1  char(9) 'XBAT Tags'];
                f1 = [f1 '%s\t'];
            end
            if parameter.datetime_flag
                header1 = [header1  char(9) 'Real Start Datetime' char(9) 'Real Stop Datetime'];
                f1 = [f1 '%s\t%s\t'];
            end
            if parameter.realtime_flag
                header1 = [header1  char(9) 'Real Start Time' char(9) 'Real Stop Time'];
                f1 = [f1 '%s\t%s\t'];
            end
            if parameter.realdate_flag
                header1 = [header1  char(9) 'Real Start Date' char(9) 'Real Stop Date'];
                f1 = [f1 '%s\t%s\t'];
            end
            if parameter.filetime_flag
                header1 = [header1  char(9) 'File Path' char(9) 'Start File' char(9) 'Start Offset (s)' char(9) 'Stop File'  char(9) 'Stop Offset (s)'];
                f1 = [f1 '%s\t%s\t%.17f\t%s\t%.17f\t']; 
            end
            if parameter.notes_flag
                header1 = [header1  char(9) 'XBAT Notes'];
                f1 = [f1 '%s\t'];
            end
            % terminate header with new line
            fid = fopen(out_file{i}, 'w');
            fprintf(fid, '%s\n', header1);
            
            %             fprintf('New selection table saved: %s\n\n',logs{i})
            %             fclose(fid);
            
            
            %-- begin pitz - output headers, including those for empty fields            
            if ~isempty(header3)
                
                fprintf(fid, '%s%s\n', header1, header3); 
            else
                fprintf(fid, '%s\n', header1);              
            end
            
            fprintf('New selection table saved: %s\n\n',logs{i})            
            fclose(fid);
            %-- end pitz
            
        elseif NewLog.length > 0
            
            % loop through events in log
            for j = 1:NewLog.length
                
                % structure to array
                id = NewLog.event(j).id;
                channel = NewLog.event(j).channel;
                t(1) = NewLog.event(j).time(1);
                t(2) = NewLog.event(j).time(2);
                freq(1) = NewLog.event(j).freq(1);
                freq(2) = NewLog.event(j).freq(2);
                score = NewLog.event(j).score;
                scores = num2str(score);
                rating = NewLog.event(j).rating;
                ratings = num2str(rating);
                tagsCell = NewLog.event(j).tags;
                lengthCell = length(tagsCell);
                real_start_date = []; real_start_time = []; real_stop_date = [];  real_stop_time = []; real_start_datetime = [];  real_stop_datetime = [];
                
                % If we are getting real times from sound file names, the
                % real_start and real_stop fields were just created and are correct
                %%% FIX
                if parameter.datetime_flag || parameter.realtime_flag || parameter.realdate_flag
                    
                    try real_start = datestr(event(j).real_start);
                        
                        real_stop = datestr(event(j).real_stop);
                        
                        if not(isempty(real_start)) && not(isempty(real_stop))
                            
                            % record real dates
                            real_start_date = datestr(event(j).real_start,char(parameter.realdate_format_out));
                            real_stop_date = datestr(event(j).real_stop,char(parameter.realdate_format_out));
                             
                            % record real times
                            m_ix=cell2mat(strfind(parameter.realtime_format_out,'SmF'));
                            if not(isempty(m_ix))
                                
                                % find and replace 'm'
                                m_ix= cell2mat(strfind(parameter.realtime_format_out,'m'));
                                realtime_format_out = char(parameter.realtime_format_out);
                                realtime_format_out(m_ix(end)) = '.';
                                
                                % calculate real dates and times as usual
                                real_start_time = datestr(event(j).real_start,char(realtime_format_out));
                                real_stop_time = datestr(event(j).real_stop,char(realtime_format_out));
                                
                                % replace decimal point with 'm'
                                d_ix = strfind(real_start_time,'.');
                                real_start_time(d_ix) = 'm'; 
                                real_stop_time(d_ix) = 'm'; 
                            else
                                real_start_time = datestr(event(j).real_start,char(parameter.realtime_format_out));
                                real_stop_time = datestr(event(j).real_stop,char(parameter.realtime_format_out));                             
                            end       
                            
                            % record datetimes
                            m_ix=cell2mat(strfind(parameter.datetime_format_out,'SmF'));
                            if not(isempty(m_ix))
                                
                                % find and replace 'm'
                                m_ix= cell2mat(strfind(parameter.datetime_format_out,'m'));
                                datetime_format_out =char(parameter.datetime_format_out);
                                datetime_format_out(m_ix(end)) = '.';
                                
                                % calculate real dates and times as usual
                                real_start_datetime = datestr(event(j).real_start,char(datetime_format_out));
                                real_stop_datetime = datestr(event(j).real_stop,char(datetime_format_out));
                                
                                % replace decimal point with 'm'
                                d_ix = strfind(real_start_datetime ,'.');
                                real_start_datetime (d_ix) = 'm';
                                real_stop_datetime (d_ix) = 'm';
                               
                            else
                                real_start_datetime = datestr(event(j).real_start,char(parameter.datetime_format_out));
                                real_stop_datetime = datestr(event(j).real_stop,char(parameter.datetime_format_out));                             
                            end         
                            
                        else
                            if j == 1
                                disp('Cannot save real dates and times because sound file name does not include timestamp')
                            end
                        end
                        
                    catch err
                    end
                end            
                
                % if flag is set, get file offsets for this line
%                 if parameter.filetime_flag
%                     try start_offset = event(j).filetime;
%                     catch err
%                     end
%                     
%                     try offset_start_file = event(j).file;
%                     catch err
%                     end
%                     
%                     currfile = find(strcmp(NewLog.sound.file,event(j).file));
%                     sound_lens = NewLog.sound.cumulative / NewLog.sound.samplerate;
%                     curr_sound_stop = sound_lens(currfile);     
%                     
%                     if event(j).time(2) > curr_sound_stop
%                         
%                         if currfile < length(NewLog.sound.file)
%                             % if not last file
%                             stopfile = min(find(event(j).time(2) < sound_lens));
%                             offset_stop_file = NewLog.sound.file{stopfile};
%                             stop_offset =  event(j).time(2) - sound_lens(stopfile-1);
%                         else
%                             % if last file in  filestream, event must fall within file bounds
%                             offset_stop_file = NewLog.sound.file{currfile};
%                             stop_offset =  NewLog.sound.samples(currfile)/ NewLog.sound.samplerate;
%                         end
%                     else
%                         % event is contained within one file
%                         try offset_stop_file = event(j).file;
%                         catch err
%                         end
%                         
%                         if isempty(event(j).duration)
%                             event(j).duration = event(j).time(2) - event(j).time(1);
%                         end
%                         try stop_offset = event(j).filetime + event(j).duration;
%                             
%                         catch err
%                         end
%                         
%                         
%                     end
%                     try offset_path = event(j).offset_path;
%                     catch err
%                     end
%                 end
                
                % If no tags exist for this event, put in blanks
                event_tags = '';
                if isempty(tagsCell)
                    event_tags = ' ';
                else
                    event_tags = tagsCell{1};
                    for ti = 2:lengthCell
                        event_tags = [event_tags ' | ' tagsCell{ti}];
                    end
                end
                
                % See if notes exist for event, if not put in blank
                notesCell = event(j).notes;
                if isempty(notesCell)
                    notes = ' ';
                    
                    % if notes exist and flag is set, add to ST row
                elseif iscell(notesCell) && parameter.notes_flag
                    %initialize data
                    col_types = {}; col_headers = {};
                    % Extract Column data from notes
                    for z = 1:length(notesCell)
                        note_temp = notesCell{z};
                        div_ix = strfind(notesCell{z},':');
                        if length(div_ix) > 1
                            div_ix = div_ix(1);
                        end
                        if length(div_ix) == 1
                            % Notes are in "Measurement : Value" format
                            temp_name = char(notesCell{z});
                            var_name = note_temp(1:div_ix-1);
                            % save all notes entries as strings
                            eval([var_name ' = ''',strtrim(temp_name(div_ix+1:end)),''';']);
                            col_types{z} = 's';
                            col_headers{z} = var_name;
                            
                        elseif isempty(div_ix)
                            % Notes are in "freestyle string" format
                            col_headers{z} =  'XBAT_Notes';
                            col_types{z} = 's';
                            temp_name = char(notesCell{z});
                            XBAT_Notes = temp_name;
                            
                        end
                        clear var_name temp_name div_ix note_temp
                    end
                end
                
               
                % print headers in Raven Selection Table
                header1 =  ['Selection	View	Channel	Begin Time (s)	End Time (s)' char(9) 'Low Freq (Hz)' char(9) 'High Freq (Hz)'];
                f1 = char();  xbat_fields = char();  var_names = char(); header2 = char();
                f1='%.0f\t%s\t%.0f\t%.17f\t%.17f\t%.17f\t%.17f\t';
                if parameter.scores_flag
                    header1 = [header1  char(9) 'XBAT Scores'];
                    f1 = [f1 '%s\t'];
                    xbat_fields = [xbat_fields ',' 'scores'];
                end
                if parameter.ratings_flag
                    header1 = [header1  char(9) 'XBAT Ratings'];
                    f1 = [f1 '%s\t'];
                    xbat_fields = [xbat_fields ',' 'ratings'];
                end
                if parameter.tags_flag
                    header1 = [header1  char(9) 'XBAT Tags'];
                    f1 = [f1 '%s\t'];
                    xbat_fields = [xbat_fields ',' 'event_tags'];
                end             
                if parameter.datetime_flag
                    header1 = [header1  char(9) 'Real Start Datetime (' char(parameter.datetime_format_out) ')' char(9) 'Real Stop Datetime (' char(parameter.datetime_format_out) ')'];
                    f1 = [f1 '%s\t%s\t'];
                    xbat_fields = [xbat_fields ',' 'real_start_datetime,real_stop_datetime'];
                end
                if parameter.realtime_flag
                    header1 = [header1  char(9) 'Real Start Time (' char(parameter.realtime_format_out) ')' char(9) 'Real Stop Time (' char(parameter.realtime_format_out) ')'];
                    f1 = [f1 '%s\t%s\t'];
                    xbat_fields = [xbat_fields ',' 'real_start_time,real_stop_time'];
                end
                if parameter.realdate_flag
                    header1 = [header1  char(9) 'Real Start Date (' char(parameter.realdate_format_out) ')' char(9) 'Real Stop Date (' char(parameter.realdate_format_out) ')'];
                    f1 = [f1 '%s\t%s\t'];
                    xbat_fields = [xbat_fields ',' 'real_start_date,real_stop_date'];
                end           
%                 if parameter.filetime_flag
%                     header1 = [header1  char(9) 'Begin Path' char(9) 'Begin File' char(9) 'File Offset (s)'];
%                     f1 = [f1 '%s\t%s\t%.17f\t'];
%                     xbat_fields = [xbat_fields ',' 'offset_path,offset_start_file,start_offset'];
%                 end
                 if parameter.filetime_flag_end
                    header1 = [header1  char(9) 'End Offset (s)'];
                    f1 = [f1 '%.17f\t'];
                    xbat_fields = [xbat_fields ',' 'stop_offset'];
                end
                if parameter.filetime_flag_end_file
                    header1 = [header1  char(9) 'End File'];
                    f1 = [f1 '%s\t'];
                    xbat_fields = [xbat_fields ',' 'offset_stop_file'];
                end
                
                if parameter.notes_flag
                    
                    %Make header lookup tables
                    abbrev_names = {'AggEntropyu','AvgEntropyu','AvgPowerdB','BW90Hz','BeginFile','BeginPath','CenterFreqHz','CenterTimes','DeltaFreqHz','DeltaPowerdB','DeltaTimes','Dur90s','EndFile','EndPath','EnergydB','FileOffsets','FRMSAmpu','Freq5Hz','Freq95Hz','IQRBWHz','IQRDurs','Lengthframes','MaxAmpu','MaxBearingdeg','MaxFreqHz','MaxPowerdB','MaxTimes','MinAmpu','MinTimes','PeakAmpu','PeakCorru','PeakFreqHz','PeakLags','PeakPowerdB','PeakTimes','Q1FreqHz','Q1Times','Q3FreqHz','Q3Times','RMSAmpu','Time5s','Time95s'};
                    full_names = {'Aggregate Entropy (u)','Average Entropy (u)','Average Power (dB)','Bandwidth 90% (Hz)','Begin File','Begin Path','Center Frequency (Hz)','Center Time (s)','Delta Frequency (Hz)','Delta Power (dB)','Delta Time (s)','Duration 90% (s)','End File','End Path','Energy (dB)','FileOffset (s)','Filtered RMS Amplitude (u)','Frequency 5% (Hz)','Frequency 95% (Hz)','IQR Bandwidth (Hz)','IQR Duration (s)','Length (frames)','Max Amplitude (u)','Max Bearing (deg)','Max Frequency (Hz)','Max Power (dB)','Max Time (s)','Min Amplitude (u)','Min Time (s)','Peak Amplitude (u)','Peak Correlation (u)','Peak Frequency (Hz)','Peak Lag (s)','Peak Power(dB)','Peak Time (s)','1st Quartile Frequency (Hz)','1st Quartile Time (s)','3rd Quartile Frequency (Hz)','3rd Quartile Time (s)','RMS Amplitude (u)','Time 5% (s)','Time 95% (s)'};
                    
                    % print values to selection table
                    ff = 6 + parameter.scores_flag + parameter.ratings_flag + parameter.tags_flag + 2*parameter.datetime_flag + 2*parameter.realtime_flag + 2*parameter.realdate_flag + 2*parameter.filetime_flag;
                    fnew = [];
                    
                    % Col headers will exist if the log is a converted Raven ST
                    if exist('col_headers')
                        for y = 1:length(col_headers)
                            
                            h_ix = find(strcmp(abbrev_names,col_headers{y}) == 1);
                            
                            if not(isempty(h_ix))
                                abbrev_header_names{y} = abbrev_names{h_ix};
                                full_header_names{y} = full_names{h_ix};
                            else
                                abbrev_header_names{y} = col_headers{y};
                                full_header_names{y} = col_headers{y};
                            end
                            
                            if strcmp(char(col_types{y}),'s')
                                % string
                                fnew = [fnew '%s\t'];
                            else
                                % numeric
                                fnew = [fnew '%f\t'];
                            end
                            
                        end
                        
                        % Get names of variables to fill in selection table rows
                        for w = 1:length(col_headers)
                            val = char(abbrev_header_names{w});
                            var_names = strcat(var_names,',',val);
                            header2 = [header2 char(9) full_header_names{w}];
                        end
                        
                    else
                        fnew = [fnew '\t'];
                        val = ' ';
                        var_names = ''; %[var_names ',' val];
                        header2 = [header2 char(9) 'XBAT Notes'];
                    end
                    
                    f1 = [f1 fnew];
                end
                
                %--- begin pitz
                % add in tabs for optional empty fields and terminate header with new line
                f1 = [f1(1:end-2), pad, '\n'];
                
                %                 % terminate header with new line
                %                 f1 = [f1(1:end-2) '\n'];
                %--- end pitz
                
                % terminate header with new line
                f1 = [f1(1:end-2) '\n'];
                
                % Print header column in first row of selection table
                if j == 1
                    
                     %-- begin pitz - open new file and begin to write selection table                    
                    fid = fopen(out_file{i}, 'w');
                    header = [header1, header2, header3];
                    fprintf(fid, '%s\n', header);                
                    %-- end pitz
                    
%                     % open new file and begin to write selection table
%                     fid = fopen(out_file{i}, 'w');
%                     try fprintf(fid, '%s%s\n', header1, header2);
%                     catch err
%                         fprintf(fid, '%s\n', header1);
%                     end

                end
                
                % fill in current row with event data
                eval(['ln1=sprintf(f1, id, ''Spectrogram 1'', channel, t(1),t(2),freq(1),freq(2)' xbat_fields var_names ');'])
                %             ln1 = strcat(ln1);
                fprintf(fid, '%s', ln1);
            end
            
            fprintf('New selection table saved: %s\n\n',logs{i})
            fclose(fid);
        else
            fprintf('Raven selection table not created because XBAT log %s is empty.  The ''convert empty logs'' option in XBAT2Raven must be selected.\n\n',logs{i});
        end
        % close new selection table file
        
        
    else
        fprintf(2,'API supplied no SoundName and fn in prepare.m, or get_library_logs returned invalid or multiple logs \n')
        context.state.kill = 1;
        return;
    end
end




