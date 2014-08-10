function [result, context] = prepare(parameter, context)

% RAVEN2XBAT_BATCH - prepare

result = struct;
context.state.kill = 0;


% Make sure sound window isn't open
h = get_xbat_figs('type','sound');
if not(isempty(h))
    d = sprintf('\nRaven2XBAT cannot run while sound windows are open.  Please close sound windows and try again.');
    fprintf(2,d);
    h=warndlg(d, 'Raven2XBAT_v2');
    movegui(h, 'center') 
    context.state.kill = 1;
    return;
end

%% request Raven Selection Tables to convert to MAT
d='Select Raven Selection Tables to convert to XBAT logs';
[fnRaven,pathRaven]=uigetfile2_SCK('*.txt', d,'MultiSelect','on');

% abort script if no Raven Selection Tables selected
if (isequal(fnRaven,0) || isequal(pathRaven,0))
    
    d = sprintf('\n\nNo Raven Selection Tables selected. Raven2XBAT_v2 terminated.\n\n');
    fprintf(2,d);
    h=warndlg(d, 'Raven2XBAT_V2');
    movegui(h, 'center') 
    context.state.kill = 1;
    return;
    
end

% fix single element cell bug
if ~iscell(fnRaven)
    fnRaven = {fnRaven};
end

context.state.fnRaven = fnRaven;
context.state.pathRaven = pathRaven;


%% make sure at least one sound has ST(s) before asking user about each sound
snd_cnt = 0;
snd_name = sound_name(context.target);
if ~iscell(snd_name)
    snd_name = {snd_name};
end
num_sounds = length(snd_name);
snd_name_len = zeros(num_sounds,1);
for j = 1:num_sounds
    snd_name_len(j) = length(snd_name{j});
end
num_raven = length(fnRaven);

for i = 1:num_sounds
    test_flag = 0;
    for j = 1:num_raven
        
        try cmp_test = strcmp(snd_name{i}, fnRaven{j}(1:snd_name_len(i)));
            if cmp_test
                test_flag = test_flag + 1;
            end
        catch err
        end
    end
    if test_flag > 0
        snd_cnt = snd_cnt + 1;
    end
end

% if no Sounds have STs, alert user then quit
if snd_cnt == 0
    d = sprintf('\n\nNone of the selected sounds have matching Raven Selection Tables. Raven2XBAT_v2 terminated.\n\n');
    fprintf(2,d);
    h=warndlg(d, 'Raven2XBAT_V2');
    movegui(h, 'center') 
    context.state.kill = 1;
    return;
end



%% check if any Raven selection tables have names that do not start with one of the selected sound names
ignore_flag = 1;
for i = 1:num_raven
    
    j = 1; temp_test = 1;
    while j < num_sounds && temp_test
        
        try temp_name =  fnRaven{i}(1:snd_name_len(j));
            
            if ~strcmp(snd_name{j},temp_name);
                j = j + 1;
            else
                temp_test = 0;
            end
        catch err
            temp_test = 0;
        end
    end
    
    try mismatch_test = ~strcmp(snd_name{j}, fnRaven{i}(1:snd_name_len(j)));
        
    catch err
        mismatch_test = 1;
    end
    
    if mismatch_test;  %~strcmp(snd_name{j}, fnRaven{i}(1:snd_name_len(j)))
        
        if num_raven == 1
            txt = sprintf('The selection table ''%s'' does not match the selected sound(s). Try renaming the selection table file.\n\nConversion cancelled.', fnRaven{i});
            wh = warndlg(txt, 'ERROR');
            movegui(wh, 'center') 
        else
            if ignore_flag
                str1 = 'Omit selection table and continue, but warn me about other mismatches';
                str2 = 'Omit selection table and continue, don''t warn me about other mismatches';
                str3 = 'Cancel all conversions and quit';
                txt = sprintf('None of the selected sounds match Selection Table:\n\n''%s''\n\nThis may be caused by an incorrect selection table name.', fnRaven{i});
                % Make Question Dialog
                wh = questdlg_SCK(txt, ...
                    'Selection table mismatch', ...
                    str1,str2,str3, 3);
            end
        end
        
        switch wh
            case str1
                ignore_flag = 1;
                fnRaven{i} = ' ';
            case str2
                ignore_flag = 0;
                fnRaven{i} = ' ';
            case str3
                return
        end
        
    end
end
context.state.fnRaven = fnRaven;


comp_cnt = 0;
% loop through sound to make sure each has a selection table
ignore_flag = 1;
for i = 1:num_sounds
    test_flag = 0;
    for j = 1:num_raven
        
        try cmp_test = strcmp(snd_name{i}, fnRaven{j}(1:snd_name_len(i)));
            if cmp_test
                test_flag = test_flag + 1;
            end
        catch err
        end
    end
    if test_flag == 0;
        
        if num_raven == 1
            txt = sprintf('The sound ''%s'' does not match any of the input selection tables. Try renaming the selection table file(s) if this is unexpected.\n\nConversion cancelled.', snd_name{i});
            wh = warndlg(txt, 'ERROR');
            movegui(h, 'center') 
        else
            if ignore_flag
                str1 = 'Omit sound and continue, but warn me about other mismatches';
                str2 = 'Omit sound and continue, don''t warn me about other mismatches';
                str3 = 'Cancel all conversions and quit';
                txt = sprintf('None of the chosen selection tables match Sound:\n\n''%s''\n\nThis may be caused by an incorrect selection table name.', snd_name{i});
                % Make Question Dialog
                wh = questdlg_SCK(txt, ...
                    'Selection table mismatch', ...
                    str1,str2,str3, 3);
            end
        end
        
        switch wh
            case str1
                ignore_flag = 1;
                snd_name{i} = ' ';
            case str2
                ignore_flag = 0;
                snd_name{i} = ' ';
            case str3
                return
        end
        
    end
end


%% check if any of the sound names are a subset of another sound name
for i = 1:num_sounds
    for j = i+1:num_sounds
        
        curr_len = min(length(snd_name{i}), length(snd_name{j}));
        
        if curr_len > 1
            if strcmp(snd_name{i}(1:curr_len), snd_name{j}(1:curr_len))
                txt = 'Two sounds begin with the same characters.  Action terminated.';
                txt2 = sprintf(2,'\n%s\n  %s\n  %s\n', txt, snd_name{i}, snd_name{j});
                fprintf(2,'ERROR: %s\n', txt2);
                wh = warndlg(txt2, 'WARNING');
                movegui(wh, 'center')
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moved in from compute function
soundname = snd_name;
clear snd_name
all_raven_tables = cell(0);
tables = 0; VarNamesAll={}; min_vec_all = []; max_vec_all = [];

for sound = 1:length(context.target)
    %% Match selections tables to sound(s)
    fn_match = cell(0);
    %snd_name = sound_name(sound);
    snd_name = soundname{sound};
    if not(strcmp(snd_name,' '))
        IDX = strfind(context.state.fnRaven, snd_name);
        j = 0;
        
        for i = 1:length(IDX)
            if IDX{i} == 1
                j = j + 1;
                fn_match(j) = context.state.fnRaven(i);
                tables = tables+1;
                all_raven_tables(tables) =  context.state.fnRaven(i);
            end
        end
        
        %% read in data from each CSV and save to MAT
        
        %initializations
        num_raven = length(fn_match);
        pathRaven = context.state.pathRaven;
        %logs = get_library_logs('info', [], sound);
        event_template = event_create;
        event_template.level = 1;
        event_template.author = context.user.name;
        
        Data_clean = struct();
        curr_raven = [];
        headers = {};
        
        for i = 1:num_raven
            
            %open CSV file
            curr_raven{i} = fn_match{i};
            fid = fopen([pathRaven, curr_raven{i}], 'r');
            
            %make variable names from first line
            line = fgetl(fid);
            delim = findstr(line,sprintf('\t'));
            delim = [0 delim length(line)+1];
            NumVar = length(delim) - 1;
            VarNames = cell(1,NumVar);
            for j = 1:NumVar
                
                CurrentName = line(delim(j)+1:delim(j+1)-1);
                CurrentName_fix = CurrentName(isstrprop(CurrentName,'alphanum'));
                
                if ~isvarname(CurrentName_fix)
                    fprintf(2,...
                        '''%s'' is not a valid variable name. Script terminated.\n\n',...
                        CurrentName);
                    return;
                end
                
                VarNames{j} = CurrentName_fix;
            end
            
            %read data into arrays
            k = 0; Data = []; min_vec = nan(1,length(VarNames)); max_vec = nan(1,length(VarNames));
            EmptyOut = cell(1,NumVar);
            
            
            while ~feof(fid)
                k = k + 1;
                OutVector = EmptyOut;
                line = fgetl(fid);
                delim = findstr(line,sprintf('\t'));
                
                delim = [0 delim length(line)+1];
                for j = 1:NumVar
                    OutVector(j) = {line(delim(j)+1:delim(j+1)-1)};
                end
                
                Data = [Data; OutVector];
            end
            
            %close Raven selection table
            fclose(fid);
            
            
            %% Filter lines in Raven selection table with Spectrogram 1 View
            
            ii = 1;
            
            while ii < length(VarNames) && ~strcmp(VarNames{ii}, 'View')
                ii = ii + 1;
            end
            
            raven_view = {};
            if strcmp(VarNames{ii}, 'View')
                if not(isempty(Data))
                    raven_view = Data(:,ii);
                end
            else
                txt = 'Raven Selection Table does not have a Spectrogram 1 view.';
                txt2 = sprintf('\n%s\n%s\n', txt, curr_raven{i});
                fprintf(2, 'ERROR: %s', txt2);
                wh = warndlg(txt2, 'ERROR');
                movegui(wh, 'center')
            end
            
            % Get all entries in current selection table
            Data_clean(i).Data = Data(strcmp(raven_view, 'Spectrogram 1'),:);
            [Dwid,Dlen] = size(Data_clean(i).Data);
            for m = 3:Dlen
                if sum(sum(isletter(char(Data_clean(i).Data(:,m))))) == 0
                    try min_vec(m) = min(str2num(char(Data_clean(i).Data(:,m))));
                    catch err
                        min_vec(m) = NaN;
                    end
                    try max_vec(m) = max(str2num(char(Data_clean(i).Data(:,m))));
                    catch err
                        max_vec(m) = NaN;
                    end
                else
                    min_vec(m) = NaN;
                end
            end
            
            %% find event tags, if any
            VarNamesAll = [VarNamesAll VarNames];
            min_vec_all = [min_vec_all min_vec]; max_vec_all = [max_vec_all max_vec];
            comp_cnt = comp_cnt + 1;
            VarComp{comp_cnt} = VarNames;
            headers{i} = VarNames;
        end
        All_sound_data(sound).Data_clean = Data_clean;
        All_sound_data(sound).Raven_tables = curr_raven;
        All_sound_data(sound).Raven_headers = headers;
        clear Data_clean
    end
end


%% Compare Selection Table Column Names to make sure they match
mismatch_flag = 0;
for i = 1:length(VarComp)
    for j = 1:length(VarComp)
        % loop through variable names
        focal_vars = VarComp{i};
        comp_vars = VarComp{j};
        for k = 1:length(focal_vars)
            if not( strcmp(comp_vars, focal_vars{k}))
                mismatch_flag = 1;
            end
        end
    end
end
% wh = warndlg('Selection tables do not have identical column names. Action
% terminated', 'ERROR');
if mismatch_flag == 1
    wh = questdlg('Selection tables'' column headers are not identical.  If you proceed with the Raven2XBAT conversion, values from missing columns will remain blank in XBAT log. Do you wish to continue conversion?','Warning','Continue','Exit','Continue');
    %movegui(wh, 'center')
    if strcmpi(wh, 'Exit')
        return;
    end
end
%

%% Make GUI
%
tag_ix = []; score_ix = []; rating_ix = [];

bgcolor = [176 196 222]/255;
%bgcolor = [72 209 204]/255;
raven2xbat_fig = figure('MenuBar','none','Name','Raven2XBAT','NumberTitle','off','Position',[200,200,700,600]);
% set(raven2xbat_fig,'Color',[.8 .8 .9])
set(raven2xbat_fig,'Color',bgcolor)

% Overall Heading
uicontrol('Style','text','String','Raven2XBAT Converter','FontSize',15,'Position',[125,560,450,30],'BackgroundColor',bgcolor);
% Get file with specgram correlation values
uicontrol('Style','text','String','Raven selection table files:','FontSize',13,'Position',[25,520,250,30],'BackgroundColor',bgcolor);
raven_table_handle = uicontrol('Style','listbox','String','None selected','value',[],'min',0,'max',2,'FontSize',12,'FontAngle','Italic','Position',[15,425,670,90],'CallBack',@Tablebutton);
orig_tag_options =unique_no_sort(VarNamesAll);  %%% was just unique, changed 9/11/12
% Eliminate tags that are common Raven column names
common_names = {'Selection','View','Channel','BeginTimes','EndTimes','LowFreqHz','HighFreqHz','Q1FreqHz','Q1Times','Q3FreqHz','Q3Times','AggEntropyu','AvgEntropyu','AvgPowerdB','BW90Hz','BeginFile','BeginPath','CenterFreqHz','CenterTimes','DeltaFreqHz','DeltaPowerdB','DeltaTimes','Dur90s','EndFile','EndPath','EnergydB','FileOffsets','FRMSAmpu','Freq5Hz','Freq95Hz','IQRBWHz','IQRDurs','Lengthframes','MaxAmpu','MaxBearingdeg','MaxFreqHz','MaxPowerdB','MaxTimes',' MinAmpu','MinTimes','PeakAmpu','PeakCorru','PeakFreqHz','PeakLags','PeakPowerdB','PeakTimes','RMSAmpu','Time5s','Time95s'};
necess_names = {'Selection','View','Channel','BeginTimes','EndTimes','LowFreqHz','HighFreqHz'};
% Fill in Tag list
tag_len = 0; tag_options = {};
for y = 1:length(orig_tag_options)
    t=strfind(common_names,orig_tag_options{y});
    t_sum =0;
    for x = 1:length(t)
        t_sum = t_sum + not(isempty(t{x}));
    end
    if t_sum == 0
        %save index
        tag_len = tag_len+1;
        tag_options{tag_len} =  orig_tag_options{y};
    end
end
tag_len = 0; all_tag_options = {};
for y = 1:length(orig_tag_options)
    t=strfind(necess_names,orig_tag_options{y});
    t_sum =0;
    for x = 1:length(t)
        t_sum = t_sum + not(isempty(t{x}));
    end
    if t_sum == 0
        %save index
        tag_len = tag_len+1;
        all_tag_options{tag_len} =  orig_tag_options{y};
    end
end
notes_tag_options = all_tag_options;
tag_options = [{'None'} tag_options];
all_tag_options = [{'None'} all_tag_options];
uicontrol('Style','text','String','Chose selection table column to use as tags:','FontSize',13,'Position',[25,370,400,30],'BackgroundColor',bgcolor);
tags_handle = uicontrol('Style','popup','String',all_tag_options,'value',1,'FontSize',12,'Position',[440,370,250,30],'CallBack',@Tagsbutton);
% Get scores
uicontrol('Style','text','String','Chose selection table column to use as scores:','FontSize',13,'Position',[25,320,400,30],'BackgroundColor',bgcolor);
scores_handle = uicontrol('Style','popup','String',all_tag_options,'value',1,'FontSize',12,'Position',[440,320,250,30],'CallBack',@Scoresbutton);
% Get ratings
uicontrol('Style','text','String','Chose selection table column to use as ratings:','FontSize',13,'Position',[25,270,400,30],'BackgroundColor',bgcolor);
ratings_handle = uicontrol('Style','popup','String',all_tag_options,'value',1,'FontSize',12,'Position',[440,270,250,30],'CallBack',@Ratingsbutton);
% Initialize ratings boundaries 'Enable','off',
r0_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,180,70,30]);
r0_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,180,10,25],'BackgroundColor',bgcolor);
r0_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,180,70,30]);
%
r1_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,145,70,30]);
r1_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,145,10,25],'BackgroundColor',bgcolor);
r1_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,145,70,30]);
%
r2_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,110,70,30]);
r2_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,110,10,25],'BackgroundColor',bgcolor);
r2_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,110,70,30]);
%
r3_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,75,70,30]);
r3_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,75,10,25],'BackgroundColor',bgcolor);
r3_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,75,70,30]);
%
r4_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,40,70,30]);
r4_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,40,10,25],'BackgroundColor',bgcolor);
r4_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,40,70,30]);
%
r5_1_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[505,5,70,30]);
r5_dash = uicontrol('Style','text','String','-','FontSize',15,'Enable','off','Position',[590,5,10,25],'BackgroundColor',bgcolor);
r5_2_handle = uicontrol('Style','edit','String','','FontSize',12,'Enable','off','Position',[615,5,70,30]);
%
% Make fill-in boxes with score values
t1 = uicontrol('Style','text','String','Ratings Boundaries:','FontSize',13,'Position',[460,240,200,25],'BackgroundColor',bgcolor,'Enable','off');
t2 = uicontrol('Style','text','String','Stars','FontSize',11,'Position',[425,215,50,25],'BackgroundColor',bgcolor,'Enable','off');
t3 = uicontrol('Style','text','String','Greater or = to','FontSize',11,'Position',[480,215,115,25],'BackgroundColor',bgcolor,'Enable','off');
t4 = uicontrol('Style','text','String','Less than','FontSize',11,'Position',[615,215,70,25],'BackgroundColor',bgcolor,'Enable','off');

t5 = uicontrol('Style','text','String','0','FontSize',13,'Position',[440,180,30,30],'BackgroundColor',bgcolor,'Enable','off');
t6 = uicontrol('Style','text','String','1','FontSize',13,'Position',[440,145,30,30],'BackgroundColor',bgcolor,'Enable','off');
t7 = uicontrol('Style','text','String','2','FontSize',13,'Position',[440,110,30,30],'BackgroundColor',bgcolor,'Enable','off');
t8 = uicontrol('Style','text','String','3','FontSize',13,'Position',[440,75,30,30],'BackgroundColor',bgcolor,'Enable','off');
t9 = uicontrol('Style','text','String','4','FontSize',13,'Position',[440,40,30,30],'BackgroundColor',bgcolor,'Enable','off');
t10 = uicontrol('Style','text','String','5','FontSize',13,'Position',[440,5,30,30],'BackgroundColor',bgcolor,'Enable','off');
t11 = uicontrol('Style','Pushbutton','String','?','FontSize',13,'Position',[660,240,25,25],'CallBack',@rating_q,'Enable','off');

% Select which columns go in notes section
uicontrol('Style','text','String','Selection table columns to include in log notes:','FontSize',13,'Position',[45,200,200,50],'BackgroundColor',bgcolor);
% notes_handle = uicontrol('Style','checkbox','value',1,'Position',[440,90,30,30],'CallBack',@Notesbutton);
notes_cols_handle = uicontrol('Style','listbox','String',all_tag_options,'min',0,'max',length(all_tag_options) + 1,'FontSize',12,'Position',[25,35,250,150],'CallBack',@NotesColsbutton);

% Button to start conversion
run_handle = uicontrol('Style','Pushbutton','String','Run Converter','FontSize',14,'Value',0,'Position',[285,10,145,40],'CallBack',@Runbutton);


%% Fill in Raven table names
fnRaven_temp = context.state.fnRaven; pathRaven = context.state.pathRaven;

cnt = 0; fnRaven = {};
for r = 1:length(fnRaven_temp)
    if not(strcmp(' ',char(fnRaven_temp{r})))
        cnt = cnt + 1;
        fnRaven{cnt} = fnRaven_temp{r};
    end
end

[c,r]=size(fnRaven);
if r == 1 && c==1
    set(raven_table_handle, 'string', [pathRaven char(fnRaven)]);
else
    for i = 1:r
        % set(callback.control.handles, 'string', [pathRaven '\' fnRaven{i}]);
        raven_array{i} =  [pathRaven char(fnRaven{i})];
    end
    set(raven_table_handle, 'string', raven_array)
end


%% Fill in Notes column names
set(notes_cols_handle,'Value',1);

%% Create close request fcn
set(raven2xbat_fig,'CloseRequestFcn',@my_closefcn)

%% Wait for user to run converter....
waitfor(run_handle,'FontAngle','Italic')
close(raven2xbat_fig)

%% Get Selection Table column that has tag data
    function Tagsbutton(~, ~)
        tag_ix = get(tags_handle,'value');
    end
%% Get Selection Table column that has score data
    function Scoresbutton(~, ~)
        score_ix = get(scores_handle,'value');
    end
%% Set up ratings button
    function Ratingsbutton(~, ~)
        
        if get(ratings_handle,'Value') > 1
            set(t1,'Enable','on'); set(t2,'Enable','on'); set(t3,'Enable','on'); set(t4,'Enable','on'); set(t5,'Enable','on');
            set(t6,'Enable','on'); set(t7,'Enable','on'); set(t8,'Enable','on'); set(t9,'Enable','on'); set(t10,'Enable','on'); set(t11,'Enable','on');
            
            % Get range of data for selected column
            rating_ix = get(ratings_handle,'value');
            ix = strmatch(all_tag_options{rating_ix},VarNamesAll);
            temp_min=[]; temp_max=[];
            if length(ix) == 1
                temp_min = min_vec_all(ix);
                temp_max = max_vec_all(ix);
            else
                for yy = 1:length(ix)
                    temp_min(yy) = min_vec_all(ix(yy));
                    temp_max(yy) = max_vec_all(ix(yy));
                end
            end
            r_bounds(1) = nanmin(temp_min);
            r_bounds(7) = nanmax(temp_max);
            
            if not(isnan(r_bounds(1))) && not(isnan(r_bounds(2)))
                range =  r_bounds(7) - r_bounds(1);
                step = range / 6;
                for fill = 2:6
                    r_bounds(fill) = r_bounds(fill-1) + step;
                end
                r_bounds_names = num2cell(r_bounds);
            else
                for fill = 1:7
                    r_bounds(fill) = NaN;
                    r_bounds_names{fill} = [];
                end
            end
            %
            set(r0_1_handle,'String',r_bounds_names{1});  set(r0_1_handle,'Enable','on');
            set(r1_1_handle,'String',r_bounds_names{2});  set(r1_1_handle,'Enable','on');
            set(r2_1_handle,'String',r_bounds_names{3});  set(r2_1_handle,'Enable','on');
            set(r3_1_handle,'String',r_bounds_names{4});  set(r3_1_handle,'Enable','on');
            set(r4_1_handle,'String',r_bounds_names{5});  set(r4_1_handle,'Enable','on');
            set(r5_1_handle,'String',r_bounds_names{6});  set(r5_1_handle,'Enable','on');
            %
            set(r0_2_handle,'String',r_bounds_names{2});  set(r0_2_handle,'Enable','on');
            set(r1_2_handle,'String',r_bounds_names{3});  set(r1_2_handle,'Enable','on');
            set(r2_2_handle,'String',r_bounds_names{4});  set(r2_2_handle,'Enable','on');
            set(r3_2_handle,'String',r_bounds_names{5});  set(r3_2_handle,'Enable','on');
            set(r4_2_handle,'String',r_bounds_names{6});  set(r4_2_handle,'Enable','on');
            set(r5_2_handle,'String',r_bounds_names{7});  set(r5_2_handle,'Enable','on');
            %
            set(r0_dash,'Enable','on'); set(r1_dash,'Enable','on'); set(r2_dash,'Enable','on'); set(r3_dash,'Enable','on'); set(r4_dash,'Enable','on');set(r5_dash,'Enable','on');
        else
            r_bounds_names = cell(1,7);
            r_bounds = nan(1,7);
            
            set(t1,'Enable','off'); set(t2,'Enable','off'); set(t3,'Enable','off'); set(t4,'Enable','off'); set(t5,'Enable','off');
            set(t6,'Enable','off'); set(t7,'Enable','off'); set(t8,'Enable','off'); set(t9,'Enable','off'); set(t10,'Enable','off'); set(t10,'Enable','off');
            set(r0_1_handle,'String',r_bounds_names{1}); set(r0_2_handle,'String',r_bounds_names{2}'); set(r1_1_handle,'String',r_bounds_names{2}'); set(r1_2_handle,'String',r_bounds_names{3}); set(r2_1_handle,'String',r_bounds_names{3}'); set(r2_2_handle,'String',r_bounds_names{4});
            set(r3_1_handle,'String',r_bounds_names{4}); set(r3_2_handle,'String',r_bounds_names{5}); set(r4_1_handle,'String',r_bounds_names{5}); set(r4_2_handle,'String',r_bounds_names{6}); set(r5_1_handle,'String',r_bounds_names{6}'); set(r5_2_handle,'String',r_bounds_names{7});
            set(r0_1_handle,'Enable','off'); set(r0_2_handle,'Enable','off'); set(r1_1_handle,'Enable','off'); set(r1_2_handle,'Enable','off'); set(r2_1_handle,'Enable','off'); set(r2_2_handle,'Enable','off');
            set(r3_1_handle,'Enable','off'); set(r3_2_handle,'Enable','off'); set(r4_1_handle,'Enable','off'); set(r4_2_handle,'Enable','off'); set(r5_1_handle,'Enable','off'); set(r5_2_handle,'Enable','off');
        end
    end

%% Run sound action
    function Runbutton(~, ~)
        
        % loop through each sound
        for y = 1:length(soundname)
            
            Data_clean = All_sound_data(y).Data_clean;
            
            % loop through selection tables in each sound
            for z = 1:length(Data_clean)
                
                if not(isempty(fields(Data_clean(z))))
                    % initialize struct fields for log
                    Ratings = [];Scores = []; Notes={}; Tags = {};
                    Raven_headers = All_sound_data(y).Raven_headers{z};
                    
                    
                    % extract columns from Raven selection table
                    status = 0;
                    curr_raven{z} = All_sound_data(y).Raven_tables{z};
                    [Selection, status] = extract_column(Data_clean(z).Data, Raven_headers, 'Selection', curr_raven{z}, status);
                    [Channel, status] = extract_column(Data_clean(z).Data, Raven_headers, 'Channel', curr_raven{z}, status);
                    [BeginTimes, status] = extract_column(Data_clean(z).Data, Raven_headers, 'BeginTimes', curr_raven{z}, status);
                    [EndTimes, status] = extract_column(Data_clean(z).Data, Raven_headers, 'EndTimes', curr_raven{z}, status);
                    [LowFreqHz, status] = extract_column(Data_clean(z).Data, Raven_headers, 'LowFreqHz', curr_raven{z}, status);
                    [HighFreqHz, status] = extract_column(Data_clean(z).Data, Raven_headers, 'HighFreqHz', curr_raven{z}, status);
                    
                    % Get any other user-selected event fields
                    if get(tags_handle,'value') ~= 1
                        
                        %%%FIX!
                        try
                            Tags = extract_column(Data_clean(z).Data, Raven_headers, all_tag_options{get(tags_handle,'value')}, curr_raven{z}, status);
                            % Go through and make sure no spaces in tags
                            for mm = 1:length(Tags)
                                blanks = strfind(Tags{mm},' ');
                                if not(isempty(blanks))
                                    orig = Tags{mm};
                                    orig(blanks) = '_';
                                    Tags{mm} = orig;
                                end
                            end
                        catch err
                            % for now do not tag events if the tags column is missing
                            
                            fprintf('Warning: column %s not present in selection table %s, entries in Tags section of XBAT log will remain blank\n', char(all_tag_options{get(tags_handle,'value')}),char(All_sound_data(y).Raven_tables{z}));
                            disp(' ')
                        end
                    end
                    if get(ratings_handle,'value') ~= 1
                        try
                            Ratings_init = extract_column(Data_clean(z).Data, Raven_headers, all_tag_options{get(ratings_handle,'value')}, curr_raven{z}, status);
                            % convert to 0-5 for star ratings
                            Ratings = zeros(1,length(Ratings_init));
                            for pp = 1:length(Ratings_init)
                                rate = str2num(Ratings_init{pp});
                                if not(isempty(rate))
                                    if not(isempty(str2double(get(r0_2_handle,'String')))) && rate < str2double(get(r0_2_handle,'String'))
                                        Ratings(pp) = 0;
                                    elseif not(isempty(str2double(get(r1_2_handle,'String')))) && rate < str2double(get(r1_2_handle,'String'))
                                        Ratings(pp) = 1;
                                    elseif not(isempty(str2double(get(r2_2_handle,'String')))) && rate < str2double(get(r2_2_handle,'String'))
                                        Ratings(pp) = 2;
                                    elseif not(isempty(str2double(get(r3_2_handle,'String')))) && rate < str2double(get(r3_2_handle,'String'))
                                        Ratings(pp) = 3;
                                    elseif not(isempty(str2double(get(r4_2_handle,'String')))) && rate < str2double(get(r4_2_handle,'String'))
                                        Ratings(pp) = 4;
                                    elseif not(isempty(str2double(get(r5_2_handle,'String'))))
                                        Ratings(pp) = 5;
                                    else
                                        Ratings(pp) = 0;
                                    end
                                end
                            end
                        catch err
                            % for now do not rate events if the ratings column is missing
                            fprintf('Warning: column %s not present in selection table %s, entries in Ratings section of XBAT log will remain \n', char(all_tag_options{get(ratings_handle,'value')}),char(All_sound_data(y).Raven_tables{z}));
                            disp(' ')
                        end
                    end
                    if get(scores_handle,'value') ~= 1
                        try
                            Scores = extract_column(Data_clean(z).Data, Raven_headers, all_tag_options{get(scores_handle,'value')}, curr_raven{z}, status);
                            Scores = str2num(char(Scores));
                        catch err
                            % for now do not score events if the scores column is missing
                            fprintf('Warning: column %s not present in selection table %s, entries in Scores section of XBAT log will remain blank\n', char(all_tag_options{get(scores_handle,'value')}),char(All_sound_data(y).Raven_tables{z}));
                            disp(' ')
                        end
                    end
                    
                    notes_cols_ix = get(notes_cols_handle,'Value');
                    notes_headers = all_tag_options(notes_cols_ix);
                    
                    if strcmp(notes_headers,'None')
                        % is user selected no coluumns to be added to notes
                        notes_headers = [];
                        notes_cols_ix = [];
                    else
                        % go through columns added to notes
                        [d_rows,d_cols] = size(Data_clean(z).Data);
                        
                        for nn = 1:length(notes_cols_ix)
                            
                            try
                                 Notes(:,nn) = extract_column(Data_clean(z).Data, Raven_headers, all_tag_options{notes_cols_ix(nn)}, curr_raven{z}, status);
%                                 Notes(:,end+1) = extract_column(Data_clean(z).Data, Raven_headers, notes_headers{nn}, curr_raven{z}, status);
                                % Notes(:,end+1) = extract_column(Data_clean(z).Data, Raven_headers, Raven_headers{7+notes_cols_ix(nn)}, curr_raven{z}, status);
                                % Notes(:,end+1) = extract_column(Data_clean(z).Data, Raven_headers, notes_tag_options{nn}, curr_raven{z}, status);
                            catch err
                                if strcmp(err.identifier,'MATLAB:subsassigndimmismatch')
                                    fprintf('Warning: column %s of selection table %s is empty, entries in Notes section of XBAT log will remain blank\n', char(all_tag_options{notes_cols_ix(nn)}),char(All_sound_data(y).Raven_tables{z}));
                                    
                                    %notes_cnt = notes_cnt+1;
                                    for nr = 1:d_rows
                                        Notes{nr,nn} = ' ';
                                    end
                                end
                                
                            end
                        end
                        
                        if status
                            return;
                        end
                    end
                    
                    %%% create XBAT events
                    log_length = size(Selection,1);
                    clear event
                    event(1:log_length) = event_template;
                    
                    for jj = 1:log_length
                        
                        event(jj).time = [str2double(BeginTimes(jj)), str2double(EndTimes(jj))];
                        event(jj).duration = diff(event(jj).time);
                        event(jj).freq = [str2double(LowFreqHz(jj)), str2double(HighFreqHz(jj))];
                        event(jj).bandwidth = diff(event(jj).freq);
                        event(jj).id =  str2double(Selection(jj));
                        event(jj).channel = str2double(Channel(jj));
                        
                        if not(isempty(Tags))
                            event(jj).tags = Tags(jj);
                        else
                            event(jj).tags = {};
                        end
                        if not(isempty(Scores))
                            event(jj).score = Scores(jj);
                        else
                            event(jj).score = [];
                        end
                        if not(isempty(Ratings))
                            event(jj).rating = Ratings(1,jj);
                        else
                            event(jj).rating = [];
                        end
                        if not(isempty(notes_headers))
                            temp_notes = {};
                            [notes_rows,notes_cols_final] = size(Notes);
                            for zz = 1:length(notes_headers)
                                try
                                    temp_notes{zz} = [notes_headers{zz} ': ' char(Notes(jj,zz))] ;
                                    %                                     temp_notes{zz} = [char(Raven_headers{7+ notes_cols_ix(zz)}) ': ' char(Notes(jj,zz))] ; %%% changed back 9/11/12
                                    %                                     temp_notes{zz} = [char(Raven_headers{zz+7}) ': ' char(Notes(jj,zz))] ;
                                catch err
                                    temp_notes{zz} = [notes_headers{zz} ':  ' ] ;
                                    
                                end
                            end
                            event(jj).notes = temp_notes;
                        else
                            event(jj).notes = {};
                        end
                    end
                    
                    
                    %%% create XBAT log
                    fn_raven = char(curr_raven{z});
                    fn_raven = fn_raven(1:end-4);
                    fn_xbat = fn_raven(isstrprop(fn_raven,'alphanum') | fn_raven=='_');
                    fn_xbat = [fn_xbat, '_', datestr(now, 'yyyymmdd_HHMMSSFFF')];
                    
                    NewLog = new_log(fn_xbat, context.user, context.library, context.target(y));
                    NewLog.event = event;
                    NewLog.length = log_length;
                    NewLog.curr_id = log_length + 1;
                    NewLog.userdata.notes_categories = notes_tag_options;
                    NewLog.userdata.tags = all_tag_options{get(tags_handle,'value')};
                    NewLog.userdata.scores = all_tag_options{get(scores_handle,'value')};
                    NewLog.userdata.ratings = all_tag_options{get(ratings_handle,'value')};
                    log_save(NewLog);
                    str1 = sprintf('New XBAT log saved: ''%s''\n',NewLog.file);
                    disp(str1);
                end
            end
        end
        % Change handle value so GUI can close
        set(run_handle,'FontAngle','Italic');
    end

%% Create Notes Section Data
    function NotesColsbutton(~, ~)
        cols_ix = get(notes_cols_handle,'Value');
        
        % Don't let user select none and other items
        if (cols_ix(1) ==1)  && (length(cols_ix) > 1)
            cols_ix = 1;
             set(notes_cols_handle, 'value', 1)
        end
    end

%% Give explanation for ratings if necessary
    function rating_q(~, ~)
        helpdlg('Rating bundaries are set at equal intervals between the min and max of the column used as Ratings.  Ratings boundaries will be blank if a non-numeric column selected.')
    end
%% Don't let use select Raven tables
    function Tablebutton(~, ~)
        set(raven_table_handle,'Value',[]);
    end


%% Get data from column of Raven selection table
    function [vec, status] = extract_column(mat, VarNames2, var_selection, ~, status)
        
        if status
            return;
        end
        % extract column in mat with VarName equal var_selection into vec
        ii = 1;
        
        while ii < length(VarNames2) && ~strcmp(VarNames2{ii}, var_selection)
            ii = ii + 1;
        end
        
        if strcmp(VarNames2{ii}, var_selection)
            if not(isempty(mat))
                vec = mat(:,ii);
            else
                vec={};
            end
        else
            status = 1;
            % omit error message because code can still run sucessfully and
            % corresponding log entries will be left blank
            % give warning later instead of error here
            %             txt = sprintf('Raven Selection Table does not have a column named %s', var_selection);
            %             txt2 = sprintf('\n%s\n%s\n', txt, curr_raven);
            %             fprintf(2, 'ERROR: %s', txt2);
            %  wh = warndlg(txt2, 'ERROR');
            % movegui(wh, 'center')
        end
        
    end

    function my_closefcn(src,event)
        % User-defined close request function
        % to display a question dialog box
        if not(strcmp(get(run_handle,'FontAngle'),'italic'))
            selection = questdlg('Close figure and quit Raven2XBAT?',...
                'Close Request Function',...
                'Yes','No','Yes');
            switch selection,
                case 'Yes',
                    % Change handle value so GUI can close
                    set(run_handle,'FontAngle','Italic');
                    %                 close(gcf)
                    %                 context.state.kill = 1;
                case 'No'
                    return
            end
        else
            delete(gcf)
        end
        
    end

    function [b,ndx,pos] = unique_no_sort(a)
        
        %UNIQUE_NO_SORT Set unique unsorted.
        %   B = UNIQUE_NO_SORT(A) for the array A returns a vector of the unique
        %   elements of A in the order that they appear in A, i.e. B is unsorted.  A can
        %   be a cell array of strings.  UNIQUE_NO_SORT does not have an option to
        %   operate on rows like the original UNIQUE function.
        %
        %   [B,I,J] = UNIQUE_NO_SORT(A) also returns index vectors I and J such
        %   that B = A(I) and A = B(J).
        %
        %   Caitlin Bever
        %   MIT: June 5, 2007
        
        
        if nargin < 1
            error('MATLAB:UNIQUE:NotEnoughInputs', 'Not enough input arguments.');
        elseif nargin > 1
            error('MATLAB:UNIQUE:TooManyInputs', 'Too many input arguments.');
        end
        
        % Convert A to a vector
        
        a = a(:)';
        
        % Use UNIQUE to find the forward and backward sorted unique sets and their
        % indices.
        
        [b_flip,ndx_flip,pos_flip] = unique(fliplr(a));
        
        % Create the new index by flipping around the backward index.  Use the new
        % index to create the unique unsorted set.
        
        ndx = sort(numel(a)-ndx_flip+1);
        b = a(ndx);
        
        % Initialize the new position vector with the sorted position vector then
        % exchange the elements that were sorted.
        
        if nargout>2
            
            [b_noflip,ndx_noflip,pos_noflip] = unique(a);
            pos = pos_noflip;
            
            [y,ind] = sort(b);
            
            switched_indeces = ind - [1:numel(b)];
            
            [b_pos,ndx_pos,pos_pos] = unique(pos);
            
            pos_tmp = b_pos + switched_indeces;
            pos = pos_tmp(pos_pos);
            
        end
    end
end