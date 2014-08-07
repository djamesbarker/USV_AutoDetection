function Answer = input_dialog(Prompt, Title, NumLines, DefAns, tip)

% input_dialog - create input dialog figure
% -----------------------------------------
%
% an = input_dialog(prompt,name,line,def,tip)
%
% Input:
% ------
%  prompt - prompt strings
%  name - dialog name
%  line - number of lines for text boxes and popup menus
%  def - default answers, determine type of input control
%
%    string - edit box input
%    cell array of strings - popup menu or listbox input depending on line
%    slider descriptor array - slider input with edit box
%
%      [value,min,max,clock]
%      [value,min,max,sliderstep(1),sliderstep(2),clock]
%
%  tip - tooltip strings, displayed on hovering main input control
%
% Output:
% -------
%  an - answers as strings

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1.0 $
% $Date: 2003-07-06 13:36:05-04 $
%--------------------------------

%--
% color information
%--

Black = [0, 0, 0];

LightGray  = [192, 192, 192] / 255;
LightGray2 = [160, 160, 164] / 255;
MediumGray = [128, 128, 128] / 255;

White = [255, 255, 255] / 255;

%--
% check input parameters
%--

if ((nargin == 1) & (nargout == 0))
	
	if strcmp(Prompt,'InputDlgResizeCB')
		LocalResizeFcn(gcbf);
		return;
	end
	
end

error(nargchk(1,5,nargin));
error(nargoutchk(1,1,nargout));

%--
% set title
%--

if (nargin == 1)
	Title = ' ';
end

%--
% set number of lines
%--

if (nargin <= 2)
	NumLines = 1;
end

%--
% put single prompt in cell
%--

if ~iscell(Prompt)
	Prompt = {Prompt};
end

%--
% set default answers
%--

NumQuest = prod(size(Prompt));    

if (nargin <= 3) 	
	DefAns = cell(NumQuest,1);
	for lp = 1:NumQuest
		DefAns{lp} = '';
	end  
end

%--
% set tooltip strings
%--

if (nargin < 5) 	
	tip = cell(NumQuest,1);
	for lp = 1:NumQuest
		tip{lp} = '';
	end  
end

%--
% changes to figure type and interpreter
%--

Interpreter = 'none';

Resize = 'off';

WindowStyle = 'normal';

[rw,cl] = size(NumLines);
OneVect = ones(NumQuest,1);

if (rw == 1 & cl == 2)
	NumLines = NumLines(OneVect,:);
elseif (rw == 1 & cl == 1)
	NumLines = NumLines(OneVect);
elseif (rw == 1 & cl == NumQuest)
	NumLines = NumLines';
elseif ((rw ~= NumQuest) | (cl > 2))
	error('NumLines size is incorrect.');
end

if ~iscell(DefAns)
	error('Default Answer must be a cell array in INPUTDLG.');  
end

%%%%%%%%%%%%%%%%%%%%%%%
%%% Create InputFig %%%
%%%%%%%%%%%%%%%%%%%%%%%

FigWidth = 300;
FigHeight = 100;
FigPos(3:4) = [FigWidth, FigHeight];

% if (~isempty(gcf))
% 	
% 	FigColor = get(gcf,'color');
% 	
% 	Black = [0, 0, 0];
% 
% 	LightGray  = 0.15 * ones(1,3) + 0.1;
% 	LightGray2 = LightGray + 0.1;
% 	MediumGray = [0, 0, 128] / 255;
% 	
% 	White = Black;
% 	Text_White = color_to_rgb('Light Gray');
% 	
% else
% 	
	FigColor = get(0,'Defaultuicontrolbackgroundcolor');
% 	
% end

TextForeground = Black;
if sum(abs(TextForeground - FigColor)) < 1
	TextForeground = Text_White;
end

InputFig = dialog( ...
	'Visible'         ,'off'      , ...
	'Name'            ,Title      , ...
	'Pointer'         ,'arrow'    , ...
	'Units'           ,'points'   , ...
	'UserData'        ,''         , ...
	'Tag'             ,Title      , ...
	'HandleVisibility','on'       , ...
	'Color'           ,FigColor   , ...
	'NextPlot'        ,'add'      , ...
	'WindowStyle'     ,WindowStyle, ...
	'Resize'          ,Resize     , ...
	'BackingStore'    ,'on'       , ...
	'DoubleBuffer'    ,'on'         ...
);


%%%%%%%%%%%%%%%%%%%%%
%%% Set Positions %%%
%%%%%%%%%%%%%%%%%%%%%

DefOffset = 12;
SmallOffset = 6;

%--
% make larger buttons that use users fonts
%--

DefBtnWidth = 60;
BtnHeight = 24;

BtnYOffset = DefOffset;

BtnFontSize = get(0,'FactoryUIControlFontSize');

BtnWidth = DefBtnWidth;

TextInfo.Units = 'points';   
TextInfo.FontSize = BtnFontSize;
TextInfo.HorizontalAlignment = 'left';
TextInfo.HandleVisibility = 'callback';

StInfo = TextInfo;
StInfo.Style = 'text';
StInfo.BackgroundColor = FigColor;
StInfo.ForegroundColor = TextForeground ;

TextInfo.VerticalAlignment = 'bottom';

EdInfo = StInfo;
EdInfo.Style = 'edit';
EdInfo.BackgroundColor = White;

BtnInfo = StInfo;
BtnInfo.Style = 'pushbutton';
BtnInfo.HorizontalAlignment = 'center';

%--
% Determine # of lines for all Prompts
%--

ExtControl = uicontrol( ...
	StInfo, ...
	'String', '', ...    
	'Position', [DefOffset, DefOffset, 0.96*(FigWidth - 2*DefOffset), BtnHeight], ...
	'Visible', 'off'...
);

WrapQuest = cell(NumQuest,1);
QuestPos = zeros(NumQuest,4);

for ExtLp = 1:NumQuest
	if (size(NumLines,2) == 2)
		[WrapQuest{ExtLp},QuestPos(ExtLp,1:4)] = ...
			textwrap(ExtControl,Prompt(ExtLp),NumLines(ExtLp,2));
	else
		[WrapQuest{ExtLp},QuestPos(ExtLp,1:4)] = ...
			textwrap(ExtControl,Prompt(ExtLp),80);
	end
	
end

delete(ExtControl);
QuestHeight = QuestPos(:,4);

TxtHeight = QuestHeight(1) / size(WrapQuest{1,1},1);
EditHeight = TxtHeight * NumLines(:,1);
EditHeight(NumLines(:,1) == 1) = EditHeight(NumLines(:,1) == 1) + 4;

FigHeight = (NumQuest + 2) * DefOffset + ...
	BtnHeight + sum(EditHeight) + ...
sum(QuestHeight);

TxtXOffset = DefOffset;
TxtWidth = FigWidth - (2 * DefOffset);

QuestYOffset = zeros(NumQuest,1);
EditYOffset = zeros(NumQuest,1);
QuestYOffset(1) = FigHeight - DefOffset - QuestHeight(1);
EditYOffset(1) = QuestYOffset(1) - EditHeight(1); % -SmallOffset;

for YOffLp = 2:NumQuest
	QuestYOffset(YOffLp) = EditYOffset(YOffLp - 1) - QuestHeight(YOffLp) - DefOffset;
	EditYOffset(YOffLp) = QuestYOffset(YOffLp) - EditHeight(YOffLp); % -SmallOffset;
end

QuestHandle = [];
EditHandle = [];
FigWidth = 1;

AxesHandle = axes('Parent',InputFig,'Position',[0 0 1 1],'Visible','off');

%--
% create input dialog uicontrol objects
%--

for lp = 1:NumQuest
	
	%--
	% set tags for prompt and editable text or popup menu
	%--
	
	QuestTag = ['Prompt' num2str(lp)];
	EditTag = ['Edit' num2str(lp)];
	
	%--
	% check that default answers are strings or cells
	%--
	
	if (~isstr(DefAns{lp}) & ~iscell(DefAns{lp}) & ~isnumeric(DefAns{lp}))
		delete(InputFig);
		error('Default answers must be strings, cell arrays, or slider descriptors in ''input_dialog''.');
	end
	
	%--
	% create prompts
	%--
	
	QuestHandle(lp) = text( ...
		'Parent', AxesHandle, ...
		TextInfo, ...
		'Position', [TxtXOffset, QuestYOffset(lp)], ...
		'String', WrapQuest{lp}, ...
		'Color', TextForeground, ...
		'Interpreter', Interpreter, ...
		'Tag', QuestTag ...
	);
	
	%--
	% create editable text or popup menu depending on DefAns{lp} type
	%--
	
	%--
	% popup menu and listbox input
	%--
	
	if (iscell(DefAns{lp}))
		
		%--
		% popup menu input
		%--
		
		if (NumLines(lp,1) <= 1)
			
			%--
			% create a disabled popup menu when given a list of length 2
			%--
			
			if (length(DefAns{lp}) > 1)
				
				EdInfo.style = 'popup';
				EdInfo.enable = 'on';
				
				%--
				% check whether last element is numeric
				%--
				
				popup_value = DefAns{lp}{end};
				
				if (isnumeric(popup_value))
					DefAns{lp} = DefAns{lp}(1:end - 1);
				else
					popup_value = 1;
				end
				
			else
				
				EdInfo.style = 'popup';
				EdInfo.enable = 'off';
				
				set(QuestHandle(lp),'color',LightGray2);
				
				%--
				% check whether last element is numeric
				%--
				
				popup_value = DefAns{lp}{end};
				
				if (isnumeric(popup_value))
					DefAns{lp} = DefAns{lp}(1:end - 1);
				else
					popup_value = 1;
				end
				
			end
			
			NumLines(lp,1) = 1; % make sure that the menu has one row
			EditHeight(lp) = 0.9 * EditHeight(lp);
			
		%--
		% listbox input
		%--
		
		else
			
			EdInfo.style = 'listbox';
			EdInfo.enable = 'on';

			%--
			% check whether last element is numeric
			%--
			
			listbox_value = DefAns{lp}{end};
			
			if (isnumeric(listbox_value))
				DefAns{lp} = DefAns{lp}(1:end - 1);
			else
				listbox_value = 1;
			end
			
		end
		
	%--
	% edit box input
	%--
	
	elseif (isstr(DefAns{lp}))
		
		EdInfo.style = 'edit';
		EdInfo.enable = 'on';
		
		EditHeight(lp) = 0.9 * EditHeight(lp);
		
	%--
	% slider input
	%--
	
	elseif (isnumeric(DefAns{lp}))
		
		EdInfo.style = 'slider';
		EdInfo.enable = 'on';
		NumLines(lp,1) = 1; 
		EditHeight(lp) = 0.85 * EditHeight(lp);
		
	end
	
	%--
	% create basic uicontrol
	%--
	
	EditHandle(lp) = uicontrol( ...
		InputFig, EdInfo, ...
		'Max', NumLines(lp,1), ...
		'Position', [TxtXOffset, EditYOffset(lp), TxtWidth, EditHeight(lp)], ...
		'String', DefAns{lp}, ...
		'Tag', QuestTag ...
	);
	
	if (~isempty(tip{lp}))
		set(EditHandle(lp),'tooltipstring',tip{lp});
	end
	
	%--
	% additional property changes for popup menus, listboxes, and sliders
	%--
	
	switch (EdInfo.style)
		
	%--
	% popup
	%--
	
	case ('popup')

		%--
		% set value for popup menu
		%--
		
		set(EditHandle(lp),'value',popup_value);
		
	%--
	% listbox
	%--
	
	case ('listbox')

		%--
		% set value for listbox
		%--
		
		set(EditHandle(lp),'value',listbox_value);
		
	%--
	% slider
	%--
	
	case ('slider')

		set(EditHandle(lp),'background',LightGray);
		
		%--
		% set value, limit, and slider step properties
		%--
		
		tmp = DefAns{lp};
		
		switch (length(tmp))
			
		case (3)
			set(EditHandle(lp), ...
				'value', tmp(1), ...
				'min', tmp(2), ...
				'max', tmp(3) ...
			);
			slider_mode = 0;
			
		case (4)
			set(EditHandle(lp), ...
				'value', tmp(1), ...
				'min', tmp(2), ...
				'max', tmp(3) ...
			);
			slider_mode = tmp(end); 
		
		case (5)
			set(EditHandle(lp), ...
				'value', tmp(1), ...
				'min', tmp(2), ...
				'max', tmp(3), ...
				'sliderstep', tmp(4:5) ...
			);
			slider_mode = 0;
		
		case (6)
			set(EditHandle(lp), ...
				'value', tmp(1), ...
				'min', tmp(2), ...
				'max', tmp(3), ...
				'sliderstep', tmp(4:5) ...
			);
			slider_mode = tmp(end);
		
		otherwise
			disp('Improper slider description array.');
			
		end
		
		%--
		% set callback linking slider and edit box
		%--
			
		set(EditHandle(lp),'Callback',['input_slider_edit(''slider'',' int2str(slider_mode) ');']);
	
	end
	
	%--
	% reset position of uicontrols
	%--
	
	if (size(NumLines,2) == 2)
		
		set(EditHandle(lp),'String',char(ones(1,NumLines(lp,2))*'x'));
		Extent = get(EditHandle(lp),'Extent');
		
		NewPos = [TxtXOffset EditYOffset(lp)  Extent(3) EditHeight(lp) ];
		NewPos1= [TxtXOffset QuestYOffset(lp)];
		
		set(EditHandle(lp),'Position',NewPos,'String',DefAns{lp});
		set(QuestHandle(lp),'Position',NewPos1);
		
		FigWidth = max(FigWidth,Extent(3) + (2 * DefOffset));
		
	else
		
		FigWidth = max(175,TxtWidth+2*DefOffset);
		
	end
	
	%--
	% create edit boxes for sliders
	%--
	
	if (strcmp(EdInfo.style,'slider'))
		
		switch (slider_mode)
			
		%--
		% edit real number
		%--
		
		case (0)
			
			tmp1 = get(QuestHandle(lp),'position');
			tmp2 = get(EditHandle(lp),'position'); 
					
			tmp3 = EdInfo;
			tmp3.style = 'edit';
			
			uicontrol( ...
				InputFig, ... 
				tmp3, ...
				'Max', 1, ...
				'Position', [(tmp2(1) + (2/3)*tmp2(3)), tmp2(2) + tmp2(4), (1/3)*tmp2(3), tmp2(4)], ...
				'Tag', QuestTag, ...
				'Callback','input_slider_edit(''edit'',0);', ...
				'String', num2str(get(EditHandle(lp),'value')) ...
			);
		
		%--
		% time edit
		%--
		
		case (1)
			
			tmp1 = get(QuestHandle(lp),'position');
			tmp2 = get(EditHandle(lp),'position'); 
					
			tmp3 = EdInfo;
			tmp3.style = 'edit';
			
			uicontrol( ...
				InputFig, ... 
				tmp3, ...
				'Max', 1, ...
				'Position', [(tmp2(1) + (2/3)*tmp2(3)), tmp2(2) + tmp2(4), (1/3)*tmp2(3), tmp2(4)], ...
				'Tag', QuestTag, ...
				'Callback','input_slider_edit(''edit'',1);', ...
				'String', sec_to_clock(get(EditHandle(lp),'value')) ...
			);
		
		%--
		% edit integer
		%--
		
		case (2)
			
			tmp1 = get(QuestHandle(lp),'position');
			tmp2 = get(EditHandle(lp),'position'); 
					
			tmp3 = EdInfo;
			tmp3.style = 'edit';
			
			uicontrol( ...
				InputFig, ... 
				tmp3, ...
				'Max', 1, ...
				'Position', [(tmp2(1) + (2/3)*tmp2(3)), tmp2(2) + tmp2(4), (1/3)*tmp2(3), tmp2(4)], ...
				'Tag', QuestTag, ...
				'Callback','input_slider_edit(''edit'',2);', ...
				'String', num2str(round(get(EditHandle(lp),'value'))) ...
			);
		
		end
			
	end
	
end

FigPos = get(InputFig,'Position');

Temp = get(0,'Units');
set(0,'Units','points');
ScreenSize = get(0,'ScreenSize');
set(0,'Units',Temp);

FigWidth = max(FigWidth, (2 * (BtnWidth + DefOffset)) + DefOffset);
FigPos(1) = (ScreenSize(3) - FigWidth) / 2;
FigPos(2) = (ScreenSize(4) - FigHeight) / 2;
FigPos(3) = FigWidth;
FigPos(4) = FigHeight;

set(InputFig,'Position',FigPos);

%--
% create cancel and ok buttons along with redundant menus for button callbacks
%--

% parent menu for ok and cancel uimenus

% button_menu = uimenu(InputFig,'label','','callback','');

% this can be used to disable menu, when this is done make dialog modal

% set(button_menu,'visible','off');

%--
% cancel button and corresponding menu
%--

CBString = 'set(gcbf,''UserData'',''Cancel''); uiresume';

% uimenu(button_menu,'label','Cancel','callback',CBString,'accelerator','Z');

CancelHandle = uicontrol( ...
	InputFig, BtnInfo, ...
	'Position', [(FigWidth - BtnWidth - DefOffset), DefOffset, BtnWidth, BtnHeight], ...
	'String', 'Cancel', ...
	'Callback', CBString, ...
	'Tag', 'Cancel' ...
	);

%--
% ok button and corresponding menu
%--

CBString = 'set(gcbf,''UserData'',''OK''); uiresume;';

% uimenu(button_menu,'label','OK','callback',CBString,'accelerator','S');

OKHandle = uicontrol(InputFig    ,              ...
	BtnInfo     , ...
	'Position'  ,[ FigWidth - (2 * BtnWidth) - (2 * DefOffset), DefOffset ...
		BtnWidth                    BtnHeight ...
]           , ...
	'String'     ,'OK'        , ...
	'Callback'   ,CBString    , ...
	'Tag'        ,'OK'          ...
	);

Data.OKHandle = OKHandle;
Data.CancelHandle = CancelHandle;
Data.EditHandles = EditHandle;
Data.QuestHandles = QuestHandle;
Data.LineInfo = NumLines;
Data.ButtonWidth = BtnWidth;
Data.ButtonHeight = BtnHeight;
Data.EditHeight = TxtHeight + 4;
Data.Offset = DefOffset;

set(InputFig ,'Visible','on','UserData',Data);

%--
% remove menus and make modal
%--

set(gcf,'windowstyle','modal'); 

%--
% drawnow is a hack to work around a bug
%--

drawnow;

%--
% leave handle visibility alone
%--

% set(findall(InputFig),'Units','normalized','HandleVisibility','callback'); % original
% set(findall(InputFig),'Units','normalized','HandleVisibility','on');

set(InputFig,'Units','points')

% try
	uiwait(InputFig);
% catch
% 	delete(InputFig);
% end

TempHide = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');

%--
% get answers
%--

if (any(get(0,'Children') == InputFig))	
	
	Answer = {};
	
	if strcmp(get(InputFig,'UserData'),'OK')
		
		Answer = cell(NumQuest,1);
		
		for lp = 1:NumQuest
			
			%--
			% get popup menu and listbox input
			%--
			
			if (iscell(DefAns{lp}))
				
				%--
				% popup menu input
				%--
				
				if (NumLines(lp,1) == 1)
					
					tmp = DefAns{lp};
					Answer(lp) = tmp(get(EditHandle(lp),'value'));
					
				%--
				% listbox input
				%--
				
				else
					
					tmp = DefAns{lp};
					tmp = tmp(get(EditHandle(lp),'value'));
					Answer(lp) = {tmp};
						
				end
				
			%--
			% get editable text input
			%--
			
			elseif (isstr(DefAns{lp}))
				
				Answer(lp) = get(EditHandle(lp),{'String'});
			
			%--
			% get slider input
			%--
			
			elseif (isnumeric(DefAns{lp}))
				
				Answer{lp} = get(EditHandle(lp),'value');
				
			end 
			
		end 
		
	end 
	
	delete(InputFig);
	
	%--
	% user selected cancel, return empty answer
	%--
	
else
	
	Answer = {};
	
end 

set(0,'ShowHiddenHandles',TempHide);

%--
% subfunction - LocalResizeFcn
%--

function LocalResizeFcn(FigHandle)

Data = get(FigHandle,'UserData');

%Data.ButtonHandles = [ OKHandles CancelHandle];
%Data.EditHandles = EditHandle;
%Data.QuestHandles = QuestHandle;
%Data.LineInfo = NumLines;
%Data.ButtonWidth = BtnWidth;
%Data.ButtonHeight = BtnHeight;
%Data.EditHeight = TxtHeight;

set(findall(FigHandle),'Units','points');

FigPos = get(FigHandle,'Position');
FigWidth = FigPos(3); FigHeight = FigPos(4);

OKPos = [ FigWidth-Data.ButtonWidth-Data.Offset Data.Offset ...
		Data.ButtonWidth                      Data.ButtonHeight ];
CancelPos =[Data.Offset Data.Offset Data.ButtonWidth  Data.ButtonHeight];
set(Data.OKHandle,'Position',OKPos);
set(Data.CancelHandle,'Position',CancelPos);

% Determine the height of all question fields
YPos = sum(OKPos(1,[2 4]))+Data.Offset;
QuestPos = get(Data.QuestHandles,{'Extent'});
QuestPos = cat(1,QuestPos{:});
QuestPos(:,1) = Data.Offset;
RemainingFigHeight = FigHeight - YPos - sum(QuestPos(:,4)) - ...
	Data.Offset - size(Data.LineInfo,1)*Data.Offset;

Num1Liners = length(find(Data.LineInfo(:,1)==1));

RemainingFigHeight = RemainingFigHeight - ...
	Num1Liners*Data.EditHeight;

Not1Liners = find(Data.LineInfo(:,1)~=1);

%Scale the 1 liner heights appropriately with remaining fig height
TotalLines = sum(Data.LineInfo(Not1Liners,1));

% Loop over each quest/text pair

for lp = 1:length(Data.QuestHandles),
	CurPos = get(Data.EditHandles(lp),'Position');
	NewPos = [Data.Offset YPos  CurPos(3) Data.EditHeight ];
	if Data.LineInfo(lp,1) ~= 1,
		NewPos(4) = RemainingFigHeight*Data.NumLines(lp,1)/TotalLines;
	end
	
	set(Data.EditHandles(lp),'Position',NewPos);
	YPos = sum(NewPos(1,[2 4]));
	QuestPos(lp,2) = YPos;QuestPos(lp,3) = NewPos(3);
	set(Data.QuestHandles(lp),'Position',QuestPos(lp,:));
	YPos = sum(QuestPos(lp,[2 4]))+Data.Offset;
end

if YPos>FigHeight - Data.Offset,
	FigHeight = YPos+Data.Offset;
	FigPos(4)=FigHeight;
	set(FigHandle,'Position',FigPos);  
	drawnow;
end
set(FigHandle,'ResizeFcn','input_dialog2 InputDlgResizeCB');

set(findall(FigHandle),'Units','normalized');



