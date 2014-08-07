function fout = wait_bar(x,whichbar, varargin)
%WAITBAR Display wait bar.
%   H = WAITBAR(X,'title', property, value, property, value, ...) 
%   creates and displays a wait_bar of fractional length X.  The 
%   handle to the wait_bar figure is returned in H.
%   X should be between 0 and 1.  Optional arguments property and 
%   value allow to set corresponding wait_bar figure properties.
%   Property can also be an action keyword 'CreateCancelBtn', in 
%   which case a cancel button will be added to the figure, and 
%   the passed value string will be executed upon clicking on the 
%   cancel button or the close figure button.
%
%   WAITBAR(X) will set the length of the bar in the most recently
%   created wait_bar window to the fractional length X.
%
%   WAITBAR(X,H) will set the length of the bar in wait_bar H
%   to the fractional length X.
%
%   WAITBAR(X,H,'updated title') will update the title text in
%   the wait_bar figure, in addition to setting the fractional
%   length to X.
%
%   WAITBAR is typically used inside a FOR loop that performs a 
%   lengthy computation.  A sample usage is shown below:
%
%       h = wait_bar(0,'Please wait...');
%       for i=1:100,
%           % computation here %
%           wait_bar(i/100,h)
%       end
%       close(h)

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

%   Clay M. Thompson 11-9-92
%   Vlad Kolesnikov  06-7-99
%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 2004-02-11 06:56:08-05 $

if (nargin >= 2)
	
	if ischar(whichbar)
		type = 2; %we are initializing
		name = whichbar;
	elseif isnumeric(whichbar)
		type = 1; %we are updating, given a handle
		f = whichbar;
	else
		error(['Input arguments of type ' class(whichbar) ' not valid.'])
	end
	
elseif (nargin == 1)
	
	f = findobj(allchild(0),'flat','Tag','TMWWaitbar');
	
	if isempty(f)
		type = 2;
		name = '';
	else
		type = 1;
		f = f(1);
	end  
	
else
	
	error('Input arguments not valid.');
	
end

x = max(0,min(100*x,100));

switch type
	
	%--
	% waitbar update
	%--
	
	case (1)
		
		%--
		% udpate patch and line
		%--
		
		p = findobj(f,'Type','patch');
		l = findobj(f,'Type','line');
		
		if isempty(f) | isempty(p) | isempty(l), 
			error('Couldn''t find wait_bar handles.'); 
		end
		
		xpatch = get(p,'XData');
		xpatch = [0 x x 0];
		set(p,'XData',xpatch);
		
		xline = get(l,'XData');
		set(l,'XData',xline);
		
		%--
		% udpate title if needed
		%--
		
		if (nargin > 2)
			hAxes = findobj(f,'type','axes');
			hTitle = get(hAxes,'title');
			set(hTitle,'string',varargin{1});
		end
		
	%--
	% waitbar initialize
	%--
	
	case (2)
		
		vertMargin = 0;
		
		if (nargin > 2)
			% we have optional arguments: property-value pairs
			if rem (nargin, 2 ) ~= 0
				error( 'Optional initialization arguments must be passed in pairs' );
			end
		end
		
		oldRootUnits = get(0,'Units');
		
		set(0, 'Units', 'points');
		screenSize = get(0,'ScreenSize');
		
		%--
		% this changes the fontsize used to display the message in the
		% waitbar
		%--
		
% 		axFontSize=get(0,'FactoryAxesFontSize');
		axFontSize = get(0,'defaultuicontrolfontsize');
		
		pointsPerPixel = 72/get(0,'ScreenPixelsPerInch');
		
% 		width = 360 * pointsPerPixel;
% 		height = 75 * pointsPerPixel;
		
		width = 400 * pointsPerPixel;
		height = 100 * pointsPerPixel;
		
		pos = [screenSize(3)/2-width/2 screenSize(4)/2-height/2 width height];
		
		f = figure(...
			'Units', 'points', ...
			'BusyAction', 'queue', ...
			'Position', pos, ...
			'Resize','off', ...
			'CreateFcn','', ...
			'NumberTitle','off', ...
			'IntegerHandle','off', ...
			'MenuBar', 'none', ...
			'Tag','TMWWaitbar',...
			'Interruptible', 'off', ...
			'Color', get(0,'Defaultuicontrolbackgroundcolor'), ... % modified
			'Visible','off' ...
		);
		
		%%%%%%%%%%%%%%%%%%%%%
		% set figure properties as passed to the fcn
		% pay special attention to the 'cancel' request
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		if (nargin > 2)
			
			propList = varargin(1:2:end);
			valueList = varargin(2:2:end);
			
			cancelBtnCreated = 0;
			
			for ii = 1:length( propList )
				
				try
					
					%--
					% the property 'createcancelbtn' sets the closerequestfcn
					%--
					
					if strcmp(lower(propList{ii}), 'createcancelbtn' ) & ~cancelBtnCreated
						
						cancelBtnHeight = 24 * pointsPerPixel;
						cancelBtnWidth = 62 * pointsPerPixel;
						
						vertMargin = vertMargin + cancelBtnHeight;
						
						newPos = pos;
						newPos(4) = newPos(4)+vertMargin;
						
						callbackFcn = [valueList{ii}];
						set( f, 'Position', newPos, 'CloseRequestFcn', callbackFcn );
						
						cancelButt = uicontrol('Parent',f, ...
							'Units','points', ...
							'Callback',callbackFcn, ...
							'ButtonDownFcn', callbackFcn, ...
							'Enable','on', ...
							'Interruptible','off', ...
							'Position', [pos(3)-cancelBtnWidth*1.4, 7,  ...
								cancelBtnWidth, cancelBtnHeight], ...
							'String','Cancel', ...
							'Tag','TMWWaitbarCancelButton' ...
						);
					
						cancelBtnCreated = 1;
						
					else
						
						%--
						% simply set the prop/value pair of the figure
						%--
						
						set( f, propList{ii}, valueList{ii});
						
					end
					
				catch
					
					disp ( ['Warning: could not set property ''' propList{ii} ''' with value ''' num2str(valueList{ii}) '''' ] );
					
				end
				
			end
		end  
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
		
		
		%--
		% create axes to display waitbar patch
		%--
		
		colormap([]);
		
		axNorm=[.05 .3 .9 .2];
		axPos=axNorm.*[pos(3:4),pos(3:4)] + [0 vertMargin 0 0];
		
		h = axes( ...
			'XLim',[0 100],... % 'XLim',[0 100],...
			'YLim',[0.01 1.01],... % 'YLim',[0 1], ...
			'Box','on', ...
			'Units','Points',...
			'FontSize', axFontSize,...
			'FontWeight','normal', ...
			'Position',axPos,...
			'xcolor',0.25 * ones(1,3), ...
			'ycolor',0.25 * ones(1,3), ...
			'XTickMode','manual',...
			'YTickMode','manual',...
			'XTick',[],... % consider using some ticks
			'YTick',[],...
			'XTickLabelMode','manual',...
			'XTickLabel',[],...
			'YTickLabelMode','manual',...
			'YTickLabel',[] ...
		);
		
		tHandle=title(name);
		tHandle=get(h,'title');
		oldTitleUnits=get(tHandle,'Units');
		set(tHandle,...
			'Units',      'points',...
			'String',     name);
		
		tExtent=get(tHandle,'Extent');
		set(tHandle,'Units',oldTitleUnits);
		
		titleHeight=tExtent(4)+axPos(2)+axPos(4)+5;
		
		if titleHeight>pos(4)
			pos(4)=titleHeight;
			pos(2)=screenSize(4)/2-pos(4)/2;
			figPosDirty=logical(1);
		else
			figPosDirty=logical(0);
		end
		
		if tExtent(3)>pos(3)*1.10;
			pos(3)=min(tExtent(3)*1.10,screenSize(3));
			pos(1)=screenSize(3)/2-pos(3)/2;
			
			axPos([1,3])=axNorm([1,3])*pos(3);
			set(h,'Position',axPos);
			
			figPosDirty=logical(1);
		end
		
		if figPosDirty
			set(f,'Position',pos);
		end
		
		%--
		% create patch to be waitbar
		%--
		
		xpatch = [0 x x 0];
		ypatch = [0 0 1 1];
		xline = [100 0 0 100 100];
		yline = [0 0 1 1 0];
		
		p = patch(xpatch, ypatch, 'r', ...
			'EdgeColor',0.25 * ones(1,3), ... % 'EdgeColor','r', ...
			'EraseMode','none' ...
		);
	
		l = line(xline,yline,'EraseMode','none');
		
		set(l,'Color',get(gca,'XColor'));
		
		%--
		% note that this figure handle is not visible
		%--
		
		set(f,'HandleVisibility','callback','visible','on');
				
		set(0, 'Units', oldRootUnits);
		
end  % case

drawnow;

if nargout==1,
	fout = f;
end
