function varargout = SelectReview(varargin)
%Initialization code...DO NOT EDIT
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

handles.output = hObject;

%Code to input custom key bindings. Needs work.
handles.GetKeys=questdlg('Would you like to import key bindings?','Bindings','Yes');

log=varargin{1,1};
handles.log=log;
handles.clips=log.clips;
handles.index=1;
handles.min=1;
handles.max=length(handles.clips);
handles.logical=ones(handles.max,1);
handles.calltype=cell(handles.max,1);
set(handles.text15,'String',log.playspeed);
set(handles.slider1,'Value',log.playspeed,'Max',1,'Min',0.01);
set(handles.slider4,'Value',0.5,'Max',.98,'Min',0);
handles.beta=0;
handles.log.colormap='Jet';

for i=1:length(handles.clips)
    tmp=handles.clips{i};
    peak=max(max(tmp));
    [peakRow,peakCol]=find(tmp==peak);
    peakHz=handles.log.freq{i}(peakRow);
    peakSec=handles.log.time{i}(peakCol);
    sessTime=peakSec+handles.log.event(i).time(1);
    
    handles.peakHz(i)=peakHz;
    handles.peakTime(i)=sessTime;
end

Plot_Callback(hObject, eventdata, handles)
if strcmp(handles.GetKeys,'Yes')
    [file path]=uigetfile('*.xls*');
    [data text]=xlsread(fullfile(path,file));
    handles.keybind=text;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CallReview wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SelectReview_OutputFcn(hObject, eventdata, handles)

handles2=handles;
handles=handles2;

handles.log.clips=handles.clips;
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
    handles.log.length=length(handles.log.event);
    handles.log.peakHz=handles.peakHz(A);
    handles.log.peakTime=handles.peakTime(A);
end
varargout{1} = handles.log;
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
    delete(hObject);
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
%newImage = imadjust(handles.clips{handles.index}, [a b], [c d]);
% To decrease contrast, increase a, to increase, decrease b
%to increase brightness, increase c, to decrease, lower d
Spect = imadjust(handles.clips{handles.index},...
    [handles.log.contrast(1) 1-handles.log.contrast(2)], [0 1]);

handles.axes1=imagesc(handles.log.time{handles.index},...
    handles.log.freq{handles.index},...
    Spect);

colormap(handles.log.colormap)

if (get(handles.checkbox2,'Value') == get(handles.checkbox2,'Max'))
    colormap(flipud(colormap))
    color='b';
else
    color='r';
    % Checkbox is not checked-take appropriate action
end
set(gca,'Ydir','normal');shading flat;
brighten(handles.beta);

% Calculates the peak frequency and time and plots them if users checks box
tmp=handles.clips{handles.index};
peak=max(max(tmp));
[peakRow,peakCol]=find(tmp==peak);
peakHz=handles.log.freq{handles.index}(peakRow);
peakSec=handles.log.time{handles.index}(peakCol);
sessTime=peakSec+handles.log.event(handles.index).time(1);

if (get(handles.checkbox1,'Value') == get(handles.checkbox1,'Max'))
    hold on
    handles.axes1=plot([0 max(handles.log.time{handles.index})],[peakHz peakHz],[color ':']);
    handles.axes1=plot([peakSec peakSec],[0 max(handles.log.freq{handles.index})],[color ':']);
    hold off
else
    % Checkbox is not checked-take appropriate action
end
set(handles.Hz,'String',peakHz);
set(handles.Sec,'String',peakSec);
set(handles.sessTime,'String',sessTime);
set(handles.Count,'String',[num2str(handles.index) ' / ' num2str(handles.max)]);
set(handles.CurrType,'String',handles.calltype(handles.index));
guidata(hObject, handles);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavplay(handles.log.playback{handles.index},handles.log.playsample(2)*handles.log.playspeed);
guidata(hObject, handles);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.log.playspeed = get(hObject,'Value');
set(handles.text15,'String',num2str(handles.log.playspeed));

%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.log.contrast(2) = get(hObject,'Value');
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.beta <.9
handles.beta=handles.beta+0.1;
end
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.beta > -.9
handles.beta=handles.beta-0.1;
end
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
list=get(handles.popupmenu2,'String');
val=get(handles.popupmenu2,'Value');
handles.log.colormap=list{val};
Plot_Callback(hObject, eventdata, handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
