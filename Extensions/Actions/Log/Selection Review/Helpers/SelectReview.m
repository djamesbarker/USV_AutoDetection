%% TO DO:
% SET UP NEURAL NETWORKS FOR TYPE DETECTION; FIND ARTIFACT/CALL TYPE DETECTION
% ALGORITHM...
%Playback for only duration enclosed in box (frequency too?)
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

log=varargin{1};

%Initialize Variables
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
set(handles.ContourThresh,'Value',8,'Min',0,'Max',40,'SliderStep',[1/40 1/40]);
set(handles.ContourPoints,'Value',20,'Min',10,'Max',50,'SliderStep',[5/40 5/40]);
set(handles.ThresText,'String',8);
set(handles.PointsText,'String',20);


handles.log.colormap='Jet';
handles.beta=0;handles.lowAmpFil=0;
handles.area=cell(handles.max,1);

%Detect Contours
for i=1:length(handles.clips)
    handles.CallPoints=[];
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
    
    Noise=mean(mean(handles.clips{i}(150:end,:))); 
    
    MaxPoint=[];Xloc=[];Max=[];Loc=[];
        for j=1:length(handles.clips{i}(1,:))
            [MaxPoint, Xloc]=max(handles.clips{i}(70:end,j));
            Max(1,j)=MaxPoint; %Max Value
            Loc(1,j)=Xloc+70; %Xloc is actuall Y Location
        end 
     Max_idx=Max(1,:)>=Noise; %1X Noiseband is arbitrary, Slider takes increased value later.
         
        for j=1:length(handles.clips{i}(1,:))
            if Max_idx(j)==1
                handles.CallPoints(end+1,1)=j;
                handles.CallPoints(end,2)=Loc(j);
            end
        end
        
    %Contour Measurements for output
    handles.Contour.Plot{i,1}(:,1)=handles.log.time{i}(handles.CallPoints(:,1));
    handles.Contour.Plot{i,1}(:,2)=smooth( handles.log.freq{i}(handles.CallPoints(:,2)));
    handles.Contour.noise{i,1}=Noise;
    tmp=[];
    for k=1:length(handles.CallPoints(:,1))
        tmp(k,1)=handles.clips{i}(handles.CallPoints(k,2),handles.CallPoints(k,1));
    end
    handles.Contour.signal{i,1}=mean(tmp);
    handles.Contour.Plot{i,1}(:,3)=tmp./handles.Contour.noise{i,1};
    handles.Contour.SignaltoNoise{i,1}=handles.Contour.signal{i,1}/handles.Contour.noise{i,1};
    handles.Contour.Raw{i,:}=handles.Contour.Plot{i,:};
    handles.Contour.SN{i,1}=mean(handles.Contour.Plot{i,1}(:,3));% NEW
    if isfield(handles.log.event(i),'threshold')
        handles.Contour.Threshold{i,1}=handles.log.event(i).threshold;
    else
    handles.Contour.Threshold{i,1}=8;
    end
    
    %CONTOUR DETECTION SETUP END
    
    % Set default selection window to detected window.
    if isfield(handles.log.event(i),'area')
        handles.area{i}=handles.log.event(i).area;
    else
     handles.area{i}(1)=handles.log.pad;
     handles.area{i}(3)=...
        (handles.log.event(i).time(2)-handles.log.event(i).time(1))+handles.log.pad;
     handles.area{i}(2)=handles.log.event(i).freq(1);
     handles.area{i}(4)=handles.log.event(i).freq(2);
    end
end

Plot_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes CallReview wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SelectReview_OutputFcn(hObject, eventdata, handles)
handles2=handles;
handles=handles2;

for i=1:length(handles.area)
handles.log.event(i).area=handles.area{i};
handles.log.event(i).threshold=handles.Contour.Threshold{i};
end

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
        handles.log.event(i).peakHz=handles.peakHz(A(i));
        handles.log.event(i).peakTime=handles.peakTime(A(i));
        handles.log.event(i).selection=handles.area{A(i)};
    end
end

fields2rmv={'clips','playback','playspeed','contrast','brightness',...
    'playsample','colormap','noise'};
logOut=rmfield(handles.log,fields2rmv);
varargout{1}=logOut;

i=1;
if get(handles.ChkContour,'Value')==get(handles.ChkContour,'Max')
    
    for l=1:length(handles.Contour.Plot)
        if isempty(handles.Contour.Plot{l})
            logical(l)=0;
        end
        disp(l)
        Signal= handles.Contour.Threshold{handles.index};
        handles.Contour.Plot{l}=...
            handles.Contour.Raw{l}(handles.Contour.Raw{l}(:,3)>Signal,:);

        % FINAL RUN FOR OUTPUT MODELS
        handles.Contour.Plot{l}=...
            handles.Contour.Plot{l}(handles.Contour.Plot{l}(:,1)>handles.area{l}(1)&...
            handles.Contour.Plot{l}(:,1)<handles.area{l}(3),:);

        handles.Contour.Plot{l}=...
            handles.Contour.Plot{l}(handles.Contour.Plot{l}(:,2)>handles.area{l}(2)&...
            handles.Contour.Plot{l}(:,2)<handles.area{l}(4),:);


        handles.Contour.Dur{l,1}=max(handles.Contour.Plot{l}(:,1))-...
            min(handles.Contour.Plot{l}(:,1));
        handles.Contour.MaxHz{l,1}=max(handles.Contour.Plot{l}(:,2));
        handles.Contour.MinHz{l,1}=min(handles.Contour.Plot{l}(:,2));
        handles.Contour.Bandwidth{l,1}=handles.Contour.MaxHz{l}-handles.Contour.MinHz{l};
        handles.Contour.MeanHz{l,1}=mean(handles.Contour.Plot{l}(:,2));
        if length(handles.Contour.Plot{l,1})>1
            fitvars = polyfit(handles.Contour.Plot{l}(:,1),...
                handles.Contour.Plot{l}(:,2), 1);
            handles.Contour.Slope{l,1}=fitvars(1);
        else
            handles.Contour.Slope{l,1}=nan;
        end
        handles.Contour.Deriv{l,1}=diff(handles.Contour.Plot{l}(:,2),1);
        handles.Contour.Integral{l,1}=sum(abs(handles.Contour.Deriv{l,1})); %NEW
        if length(handles.Contour.Plot{l,1})>3 %NEW LOOP
        [peaks locs]=findpeaks(abs(smooth(handles.Contour.Deriv{l,1},10,'rloess'))); % Find Call minima and maxima and location
        handles.Contour.Peaks{l,1}=length(peaks); %Find number of peaks 
        else
            handles.Contour.Peaks{l,1}=1;
        end
        if handles.Contour.Peaks{l,1}==0
            handles.Contour.Peaks{l,1}=1;
        end
        handles.Contour.SN{handles.index,1}=mean(handles.Contour.Plot{handles.index}(:,3));
        handles.Contour.PeakRate{l,1}=...
           (handles.Contour.Peaks{l,1}/handles.Contour.Dur{l,1}); %Peaks/Sec
        handles.Contour.ModRate{l,1}=...
           (handles.Contour.Integral{l,1}/handles.Contour.Dur{l,1});%Modulations/Sec
       
       if isempty(handles.Contour.Deriv{l})
           handles.Contour.Deriv{l,1}=NaN; handles.Contour.DerivMin{l,1}=NaN;
            handles.Contour.DerivMax{l,1}=NaN; handles.Contour.DerivMean{l,1}=NaN;
       else
        handles.Contour.DerivMin{l,1}=min(abs(handles.Contour.Deriv{l,1}));
        handles.Contour.DerivMax{l,1}=max(abs(handles.Contour.Deriv{l,1}));
        handles.Contour.DerivMean{l,1}=mean(abs(handles.Contour.Deriv{l,1}));    
       end
       
        numPoints=get(handles.ContourPoints,'Value');
        A=handles.Contour.Plot{l,1};
        if length(A)>3
        xx=min(A(:,1)):(max(A(:,1))-min(A(:,1)))/(numPoints-1):max(A(:,1));
        yy = spline(A(:,1),A(:,2),xx);
        plot(A(:,1),A(:,2))
        Spline(:,l)=yy;
        else
        Spline(1:numPoints,l)=nan;
        end
        
    end  
    Master=[];
Master=[handles.Contour.MinHz{logical}; handles.Contour.MaxHz{logical};handles.Contour.MeanHz{logical};...
    handles.Contour.Bandwidth{logical}; handles.Contour.Dur{logical}; handles.Contour.SN{logical};...
    handles.Contour.Slope{logical};handles.Contour.DerivMin{logical};handles.Contour.DerivMax{logical};...
    handles.Contour.DerivMean{logical}; handles.Contour.Integral{logical};handles.Contour.ModRate{logical};...
    handles.Contour.Peaks{logical};handles.Contour.PeakRate{logical}]';

Header={'MinHz';'MaxHz';'MeanHz';'Bandwidth';'Duration';'Signal:Noise';'Slope';'DerivativeMin';'DerivativeMax';...
    'DerivativeMean';'Integral';'Modulations/Second(Integral)';'NumOfPeaks';'Peaks/Second'}';

[filename, path]=uiputfile('*.xlsx');
output=fullfile(path,filename);
xlswrite(output,Master,'Parameters','A2');     %Write data
xlswrite(output,Header,'Parameters','A1');     %Write Header (titles)
xlswrite(output,Spline,'Splines');
end

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
        if isfield(handles,'keybind')
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
set(handles.Make_Selection,'Enable','on');
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
    ChkContour_Callback(hObject, eventdata, handles)
else
    handles.index=handles.index+1;
    Plot_Callback(hObject, eventdata, handles)
    ChkContour_Callback(hObject, eventdata, handles)
end
guidata(hObject, handles);

% --- Executes on button press in Back.
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index<=handles.min
    Plot_Callback(hObject, eventdata, handles)
    ChkContour_Callback(hObject, eventdata, handles)
else
    handles.index=handles.index-1;
    Plot_Callback(hObject, eventdata, handles)
    ChkContour_Callback(hObject, eventdata, handles)
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


%% !!!!!!!!!!!!!!!!!!!!!!PLOT CALLBACK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function Plot_Callback(hObject, eventdata, handles)
%Set brightness and Contrast:
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

%Set Axis 1 to Spectrogram
handles.axes1=imagesc(handles.log.time{handles.index},...
    handles.log.freq{handles.index},...
    Spect);
% SET COLORMAP
colormap(handles.log.colormap)
% INVERT COLORMAP
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
    
    %ALL CALLS GIVEN SAME THRESHOLD (SIGNAL:NOISE)
        for l=1:length(handles.Contour.Plot)
        Signal= handles.Contour.Threshold{handles.index};
        handles.Contour.Plot{l}=...
            handles.Contour.Raw{l}(handles.Contour.Raw{l}(:,3)>Signal,:);
        end
        
     set(handles.ThresText,'String',handles.Contour.Threshold{handles.index});
     set(handles.ContourThresh,'Value',handles.Contour.Threshold{handles.index})
        
    
    %TAKE ONLY CONTOUR POINTS WITHIN THE USER-DEFINED BOX
    if get(handles.ChkContour,'Value')==get(handles.ChkContour,'Max')
        handles.Contour.Plot{handles.index}=...
            handles.Contour.Plot{handles.index}(handles.Contour.Plot{handles.index}(:,1)>handles.area{handles.index}(1)&...
            handles.Contour.Plot{handles.index}(:,1)<handles.area{handles.index}(3),:);

        handles.Contour.Plot{handles.index}=...
            handles.Contour.Plot{handles.index}(handles.Contour.Plot{handles.index}(:,2)>handles.area{handles.index}(2)&...
            handles.Contour.Plot{handles.index}(:,2)<handles.area{handles.index}(4),:);

         handles.Contour.Deriv{handles.index,1}=diff(handles.Contour.Plot{handles.index}(:,2),1);
    end
  
    %PLOT USER-DEFINED BOX
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
    hold off
end

 if get(handles.ChkContour,'Value')==get(handles.ChkContour,'Max')
     hold on
    %PLOT CONTOUR POINTS
    handles.axes1=scatter(handles.Contour.Plot{handles.index}(:,1),...
        handles.Contour.Plot{handles.index}(:,2),'yo');
    handles.axes1=gca;
     %PLOT SECOND DERIVATIVE OF CONTOUR IN WINDOW
    %plot(handles.axes2,abs(smooth(handles.Contour.Deriv{handles.index},10,'rloess')),'r');
    plot(handles.axes2,smooth(handles.Contour.Deriv{handles.index},10,'rloess'));
    axes(handles.axes1);
    hold off
 end

% GETS AND PLOTS PEAK TIME (SEE FUNCTION BELOW)
[handles.plotfreq handles.plottime]=Plot_Fcn(handles,handles.clips{handles.index});
sessTime=handles.plottime+handles.log.event(handles.index).time(1);%-handles.log.pad;

% PLOT THE PEAK FREQUENCY AND TIME
if (get(handles.chkPlot,'Value') == get(handles.chkPlot,'Max'))
    hold on
    handles.axes1=plot([0 max(handles.log.time{handles.index})],[handles.plotfreq handles.plotfreq],[color ':']);
    handles.axes1=plot([handles.plottime handles.plottime],[0 max(handles.log.freq{handles.index})],[color ':']);
    hold off
else
    % Checkbox is not checked-take appropriate action
end

% Set strings in main window.
set(handles.Hz,'String',handles.plotfreq);
set(handles.Sec,'String',handles.plottime);
set(handles.sessTime,'String',sessTime);
set(handles.Count,'String',[num2str(handles.index) ' / ' num2str(handles.max)]);
set(handles.CurrType,'String',handles.calltype(handles.index));

% Enable Button to Remove Selection
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
set(handles.Make_Selection,'Enable','off'); set(handles.Forward,'Enable','off');
set(handles.Back,'Enable','off');set(handles.Accept,'Enable','off');
set(handles.Reject,'Enable','off');set(handles.Clear_Selection,'Enable','off');
set(handles.decBright,'Enable','off');set(handles.incBright,'Enable','off');
set(handles.Contrast_Slider,'Enable','off');set(handles.decBright,'Enable','off');
set(handles.Playback_Slider,'Enable','off');set(handles.LowAmp_Slider,'Enable','off');
set(handles.Contrast_Slider,'Enable','off');set(handles.ContourThresh,'Enable','off');
set(handles.ContourPoints,'Enable','off');set(handles.Colormap,'Enable','off');
set(handles.chkPlot,'Enable','off');set(handles.chkInvert,'Enable','off');
set(handles.ChkContour,'Enable','off');

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

set(handles.Make_Selection,'Enable','on'); set(handles.Forward,'Enable','on');
set(handles.Back,'Enable','on');set(handles.Accept,'Enable','on');
set(handles.Reject,'Enable','on');set(handles.Clear_Selection,'Enable','on');
set(handles.decBright,'Enable','on');set(handles.incBright,'Enable','on');
set(handles.Contrast_Slider,'Enable','on');set(handles.decBright,'Enable','on');
set(handles.Playback_Slider,'Enable','on');set(handles.LowAmp_Slider,'Enable','on');
set(handles.Contrast_Slider,'Enable','on');set(handles.ContourThresh,'Enable','on');
set(handles.ContourPoints,'Enable','on');set(handles.Colormap,'Enable','on');
set(handles.chkPlot,'Enable','on');set(handles.chkInvert,'Enable','on');
set(handles.ChkContour,'Enable','on');


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


% --- Executes on button press in ChkContour.
function ChkContour_Callback(hObject, eventdata, handles)
% hObject    handle to ChkContour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Plot_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of ChkContour


% --- Executes on button press in Clear_Selection.
function Clear_Selection_Callback(hObject, eventdata, handles)
handles.area{handles.index}=[];
% hObject    handle to Clear_Selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plot_Callback(hObject, eventdata, handles)


%% RECENTLY ADDED TOOLS BELOW

% --- Executes on slider movement.
function ContourThresh_Callback(hObject, eventdata, handles)
% hObject    handle to ContourThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Threshold=get(handles.ContourThresh,'Value');
handles.Contour.Threshold{handles.index}=Threshold;
set(handles.ThresText,'String',Threshold);
Plot_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ContourThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ContourThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function ContourPoints_Callback(hObject, eventdata, handles)
% hObject    handle to ContourPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Points=get(handles.ContourPoints,'Value');
if Points==50
    set(handles.PointsText,'String','Max');
else
    set(handles.PointsText,'String',Points);
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ContourPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ContourPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function KeyBind_Callback(hObject, eventdata, handles)
% hObject    handle to KeyBind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Ask to import custom key bindings
handles.GetKeys=questdlg('Would you like to import key bindings?','Bindings','No');
% Import custom Key Bindings
if strcmp(handles.GetKeys,'Yes')
    [file,path]=uigetfile('*.xls*');
    if file ~= 0
        [data,text,raw]=xlsread(fullfile(path,file));
        for k=1:length(raw(:,2))
            if isnumeric(raw{k,2})
                raw{k,2}=num2str(raw{k,2});
            end
        end
            handles.keybind=raw;
    end
elseif strcmp(handles.GetKeys,'No')
end
guidata(hObject, handles);
