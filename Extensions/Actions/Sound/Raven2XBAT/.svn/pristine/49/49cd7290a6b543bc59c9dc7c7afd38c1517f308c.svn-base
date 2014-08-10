function [result, context] = compute(sound, parameter, context)

% RAVEN2XBAT_v2 - compute
%
% Imports Raven selection tables as XBAT logs
%
%
% Input: Raven selection tables in a single folder.
%
% Output: XBAT logs in appropriate folder(s) in XBAT library
%
%
% To launch:
%
% 1. Select sound(s) in XBAT palette that you have Raven selection tables
% for
%
% 2. Right-click on sounds > Actions > XBAT2Raven_batch
%
% 3. Click OK.
%
% 4. Select Raven selection table(s) you want to import.  They can be from
% a number of different sounds, as long as all the relavent sounds were
% selected in step 1.
%
%
% USE NOTES:
%
% 1. Name of Raven selection table must begin with name of folder the sound
% files are in.  This allows this action to recognize which sound is to be
% associated with the XBAT log.

result = struct;

if context.state.kill
    
    return;
    
end


% %% Match selections tables to sound(s)
% fn_match = cell(0);
% snd_name = sound_name(sound);
% IDX = strfind(context.state.fnRaven, snd_name);
% j = 0;
% 
% for i = 1:length(IDX)
%     
%     if IDX{i} == 1
%         
%         j = j + 1;
%         fn_match(j) = context.state.fnRaven(i);
%     end
% end
% 
% %% read in data from each CSV and save to MAT
% 
% %initializations
% num_raven = length(fn_match);
% pathRaven = context.state.pathRaven;
% logs = get_library_logs('info', [], sound);
% event_template = event_create;
% event_template.level = 1;
% event_template.author = context.user.name;
% 
% VarNamesAll={}; min_vec_all = []; max_vec_all = [];
% for i = 1:num_raven
%     
%     %open CSV file
%     curr_raven{i} = fn_match{i};
%     fid = fopen([pathRaven, curr_raven{i}], 'r');
%     
%     %make variable names from first line
%     line = fgetl(fid);
%     delim = findstr(line,sprintf('\t'));
%     delim = [0 delim length(line)+1];
%     NumVar = length(delim) - 1;
%     VarNames = cell(1,NumVar);
%     for j = 1:NumVar
%         
%         %replace or delete illegal characters in headers
%         %     VarNames(j) = {line(delim(j)+1:delim(j+1)-1)};
%         %     CurrentName = VarNames{j};
%         CurrentName = line(delim(j)+1:delim(j+1)-1);
%         CurrentName_fix = CurrentName(isstrprop(CurrentName,'alphanum'));
%         
%         if ~isvarname(CurrentName_fix)
%             fprintf(2,...
%                 '''%s'' is not a valid variable name. Script terminated.\n\n',...
%                 CurrentName);
%             return;
%         end
%         
%         VarNames{j} = CurrentName_fix;
%     end
%     
%     %read data into arrays
%     k = 0; Data = []; min_vec = nan(1,length(VarNames)); max_vec = nan(1,length(VarNames));
%     EmptyOut = cell(1,NumVar);
%     
%     
%     while ~feof(fid)
%         k = k + 1;
%         OutVector = EmptyOut;
%         line = fgetl(fid);
%         delim = findstr(line,sprintf('\t'));
%         
%         delim = [0 delim length(line)+1];
%         for j = 1:NumVar
%             OutVector(j) = {line(delim(j)+1:delim(j+1)-1)};
%             
%             %       Data(k) = {line(delim(k,j)+1:delim(j+1)-1)};
%             %       output.(CurrentName{1})(k) = {line(delim(j)+1:delim(j+1)-1)};
%         end
%         
%         Data = [Data; OutVector];
%     end
%     
%     %close Raven selection table
%     fclose(fid);
%     
%     
%     %% Filter lines in Raven selection table with Spectrogram 1 View
%     
%     ii = 1;
%     
%     while ii < length(VarNames) && ~strcmp(VarNames{ii}, 'View')
%         
%         ii = ii + 1;
%         
%     end
%     
%     raven_view = {};
%     if strcmp(VarNames{ii}, 'View')
%         
%         %         raven_view = Data(:,ii);
%         raven_view = Data(:,ii);
%     else
%         txt = 'Raven Selection Table does not have a Spectrogram 1 view.';
%         txt2 = sprintf('\n%s\n%s\n', txt, curr_raven{i});
%         fprintf(2, 'ERROR: %s', txt2);
%         wh = warndlg(txt2, 'ERROR');
%         movegui(wh, 'center')
%     end
%     
%     %     Data_clean = Data(strcmp(raven_view, 'Spectrogram 1'),:);
%     Data_clean(i).Data = Data(strcmp(raven_view, 'Spectrogram 1'),:);
%     [Dwid,Dlen] = size(Data_clean(i).Data);
%     for m = 3:Dlen
%       %  if not(isempty(str2num(cell2mat(Data_clean(i).Data(1,m)))))
%       try min_vec(m) = min(str2num(char(Data_clean(i).Data(:,m))));
%       catch
%           min_vec(m) = NaN;
%       end
%       try max_vec(m) = max(str2num(char(Data_clean(i).Data(:,m))));
%       catch
%           max_vec(m) = NaN;
%       end
%     end
%     
%     %% find event tags, if any
%     VarNamesAll = [VarNamesAll VarNames];
%     min_vec_all = [min_vec_all min_vec]; max_vec_all = [max_vec_all max_vec];
%     VarComp{i} = VarNames;
% end
% 
% %% Compare Selection Table Column Names to make sure they match
% for i = 1:length(VarComp)
%     for j = 1:length(VarComp)
%         % loop through variable names
%         focal_vars = VarComp{i};
%         comp_vars = VarComp{j};
%         for k = 1:length(focal_vars)
%             if not( strcmp(comp_vars, focal_vars{k}))
%                 wh = warndlg('Selection tables do not have identical column names. Action terminated', 'ERROR');
%                 movegui(wh, 'center')
%                 return;
%             end
%         end        
%     end
% end
% 
% %
% %% Make GUI
% %
% tag_ix = []; score_ix = []; rating_ix = [];
% bgcolor = [72 209 204]/255;
% raven2xbat_fig = figure('MenuBar','none','Name','Raven2XBAT','NumberTitle','off','Position',[200,200,700,600]);
% % set(raven2xbat_fig,'Color',[.8 .8 .9])
% set(raven2xbat_fig,'Color',bgcolor)
% 
% % Overall Heading
% uicontrol('Style','text','String','Raven2XBAT Converter','FontSize',15,'Position',[125,560,450,30],'BackgroundColor',bgcolor);
% % Get file with specgram correlation values
% uicontrol('Style','text','String','Raven selection table files:','FontSize',13,'Position',[25,520,250,30],'BackgroundColor',bgcolor);
% raven_table_handle = uicontrol('Style','listbox','String','None selected','value',[],'min',0,'max',2,'FontSize',12,'FontAngle','Italic','Position',[25,425,570,90],'CallBack',@Tablebutton);
% orig_tag_options =unique(VarNamesAll);
% % Eliminate tags that are common Raven column names
% common_names = {'Selection','View','Channel','BeginTimes','EndTimes','LowFreqHz','HighFreqHz','Q1FreqHz','Q1Times','Q3FreqHz','Q3Times','AggEntropyu','AvgEntropyu','AvgPowerdB','BW90Hz','BeginFile','BeginPath','CenterFreqHz','CenterTimes','DeltaFreqHz','DeltaPowerdB','DeltaTimes','Dur90s','EndFile','EndPath','EnergydB','FileOffsets','FRMSAmpu','Freq5Hz','Freq95Hz','IQRBWHz','IQRDurs','Lengthframes','MaxAmpu','MaxBearingdeg','MaxFreqHz','MaxPowerdB','MaxTimes',' MinAmpu','MinTimes','PeakAmpu','PeakCorru','PeakFreqHz','PeakLags','PeakPowerdB','PeakTimes','RMSAmpu','Time5s','Time95s'};
% necess_names = {'Selection','View','Channel','BeginTimes','EndTimes','LowFreqHz','HighFreqHz'};
% % Fill in Tag list
% tag_len = 0; tag_options = {};
% for y = 1:length(orig_tag_options)
%     t=strfind(common_names,orig_tag_options{y});
%     t_sum =0;
%     for x = 1:length(t)
%         t_sum = t_sum + not(isempty(t{x}));
%     end
%     if t_sum == 0
%         %save index
%         tag_len = tag_len+1;
%         tag_options{tag_len} =  orig_tag_options{y};
%     end
% end
% tag_len = 0; all_tag_options = {};
% for y = 1:length(orig_tag_options)
%     t=strfind(necess_names,orig_tag_options{y});
%     t_sum =0;
%     for x = 1:length(t)
%         t_sum = t_sum + not(isempty(t{x}));
%     end
%     if t_sum == 0
%         %save index
%         tag_len = tag_len+1;
%         all_tag_options{tag_len} =  orig_tag_options{y};
%     end
% end
% notes_tag_options = all_tag_options;
% tag_options = [{'None'} tag_options];
% all_tag_options = [{'None'} all_tag_options];
% uicontrol('Style','text','String','Chose selection table column to use as tags:','FontSize',13,'Position',[25,370,400,30],'BackgroundColor',bgcolor);
% tags_handle = uicontrol('Style','popup','String',all_tag_options,'value',1,'FontSize',12,'Position',[440,370,250,30],'CallBack',@Tagsbutton);
% % Get scores
% uicontrol('Style','text','String','Chose selection table column to use as scores:','FontSize',13,'Position',[25,320,400,30],'BackgroundColor',bgcolor);
% scores_handle = uicontrol('Style','popup','String',all_tag_options,'value',1,'FontSize',12,'Position',[440,320,250,30],'CallBack',@Scoresbutton);
% % Get ratings
% uicontrol('Style','text','String','Chose selection table column to use as ratings:','FontSize',13,'Position',[25,270,400,30],'BackgroundColor',bgcolor);
% ratings_handle = uicontrol('Style','popup','String',all_tag_options,'value',1,'FontSize',12,'Position',[440,270,250,30],'CallBack',@Ratingsbutton);
% % Initialize ratings boundaries 'Enable','off',
% r0_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,180,70,30]);
% r0_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,180,10,25],'BackgroundColor',bgcolor);
% r0_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,180,70,30]);
% %
% r1_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,145,70,30]);
% r1_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,145,10,25],'BackgroundColor',bgcolor);
% r1_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,145,70,30]);
% %
% r2_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,110,70,30]);
% r2_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,110,10,25],'BackgroundColor',bgcolor);
% r2_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,110,70,30]);
% %
% r3_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,75,70,30]);
% r3_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,75,10,25],'BackgroundColor',bgcolor);
% r3_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,75,70,30]);
% %
% r4_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,40,70,30]);
% r4_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,40,10,25],'BackgroundColor',bgcolor);
% r4_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,40,70,30]);
% %
% r5_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,5,70,30]);
% r5_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,5,10,25],'BackgroundColor',bgcolor);
% r5_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,5,70,30]);
% %
% % Make fill-in boxes with score values
% t1 = uicontrol('Style','text','String','Ratings Boundaries:','FontSize',13,'Position',[460,240,200,25],'BackgroundColor',bgcolor,'Enable','off');
% t2 = uicontrol('Style','text','String','Stars','FontSize',11,'Position',[425,215,50,25],'BackgroundColor',bgcolor,'Enable','off');
% t3 = uicontrol('Style','text','String','Greater or = to','FontSize',11,'Position',[480,215,115,25],'BackgroundColor',bgcolor,'Enable','off');
% t4 = uicontrol('Style','text','String','Less than','FontSize',11,'Position',[615,215,70,25],'BackgroundColor',bgcolor,'Enable','off');
% 
% t5 = uicontrol('Style','text','String','0','FontSize',13,'Position',[440,180,30,30],'BackgroundColor',bgcolor,'Enable','off');
% t6 = uicontrol('Style','text','String','1','FontSize',13,'Position',[440,145,30,30],'BackgroundColor',bgcolor,'Enable','off');
% t7 = uicontrol('Style','text','String','2','FontSize',13,'Position',[440,110,30,30],'BackgroundColor',bgcolor,'Enable','off');
% t8 = uicontrol('Style','text','String','3','FontSize',13,'Position',[440,75,30,30],'BackgroundColor',bgcolor,'Enable','off');
% t9 = uicontrol('Style','text','String','4','FontSize',13,'Position',[440,40,30,30],'BackgroundColor',bgcolor,'Enable','off');
% t10 = uicontrol('Style','text','String','5','FontSize',13,'Position',[440,5,30,30],'BackgroundColor',bgcolor,'Enable','off');
% t11 = uicontrol('Style','Pushbutton','String','?','FontSize',13,'Position',[660,240,25,25],'CallBack',@rating_q,'Enable','off');
% 
% % Select which columns go in notes section
% uicontrol('Style','text','String','Selection table columns included in log notes:','FontSize',13,'Position',[45,200,200,50],'BackgroundColor',bgcolor);
% % notes_handle = uicontrol('Style','checkbox','value',1,'Position',[440,90,30,30],'CallBack',@Notesbutton);
% notes_cols_handle = uicontrol('Style','listbox','String',notes_tag_options,'min',0,'max',length(notes_tag_options),'FontSize',12,'Position',[25,35,250,150],'CallBack',@NotesColsbutton);
% 
% % Button to start conversion
% run_handle = uicontrol('Style','Pushbutton','String','Run Converter','FontSize',14,'Value',0,'Position',[285,10,145,40],'CallBack',@Runbutton);
% 
% 
% %% Fill in Raven table names
% fnRaven = context.state.fnRaven; pathRaven = context.state.pathRaven;
% [c,r]=size(fnRaven);
% 
% if r == 1 && c==1
%     set(raven_table_handle, 'string', [pathRaven '\' char(fnRaven)]);
% else
%     for i = 1:r
%         % set(callback.control.handles, 'string', [pathRaven '\' fnRaven{i}]);
%         raven_array{i} =  [pathRaven '\' char(fnRaven{i})];
%     end
%     set(raven_table_handle, 'string', raven_array)
% end
% 
% 
% %% Fill in Notes column names
% set(notes_cols_handle,'Value',1:length(notes_tag_options));
% 
% 
% 
% %% Wait for user to run converter
% waitfor(run_handle,'FontAngle','Italic')
% close(raven2xbat_fig)
% 
% %% Get Selection Table column that has tag data
%     function Tagsbutton(raven2xbat_fig, ~)
%         tag_ix = get(tags_handle,'value');
%     end
% %% Get Selection Table column that has score data
%     function Scoresbutton(raven2xbat_fig, ~)
%         score_ix = get(scores_handle,'value');
%     end
% %% Get Selection Table column that has tag data
%     function Ratingsbutton(raven2xbat_fig, ~)
%         
%         if get(ratings_handle,'Value') > 1
%             set(t1,'Enable','on'); set(t2,'Enable','on'); set(t3,'Enable','on'); set(t4,'Enable','on'); set(t5,'Enable','on');
%             set(t6,'Enable','on'); set(t7,'Enable','on'); set(t8,'Enable','on'); set(t9,'Enable','on'); set(t10,'Enable','on'); set(t11,'Enable','on');
%             
%             % Get range of data for selected column
%             rating_ix = get(ratings_handle,'value');
%             ix = strmatch(all_tag_options{rating_ix},VarNamesAll);
%             temp_min=[]; temp_max=[];
%             if length(ix) == 1
%                 temp_min = min_vec_all(ix);
%                 temp_max = max_vec_all(ix);
%             else
%                 for yy = 1:length(ix)
%                     temp_min(yy) = min_vec_all(ix(yy));
%                     temp_max(yy) = max_vec_all(ix(yy));
%                 end
%             end
%             r_bounds(1) = nanmin(temp_min);
%             r_bounds(7) = nanmax(temp_max);
%             
%             if not(isnan(r_bounds(1))) && not(isnan(r_bounds(2)))
%                 range =  r_bounds(7) - r_bounds(1);
%                 step = range / 6;
%                 for fill = 2:6
%                     r_bounds(fill) = r_bounds(fill-1) + step;
%                 end
%                 r_bounds_names = num2cell(r_bounds);
%                 %
%                %
%             else
%                 for fill = 1:7
%                     r_bounds(fill) = NaN;
%                     r_bounds_names{fill} = [];
%                 end
%             end
%             %
%             set(r0_1_handle,'String',r_bounds_names{1});  set(r0_1_handle,'Enable','on');
%             set(r1_1_handle,'String',r_bounds_names{2});  set(r1_1_handle,'Enable','on');
%             set(r2_1_handle,'String',r_bounds_names{3});  set(r2_1_handle,'Enable','on');
%             set(r3_1_handle,'String',r_bounds_names{4});  set(r3_1_handle,'Enable','on');
%             set(r4_1_handle,'String',r_bounds_names{5});  set(r4_1_handle,'Enable','on');
%             set(r5_1_handle,'String',r_bounds_names{6});  set(r5_1_handle,'Enable','on');
%             %
%             set(r0_2_handle,'String',r_bounds_names{2});  set(r0_2_handle,'Enable','on');
%             set(r1_2_handle,'String',r_bounds_names{3});  set(r1_2_handle,'Enable','on');
%             set(r2_2_handle,'String',r_bounds_names{4});  set(r2_2_handle,'Enable','on');
%             set(r3_2_handle,'String',r_bounds_names{5});  set(r3_2_handle,'Enable','on');
%             set(r4_2_handle,'String',r_bounds_names{6});  set(r4_2_handle,'Enable','on');
%             set(r5_2_handle,'String',r_bounds_names{7});  set(r5_2_handle,'Enable','on');
%             %
%             set(r0_dash,'Enable','on');
%             set(r1_dash,'Enable','on');
%             set(r2_dash,'Enable','on');
%             set(r3_dash,'Enable','on');
%             set(r4_dash,'Enable','on');
%             set(r5_dash,'Enable','on');
%         else
%              r_bounds_names = cell(1,7);
%              r_bounds = nan(1,7);
% %             for fill = 1:7
% %                 r_bounds(fill) = NaN;
% %                 r_bounds_names{fill} = [];
% %             end
%             set(t1,'Enable','off'); set(t2,'Enable','off'); set(t3,'Enable','off'); set(t4,'Enable','off'); set(t5,'Enable','off');
%             set(t6,'Enable','off'); set(t7,'Enable','off'); set(t8,'Enable','off'); set(t9,'Enable','off'); set(t10,'Enable','off'); set(t10,'Enable','off');
%             set(r0_1_handle,'String',r_bounds_names{1}); set(r0_2_handle,'String',r_bounds_names{2}'); set(r1_1_handle,'String',r_bounds_names{2}'); set(r1_2_handle,'String',r_bounds_names{3}); set(r2_1_handle,'String',r_bounds_names{3}'); set(r2_2_handle,'String',r_bounds_names{4});
%             set(r3_1_handle,'String',r_bounds_names{4}); set(r3_2_handle,'String',r_bounds_names{5}); set(r4_1_handle,'String',r_bounds_names{5}); set(r4_2_handle,'String',r_bounds_names{6}); set(r5_1_handle,'String',r_bounds_names{6}'); set(r5_2_handle,'String',r_bounds_names{7});
%             set(r0_1_handle,'Enable','off'); set(r0_2_handle,'Enable','off'); set(r1_1_handle,'Enable','off'); set(r1_2_handle,'Enable','off'); set(r2_1_handle,'Enable','off'); set(r2_2_handle,'Enable','off');
%             set(r3_1_handle,'Enable','off'); set(r3_2_handle,'Enable','off'); set(r4_1_handle,'Enable','off'); set(r4_2_handle,'Enable','off'); set(r5_1_handle,'Enable','off'); set(r5_2_handle,'Enable','off');
%         end
%     end
% 
% %% Get Selection Table column that has score data
%     function Runbutton(raven2xbat_fig, ~)
%         
%         % intialize basic columns
%         % Selection_all = {};Channel_all = {};BeginTimes_all = {};EndTimes_all = {};LowFreqHz_all = {};HighFreqHz_all = {}; Tags_all = {}; Ratings_all = [];Scores_all = []; Notes_all={};
%         Ratings = [];Scores = []; Notes={}; Tags = {};
%         for z = 1:length(Data_clean)
%             %% extract columns from Raven selection table
%             status = 0;
%             [Selection, status] = extract_column(Data_clean(z).Data, VarNames, 'Selection', curr_raven{z}, status);
%             [Channel, status] = extract_column(Data_clean(z).Data, VarNames, 'Channel', curr_raven{z}, status);
%             [BeginTimes, status] = extract_column(Data_clean(z).Data, VarNames, 'BeginTimes', curr_raven{z}, status);
%             [EndTimes, status] = extract_column(Data_clean(z).Data, VarNames, 'EndTimes', curr_raven{z}, status);
%             [LowFreqHz, status] = extract_column(Data_clean(z).Data, VarNames, 'LowFreqHz', curr_raven{z}, status);
%             [HighFreqHz, status] = extract_column(Data_clean(z).Data, VarNames, 'HighFreqHz', curr_raven{z}, status);
%             
%             %%% Get other user-selected event fields
%             if get(tags_handle,'value') ~= 1
%                 Tags = extract_column(Data_clean(z).Data, VarNames, all_tag_options{get(tags_handle,'value')}, curr_raven{z}, status);
%                 % Go through and make sure no spaces in tags
%                 for mm = 1:length(Tags)
%                     blanks = strfind(Tags{mm},' ');
%                     if not(isempty(blanks))
%                         orig = Tags{mm};
%                         orig(blanks) = '_';
%                         Tags{mm} = orig;
%                     end
%                 end
%             end
%             if get(ratings_handle,'value') ~= 1
%                 Ratings_init = extract_column(Data_clean(z).Data, VarNames, all_tag_options{get(ratings_handle,'value')}, curr_raven{z}, status);
%                 % convert to 0-5
%                 Ratings = zeros(1,length(Ratings_init));
%                 for pp = 1:length(Ratings_init)
%                     rate = str2num(Ratings_init{pp});
%                     if not(isempty(rate))
%                         if not(isempty(str2double(get(r0_2_handle,'String')))) && rate < str2double(get(r0_2_handle,'String'))
%                             Ratings(pp) = 0;
%                         elseif not(isempty(str2double(get(r1_2_handle,'String')))) && rate < str2double(get(r1_2_handle,'String'))
%                             Ratings(pp) = 1;
%                         elseif not(isempty(str2double(get(r2_2_handle,'String')))) && rate < str2double(get(r2_2_handle,'String'))
%                             Ratings(pp) = 2;
%                         elseif not(isempty(str2double(get(r3_2_handle,'String')))) && rate < str2double(get(r3_2_handle,'String'))
%                             Ratings(pp) = 3;
%                         elseif not(isempty(str2double(get(r4_2_handle,'String')))) && rate < str2double(get(r4_2_handle,'String'))
%                             Ratings(pp) = 4;
%                         elseif not(isempty(str2double(get(r5_2_handle,'String'))))
%                             Ratings(pp) = 5;
%                         else
%                             Ratings(pp) = 0;
%                         end
%                     end
%                 end
%                 
%                 % get(r1_handle,'String')
%             end
%             if get(scores_handle,'value') ~= 1
%                 Scores = extract_column(Data_clean(z).Data, VarNames, all_tag_options{get(scores_handle,'value')}, curr_raven{z}, status);
%                 Scores = str2num(char(Scores));
%             end
%             
%             notes_cols_ix = get(notes_cols_handle,'Value');
%             for nn = 1:length(notes_cols_ix)
%                 Notes(:,nn) = extract_column(Data_clean(z).Data, VarNames, notes_tag_options{nn}, curr_raven{z}, status);
%             end
%             
%             if status
%                 return;
%             end
%             
%             
%             %%% create XBAT events
%             log_length = size(Selection,1);
%             event(1:log_length) = event_template;
%             
%             for jj = 1:log_length
%                 
%                 event(jj).time = [str2double(BeginTimes(jj)), str2double(EndTimes(jj))];
%                 event(jj).duration = diff(event(jj).time);
%                 event(jj).freq = [str2double(LowFreqHz(jj)), str2double(HighFreqHz(jj))];
%                 event(jj).bandwidth = diff(event(jj).freq);
%                 event(jj).id =  str2double(Selection(jj));
%                 event(jj).channel = str2double(Channel(jj));
%                 
%                 if not(isempty(Tags))
%                     event(jj).tags = Tags(jj);
%                 else
%                     event(jj).tags = {};
%                 end
%                 if not(isempty(Scores))
%                     event(jj).score = Scores(jj);
%                 else
%                     event(jj).score = [];
%                 end
%                 if not(isempty(Ratings))
%                     event(jj).rating = Ratings(1,jj);
%                 else
%                     event(jj).rating = [];
%                 end
%                 if not(isempty(Notes))
%                     temp_notes = {};
%                     for zz = 1:length(notes_cols_ix)
%                         temp_notes{notes_cols_ix(zz)} = [char(notes_tag_options{notes_cols_ix(zz)}) ': ' char(Notes(jj,zz))] ;
%                     end
%                     event(jj).notes = temp_notes;
%                 else
%                     event(jj).notes = {};
%                 end
%             end
%             
%             
%             %%% create XBAT log
%             fn_raven = char(curr_raven{z});
%             fn_raven = fn_raven(1:end-4);
%             fn_xbat = fn_raven(isstrprop(fn_raven,'alphanum') | fn_raven=='_');
%             %   fn_w_Path = fullfile(snd_name, fn_xbat);
%             %   if ismember(fn_w_Path, logs)
%             
%             fn_xbat = [fn_xbat, '_', datestr(now, 'yyyymmddTHHMMSSFFF')];
%             
%             NewLog = new_log(fn_xbat, context.user, context.library, sound);
%             NewLog.event = event;
%             NewLog.length = log_length;
%             NewLog.curr_id = log_length + 1;
%             NewLog.userdata.notes_categories = notes_tag_options;
%             NewLog.userdata.tags = all_tag_options{get(tags_handle,'value')};
%             NewLog.userdata.scores = all_tag_options{get(scores_handle,'value')};
%             NewLog.userdata.ratings = all_tag_options{get(ratings_handle,'value')};
%             log_save(NewLog);
%             disp('New XBAT log saved')
%         end
%         % Change handle value so GUI can close
%         set(run_handle,'FontAngle','Italic');
%     end
% 
% %% Create Notes Section Data
%     function NotesColsbutton(raven2xbat_fig, ~)
%         cols_ix = get(notes_cols_handle,'Value');
%     end
% 
% %% Give explanation for ratings if necessary
%     function rating_q(raven2xbat_fig, ~)
%         helpdlg('Rating bundaries are set at equal intervals between the min and max of the column used as Ratings.  Ratings boundaries will be blank if a non-numeric column selected.')
%     end
% %% Don't let use select Raven tables
%     function Tablebutton(raven2xbat_fig, ~)
%         set(raven_table_handle,'Value',[]);
%     end
% %% User changed R-bounds data
% %     function R1_fill(raven2xbat_fig, ~)
% %         R1_val = get(r1_handle,'String');
% %         set(r1_handle,'String',R1_val);
% %     end
% %     function R2_fill(raven2xbat_fig, ~)
% %         R2_val = get(r2_handle,'String');
% %         set(r2_handle,'String',R2_val);
% %     end
% %     function R3_fill(raven2xbat_fig, ~)
% %         R3_val = get(r3_handle,'String');
% %         set(r3_handle,'String',R3_val);
% %     end
% %     function R4_fill(raven2xbat_fig, ~)
% %         R4_val = get(r4_handle,'String');
% %         set(r4_handle,'String',R4_val);
% %     end
% %     function R5_fill(raven2xbat_fig, ~)
% %         R5_val = get(r5_handle,'String');
% %         set(r5_handle,'String',R5_val);
% %     end
% %     function R6_fill(raven2xbat_fig, ~)
% %         R6_val = get(r6_handle,'String');
% %         set(r6_handle,'String',R6_val);
% %     end
% %     function R7_fill(raven2xbat_fig, ~)
% %         R7_val = get(r7_handle,'String');
% %         set(r7_handle,'String',R7_val);
% %     end
% 
% %% Get specific columns to include in notes
%     function Notesbutton(raven2xbat_fig, ~)
%         % Use this if access to Notes section disabled
%         %   set(notes_cols_handle,'Value',[]);
%         %         if get(notes_handle,'Value') == 0
%         %             rem_tag_options = tag_options;
%         %
%         %             if not(isempty(rating_ix))
%         %                 rem_ix = strmatch(tag_options{rating_ix}, rem_tag_options);
%         %                 rem_tag_options(rem_ix) = [];
%         %             end
%         %             if not(isempty(score_ix))
%         %                 rem_ix = strmatch(tag_options{score_ix}, rem_tag_options);
%         %                 rem_tag_options(rem_ix) = [];
%         %             end
%         %             if not(isempty(tag_ix))
%         %                 rem_ix = strmatch(tag_options{tag_ix}, rem_tag_options);
%         %                 rem_tag_options(rem_ix) = [];
%         %             end
%         %             rem_tag_options(1) = [];
%         %
%         %             uicontrol('Style','text','String','Manually select columns:','FontSize',13,'Position',[25,50,250,30]);
%         %            % notes_cols_handle = uicontrol('Style','list','String',rem_tag_options,'max',length(rem_tag_options),'min',0,'FontSize',12,'Position',[270,10,200,80],'CallBack',@NotesColsbutton);
%         %             set(notes_cols_handle,'String',rem_tag_options);
%         %             set(notes_cols_handle,'Enable','on');
%         %             set(notes_cols_handle,'max',length(rem_tag_options));
%         %          end
%     end
% 
% %% Get data from column of Raven selection table
%     function [vec, status] = extract_column(mat, VarNames, var_selection, curr_raven, status)
%         
%         if status
%             return;
%         end
%         % extract column in mat with VarName equal var_selection into vec
%         ii = 1;
%         
%         while ii < length(VarNames) && ~strcmp(VarNames{ii}, var_selection)
%             ii = ii + 1;
%         end
%         
%         if strcmp(VarNames{ii}, var_selection)
%             vec = mat(:,ii);
%         else
%             status = 1;
%             txt = sprintf('Raven Selection Table does not have a column named %s', var_selection);
%             txt2 = sprintf('\n%s\n%s\n', txt, curr_raven);
%             fprintf(2, 'ERROR: %s', txt2);
%             wh = warndlg(txt2, 'ERROR');
%             movegui(wh, 'center')
%         end
%         
%         disp(' ')
%     end
% 
% 
% end