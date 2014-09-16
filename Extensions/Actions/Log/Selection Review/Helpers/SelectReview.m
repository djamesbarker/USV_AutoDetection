%% TO DO

%% BUGS

%%
function varargout = SelectReview(varargin)
% Initialization code...DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SelectReview_OpeningFcn, ...
    'gui_OutputFcn',  @SelectReview_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT (ABOVE);


% --- Executes just before SelectReview is made visible.
function SelectReview_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output=hObject;

% Code to input custom key bindings. Needs work.
handles.GetKeys=questdlg('Would you like to import key bindings?','Bindings','No');

log=varargin{1};

handles.log=log;
handles.clips=log.clips;
handles.index=1;
handles.min=1;
handles.max=length(handles.clips);
handles.logical=ones(handles.max,1);
handles.calltype=cell(handles.max,1);
set(handles.playbackRate,'String',log.playspeed);
set(handles.Playback_Slider,'Value',log.playspeed,'Max',1,'Min',0.01);
set(handles.Contrast_Slider,'Value',0.5,'Max',.98,'Min',0);
handles.log.colormap='Jet';
handles.beta=0;handles.lowAmpFil=0;
handles.area=cell(handles.max,1);

for i=1:length(handles.clips)
    tmp=handles.clips{i};
    peak=max(max(tmp));
    [peakRow,peakCol]=find(tmp==peak);
    peakHz=handles.log.freq{i}(peakRow);
    peakSec=handles.log.time{i}(peakCol);
    sessTime=peakSec+handles.log.event(i).time(1);
    
    handles.peakHz(i)=peakHz;
    handles.peakTime(i)=sessTime;
    
    if isfield(handles.log.event(i),'selection')
        handles.area{i}=handles.log.event(i).selection;
        handles.calltype{i}=handles.log.event(i).tags;
    end
end

Plot_Callback(hObject, eventdata, handles)
if strcmp(handles.GetKeys,'Yes')
    [file,path]=uigetfile('*.xls*');
    if file ~= 0
        [data,text]=xlsread(fullfile(path,file));
        handles.keybind=text;
    end
elseif strcmp(handles.GetKeys,'No')
    %disp('Good');
    %handles.MakeKeys=questdlg('Would you like to make key bindings?');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CallReview wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SelectReview_OutputFcn(hObject, eventdata, handles)
handles2=handles;
handles=handles2;

EmTCount=0;
for i=1:length(handles.calltype)
    if isempty(handles.calltype{i})
        EmTCount=EmTCount+1;
    end
end

if EmTCount>0
    f=warndlg(['Warning:' num2str(EmTCount)  '  Untagged (un-reviewed) events found! These will be preserved for future review']);
    waitfor(f);
end

logical=handles.logical==1;
for i=1:length(handles.log.event)
    if handles.logical(i)==1
        handles.log.event(i).tags=handles.calltype{i};
    else
    end
end

A=1:length(handles.logical);
A=A(logical);
if sum(logical)==0
else
    handles.log.event=handles.log.event(A);
    handles.log.clips=handles.log.clips(A);
    handles.log.time=handles.log.time(A);
    handles.log.freq=handles.log.freq(A);
    handles.log.length=length(handles.log.event);
    for i=1:length(A)
        handles.log.event(i).peakHz=handles.peakHz(i);
        handles.log.event(i).peakTime=handles.peakTime(i);
        handles.log.event(i).selection=handles.area{i};
    end
end

fields2rmv={'clips','playback','playspeed','contrast','brightness',...
    'playsample','colormap','noise'};
logOut=rmfield(handles.log,fields2rmv);
varargout{1}=logOut;
delete (hObject);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'n'
        Reject_Callback(hObject, eventdata, handles)
    case 'y'
        Accept_Callback(hObject, eventdata, handles)
    case 's'
        Make_Selection_Callback(hObject, eventdata, handles)
    case 'leftarrow'
        Back_Callback(hObject, eventdata, handles)
    case 'rightarrow'
        Forward_Callback(hObject, eventdata, handles)
    case 'escape'
       figure1_CloseRequestFcn(hObject, eventdata, handles)
    otherwise
        for j=1:size(handles.keybind,1)
            if strcmp(eventdata.Key,handles.keybind{j,2})
                handles.logical(handles.index)=1;
                handles.calltype{handles.index}=...
                    handles.keybind{j,1};
                Forward_Callback(hObject, eventdata, handles)
            else
            end
        end
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else    
    delete (hObject);
end


% --- Executes on button press in Forward.
function Forward_Callback(hObject, eventdata, handles)
% hObject    handle to Forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index>=handles.max
    Plot_Callback(hObject, eventdata, handles)
else
    handles.index=handles.index+1;
    Plot_Callback(hObject, eventdata, handles)
end
guidata(hObject, handles);

% --- Executes on button press in Back.
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index<=handles.min
    Plot_Callback(hObject, eventdata, handles)
else
    handles.index=handles.index-1;
    Plot_Callback(hObject, eventdata, handles)
end
guidata(hObject, handles);

% --- Executes on button press in Accept.
function Accept_Callback(hObject, eventdata, handles)
% hObject    handle to Accept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.logical(handles.index)=1;
handles.calltype{handles.index}='Accept';
if handles.index>=handles.max
    Plot_Callback(hObject, eventdata, handles)
else
    handles.index=handles.index+1;
    Plot_Callback(hObject, eventdata, handles)
end
guidata(hObject, handles);

% --- Executes on button press in Reject.
function Reject_Callback(hObject, eventdata, handles)
% hObject    handle to Reject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.logical(handles.index)=0;
handles.calltype{handles.index}='Reject';
if handles.index>=handles.max
    Plot_Callback(hObject, eventdata, handles)
else
    handles.index=handles.index+1;
    Plot_Callback(hObject, eventdata, handles)
end

guidata(hObject, handles);

function Plot_Callback(hObject, eventdata, handles)
% newImage = imadjust(handles.clips{handles.index}, [a b], [c d]);
% To decrease Contrast_Slider, increase a, to increase, decrease b
% to increase brightness, increase c, to decrease, lower d
if(get(handles.LowAmp_Slider,'Value') == get(handles.LowAmp_Slider,'Min'))
    Spect=imadjust(handles.clips{handles.index},...
        [handles.log.contrast(1) 1-handles.log.contrast(2)],[0 1]);
else
    tmpClip=handles.clips{handles.index}>=handles.lowAmpFil;
    highAmpIdx=find(tmpClip~=0);
    highAmpPoints=handles.clips{handles.index}(highAmpIdx);
    filteredClip=zeros(size(handles.clips{handles.index},1),size(handles.clips{handles.index},2));
    filteredClip(highAmpIdx)=highAmpPoints;
    
    Spect=imadjust(filteredClip,...
        [handles.log.contrast(1) 1-handles.log.contrast(2)],[0 1]);
end

handles.axes1=imagesc(handles.log.time{handles.index},...
    handles.log.freq{handles.index},...
    Spect);

colormap(handles.log.colormap)

if (get(handles.chkInvert,'Value') == get(handles.chkInvert,'Max'))
    colormap(flipud(colormap))
    color='b';
else
    color='r';
    % Checkbox is not checked-take appropriate action
end
set(gca,'Ydir','normal');shading flat;
brighten(handles.beta);

% Calculates the peak_plot_fcn frequency and time and plots them if users checks box
if isempty(handles.area{handles.index}) % Default
    tmp=handles.clips{handles.index};
else % If user plotted a specific selection using Button16
    tmp_area=handles.area{handles.index};
    hold on
    handles.axes1=plot([tmp_area(1) (tmp_area(3))],[tmp_area(2) tmp_area(2)],'r');
    handles.axes1=plot([tmp_area(1) (tmp_area(3))],[tmp_area(4) tmp_area(4)],'r');
    handles.axes1=plot([tmp_area(1) (tmp_area(1))],[tmp_area(2) tmp_area(4)],'r');
    handles.axes1=plot([tmp_area(3) (tmp_area(3))],[tmp_area(2) tmp_area(4)],'r');
    hold off
    
    tmp=handles.clips{handles.index}(...
        find(handles.log.freq{handles.index} < tmp_area(2),1,'last'):...
        find(handles.log.freq{handles.index} > tmp_area(4),1,'first'),...
        find(handles.log.time{handles.index} < tmp_area(1),1,'last'):...
        find(handles.log.time{handles.index} > tmp_area(3),1,'first'));
end

[handles.plotfreq handles.plottime]=Plot_Fcn(handles,tmp);
sessTime=handles.plottime+handles.log.event(handles.index).time(1);

if (get(handles.chkPlot,'Value') == get(handles.chkPlot,'Max'))
    hold on
    handles.axes1=plot([0 max(handles.log.time{handles.index})],[handles.plotfreq handles.plotfreq],[color ':']);
    handles.axes1=plot([handles.plottime handles.plottime],[0 max(handles.log.freq{handles.index})],[color ':']);
    hold off
else
    % Checkbox is not checked-take appropriate action
end
set(handles.Hz,'String',handles.plotfreq);
set(handles.Sec,'String',handles.plottime);
set(handles.sessTime,'String',sessTime);
set(handles.Count,'String',[num2str(handles.index) ' / ' num2str(handles.max)]);
set(handles.CurrType,'String',handles.calltype(handles.index));

if ~isempty(handles.area{handles.index})
    set(handles.Clear_Selection,'Enable','on');
else
    set(handles.Clear_Selection,'Enable','off');
end

guidata(hObject, handles);


% --- Executes on button press in chkPlot.
function chkPlot_Callback(hObject, eventdata, handles)
% hObject    handle to chkPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkPlot
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in chkInvert.
function chkInvert_Callback(hObject, eventdata, handles)
% hObject    handle to chkInvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkInvert
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.audio=audioplayer(handles.log.playback{handles.index},handles.log.playsample(2)*handles.log.playspeed);
play(handles.audio)
guidata(hObject, handles);


% --- Executes on slider movement.
function Playback_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Playback_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.log.playspeed=get(hObject, 'Value');
set(handles.playbackRate,'String',num2str(handles.log.playspeed));

% get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Playback_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Playback_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Contrast_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Contrast_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.log.contrast(2)=get(hObject,'Value');
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Contrast_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Contrast_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in incBright.
function incBright_Callback(hObject, eventdata, handles)
% hObject    handle to incBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.beta <.9
    handles.beta=handles.beta+0.1;
end
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in decBright.
function decBright_Callback(hObject, eventdata, handles)
% hObject    handle to decBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.beta > -.9
    handles.beta=handles.beta-0.1;
end
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on selection change in Colormap.
function Colormap_Callback(hObject, eventdata, handles)
% hObject    handle to Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Colormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Colormap
list=get(handles.Colormap,'String');
val=get(handles.Colormap,'Value');
handles.log.colormap=list{val};
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% LOW AMPLTIUDE FILTER SLIDER
% Purpose is to remove all noise below certain amplitude factor (lowAmpThresh)
% of noise determined by B in compute.m which is equal to
% mean(mean(handles.clips{handles.index}(200:257,:)))

% --- Executes on slider movement.
function LowAmp_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to LowAmp_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.lowAmpFil=(get(handles.LowAmp_Slider,'Value'))*150*handles.log.noise{handles.index}; % All points less than lowAmpFil will be removed when slider ~= Min
set(handles.lowAmpThresh,'String',num2str(handles.lowAmpFil));

Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LowAmp_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowAmp_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on Plot option press in Plot Tools Menu
function Plot_On_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_On (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chkPlot,'Value',get(handles.chkPlot,'Max'));

Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --------------------------------------------------------------------
function Plot_Peak_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Plot_Peak,'Checked','on');
set(handles.Plot_Center,'Checked','off');

Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --------------------------------------------------------------------
function Plot_Center_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Plot_Peak,'Checked','off');
set(handles.Plot_Center,'Checked','on');

Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in Make_Selection.
function Make_Selection_Callback(hObject, eventdata, handles)
% hObject    handle to Make_Selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.area{handles.index}=getrect;
handles.area{handles.index}(3)=handles.area{handles.index}(1)+handles.area{handles.index}(3);
handles.area{handles.index}(4)=handles.area{handles.index}(2)+handles.area{handles.index}(4);

if (handles.area{handles.index}(1) > handles.log.time{handles.index}(end)) || (handles.area{handles.index}(2) > handles.log.freq{handles.index}(end))
    Make_Selection_Callback(hObject, eventdata, handles);
elseif handles.area{handles.index}(1) < handles.log.time{handles.index}(1)
    handles.area{handles.index}(1) = handles.log.time{handles.index}(1);
elseif handles.area{handles.index}(2) < handles.log.freq{handles.index}(1)
    handles.area{handles.index}(2) = handles.log.freq{handles.index}(1);
elseif handles.area{handles.index}(3) > handles.log.time{handles.index}(end)
    handles.area{handles.index}(3) = handles.log.time{handles.index}(end);
elseif handles.area{handles.index}(4) > handles.log.freq{handles.index}(end)
    handles.area{handles.index}(4) = handles.log.freq{handles.index}(end);
end

Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --------------------------------------------------------------------
function NextUntagged_Callback(hObject, eventdata, handles)
% hObject    handle to NextUntagged (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index<handles.max
handles.index=handles.index+1;
while ~isempty(handles.calltype{handles.index}) && handles.index<handles.max
    handles.index=handles.index+1;
end
end
Plot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function PrevUntagged_Callback(hObject, eventdata, handles)
% hObject    handle to PrevUntagged (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index>1
handles.index=handles.index-1;
while ~isempty(handles.calltype{handles.index}) && handles.index>1
    handles.index=handles.index-1;
end
end
Plot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function NextAccept_Callback(hObject, eventdata, handles)
% hObject    handle to NextAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index<handles.max
handles.index=handles.index+1;
while handles.calltype{handles.index}~='Accept' && handles.index<handles.max
    handles.index=handles.index-1;
end
end
Plot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function FirstAccept_Callback(hObject, eventdata, handles)
% hObject    handle to FirstAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.index=1;
while handles.calltype{handles.index}~='Accept' && handles.index<handles.max
    handles.index=handles.index+1;
end
Plot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function LastAccept_Callback(hObject, eventdata, handles)
% hObject    handle to LastAccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.index=handles.max;
while handles.calltype{handles.index}~='Accept' && handles.index>1
handles.index=handles.index-1;
end
Plot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function NextReject_Callback(hObject, eventdata, handles)
% hObject    handle to NextReject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index<handles.max
handles.index=handles.index+1;
while handles.calltype{handles.index}~='Reject' && handles.index<handles.max
    handles.index=handles.index-1;
end
end
Plot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function FirstReject_Callback(hObject, eventdata, handles)
% hObject    handle to FirstReject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.index=1;
while handles.calltype{handles.index}~='Reject' && handles.index<handles.max
    handles.index=handles.index+1;
end
Plot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function LastReject_Callback(hObject, eventdata, handles)
% hObject    handle to LastReject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.index=handles.max;
while handles.calltype{handles.index}~='Reject' && handles.index>1
handles.index=handles.index-1;
end
Plot_Callback(hObject, eventdata, handles)


% %----------------------------------------------------------------% %
% %                 NON-CALLBACK FUNCTIONS:                        % %
% %----------------------------------------------------------------% %
function [plotfreq plottime] = Plot_Fcn(handles,clip)
if isequal(get(handles.Plot_Peak,'Checked'),'on')
    peak=max(max(clip));
    [peakRow,peakCol]=find(handles.clips{handles.index}==peak);
    plotfreq=handles.log.freq{handles.index}(peakRow);
    plottime=handles.log.time{handles.index}(peakCol);
elseif isequal(get(handles.Plot_Center,'Checked'),'on')
    half_power=(sum(sum(clip)))/2;
    time_bands=sum(clip); freq_bands=sum(clip');
    count=1;
    while(low_band > high_band)
        low_band=sum(freq_bands(1:end-count));
        high_band=sum(freq_bands(end+1-count:end));
        count=count+1;
    end
    count=1;
    while(left_band > right_band)
        left_band=sum(time_bands(1:end-count));
        high_band=sum(time_bands(end+1-count:end));
        count=count+1;
    end
    plotfreq=handles.log.freq{handles.index}(length(low_band));
    plottime=handles.log.time{handles.index}(length(left_band));
else
    ...    % Future Plot Functions Here
end
