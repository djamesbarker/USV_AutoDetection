function k = truesize_max(h)

% truesize_max - maximize image display
% -------------------------------------
%
% k = truesize_max(h)
%
% Input:
% ------
%  h - figure handle
%
% Output:
% -------
%  k - scaling factor used

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

%--
% set handle
%--

if (~nargin)
	h = gcf;
end

%--
% get maximum integer scaling
%--

k = 0;

f = 1;

mn = size(get_image_data(h));
mn = mn(1:2);

while (f)
	k = k + 1;
	f = truesize_out(h,k*mn);
end

k = k - 1;

%--
% resize display using truesize
%--

truesize(h,k*mn);


%---------------------------------------------
% SUBFUBCTION
%---------------------------------------------

function f = truesize_out(varargin)

% 
%TRUESIZE Adjust the display size of an image.
%   TRUESIZE(FIG,REQSIZE) adjusts the display size of an
%   image. FIG is a figure containing a single image or a single 
%   image with a colorbar. REQSIZE is a 1-by-2 vector [HEIGHT
%   WIDTH] that specifies the requested screen area (in pixels)
%   that the image should occupy.
%
%   TRUESIZE(FIG) uses the image height and width for REQSIZE.
%
%   If the figure contains multiple images in different axes,
%   TRUESIZE adjusts the figure so that the image in the current
%   will be displayed truesize.
%
%   TRUESIZE will not change the figure size so that it is larger
%   than the screen or smaller than 128-by-128 pixels.
%
%   See also IMSHOW.

%   Clay M. Thompson 10-15-92
%   Revised Steven L. Eddins, September 1996
%   Copyright (c) 1993-1996 by The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2003-09-16 01:31:21-04 $

[axHandle, imHandle, colorbarHandle, imSize, resizeType, msg] = ...
        ParseInputs(varargin{:});
if (~isempty(msg))
    error(msg);
end

switch resizeType

case (1)

    % Figure contains one image and nothing else
    
	%--
	% MODIFICATION
	%--
	
	f = 1;
    f = Resize1(axHandle, imHandle, imSize);
    
case (2)

    % Figure contains other noncolorbar axes
    % or uicontrols.

	%--
	% MODIFICATION
	%--
	
	f = 1;
    f = Resize2(axHandle, imHandle, imSize);
    
case (3)

    % Figure contains one image and a colorbar.

	%--
	% MODIFICATION
	%--
	
	f = 1;
    f = Resize3(axHandle, imHandle, imSize, colorbarHandle);
    
end

%--------------------------------------------
% Subfunction ParseInputs
%--------------------------------------------

function [axHandle,imHandle,colorbarHandle,imSize,resizeType,msg] = ...
        ParseInputs(varargin)

imSize = [];
colorbarHandle = [];
msg = '';
axHandle = [];
imHandle = [];
resizeType = [];

if (nargin == 0)
    axHandle = gca;
end
    
if (nargin >= 1)
    if ((nargin == 1) & isequal(size(varargin{1}), [1 2]))
        % truesize([M N])
        figHandle = gcf;
        imSize = varargin{1};
        
    else
        % truesize(FIG, ...)
        if (~ishandle(varargin{1}) | ~strcmp(get(varargin{1},'type'),'figure'))
            msg = 'FIG must be a valid figure handle';
            return;
        else
            figHandle = varargin{1};
        end
    end
    
    axHandle = get(figHandle, 'CurrentAxes');
    if (isempty(axHandle))
        msg = 'Current figure has no axes';
        return;
    end
end

if (nargin >= 2)
    imSize = varargin{2};
    if (~isequal(size(imSize), [1 2]))
        msg = 'REQSIZE must be a 1-by-2 vector';
        return;
    end
end

figHandle = get(axHandle, 'Parent');

% Find all the images and texturemapped surfaces
% in the current figure.  These are the candidates.
h = [findobj(figHandle, 'Type', 'image') ;
    findobj(figHandle, 'Type', 'surface', ...
            'FaceColor', 'texturemap')];

% If there's a colorbar, ignore it.
colorbarHandle = findobj(figHandle, 'type', 'image', ...
        'Tag', 'TMW_COLORBAR');
if (~isempty(colorbarHandle))
    for k = 1:length(colorbarHandle)
        h(h == colorbarHandle(k)) = [];
    end
end

if (isempty(h))
    msg = 'No images or texturemapped surfaces in the figure';
    return;
end

% Start with the first object on the list as the
% initial candidate.  If it's not in the current
% axes, look for another one that is.
imHandle = h(1);
if (get(imHandle,'Parent') ~= axHandle)
    for k = 2:length(h)
        if (get(h(k),'Parent') == axHandle)
            imHandle = h(k);
            break;
        end
    end
end

figKids = allchild(figHandle);
if ((length(findobj(figKids, 'flat', 'Type', 'axes')) == 1) & ...
            (length(findobj(figKids, 'flat', 'Type', 'uicontrol', ...
            'Visible', 'on')) == 0) & ...
            (length(imHandle) == 1))
    % Resize type 1
    % Figure contains only one axes object, which contains only
    % one image.
    resizeType = 1;

elseif (isempty(colorbarHandle))
    % Figure contains other objects and not a colorbar.
    resizeType = 2;
    
else
    % Figure contains a colorbar.  Do we have a one image
    % one colorbar situation?
    if (length(colorbarHandle) > 1)
        % No
        resizeType = 2;
    else
        colorbarAxes = get(colorbarHandle, 'Parent');
        uimenuKids = findobj(figKids, 'flat', 'Type', 'uimenu');
        invisUicontrolKids = findobj(figKids, 'flat', 'Type', 'uicontrol', ...
                'Visible', 'off');
        otherKids = setdiff(figKids, ...
                [uimenuKids ; colorbarAxes ; axHandle ; invisUicontrolKids]);
        if (length(otherKids) > 1)
            % No
            resizeType = 2;
        else
            % Yes, one image and one colorbar
            resizeType = 3;
        end
    end
end


%--------------------------------------------
% Subfunction Resize1
%--------------------------------------------

function f = Resize1(axHandle, imHandle, imSize)

% Resize figure containing a single axes
% object with a single image.

if (isempty(imSize))
    % How big is the image?
    imageWidth = size(get(imHandle, 'CData'), 2);
    imageHeight = size(get(imHandle, 'CData'), 1);
else
    imageWidth = imSize(2);
    imageHeight = imSize(1);
end

figLeftBorder = 10;  % assume left figure decorations are 10 pixels
figRightBorder = 10;
figBottomBorder = 10;
figTopBorder = 50;

minFigWidth = 128; % don't try to display a figure smaller than this.
minFigHeight = 128;

figHandle = get(axHandle, 'Parent');
figUnits = get(figHandle, 'Units');
axUnits = get(axHandle, 'Units');
rootUnits = get(0, 'Units');
set(figHandle, 'Units', 'pixels');
set(axHandle, 'Units', 'pixels');

% What are the gutter sizes?
axPos = get(axHandle, 'Position');
figPos = get(figHandle, 'Position');
gutterLeft = max(axPos(1) - 1, 0);
gutterRight = max(figPos(3) - (axPos(1) + axPos(3)) + 1, 0);
gutterBottom = max(axPos(2) - 1, 0);
gutterTop = max(figPos(4) - (axPos(2) + axPos(4)) + 1, 0);

% What are the screen dimensions
screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);
if ((screenWidth <= 1) | (screenHeight <= 1))
    screenWidth = Inf;
    screenHeight = Inf;
end

% If the gutters are nonzero, make them be at least 
% as big as MATLAB defaults.
if (gutterLeft >= 1)
    % What are MATLAB's default gutters?
    defFigPos = get(0,'FactoryFigurePosition');
    defAxPos = get(0,'FactoryAxesPosition');
    minGutterLeft = round(defAxPos(1) * defFigPos(3));
    minGutterRight = round((1 - defAxPos(1) - defAxPos(3)) * defFigPos(3));
    minGutterBottom = round(defAxPos(2) * defFigPos(4));
    minGutterTop = round((1 - defAxPos(2) - defAxPos(4)) * defFigPos(4));

    gutterLeft = max(gutterLeft, minGutterLeft);
    gutterRight = max(gutterRight, minGutterRight);
    gutterBottom = max(gutterBottom, minGutterBottom);
    gutterTop = max(gutterTop, minGutterTop);
end

% Note: in code below, the actual gutters used will be adjusted
% so that the image is centered.

scale = 100;
done = 0;
while (~done)
    newFigWidth = imageWidth + gutterLeft + gutterRight;
    newFigHeight = imageHeight + gutterBottom + gutterTop;
    
    if (((newFigWidth + figLeftBorder + figRightBorder) > screenWidth) | ...
                ((newFigHeight + figBottomBorder + figTopBorder) > screenHeight))
        imageWidth = round(imageWidth / 2);
        imageHeight = round(imageHeight / 2);
        scale = 3 * scale / 4;        
    else
        done = 1;
    end
    
end

newFigWidth = max(newFigWidth, minFigWidth);
newFigHeight = max(newFigHeight, minFigHeight);
figPos(1) = figPos(1) - floor((newFigWidth - figPos(3))/2);
figPos(2) = figPos(2) - floor((newFigHeight - figPos(4))/2);
figPos(3) = newFigWidth;
figPos(4) = newFigHeight;

% Translate figure position if necessary
deltaX = (screenSize(3) - figRightBorder) - (figPos(1) + figPos(3));
if (deltaX < 0)
    figPos(1) = figPos(1) + deltaX;
end
deltaY = (screenSize(4) - figTopBorder) - (figPos(2) + figPos(4));
if (deltaY < 0)
    figPos(2) = figPos(2) + deltaY;
end

% Figure out where to place the axes object in the
% resized figure
horizGutter = figPos(3) - imageWidth;
vertGutter = figPos(4) - imageHeight;
gutterLeft = floor(horizGutter/2);
gutterBottom = floor(vertGutter/2);

axPos(1) = gutterLeft + 1;
axPos(2) = gutterBottom + 1;
axPos(3) = imageWidth;
axPos(4) = imageHeight;

%--
% MODIFICATION
%--

% Restore the units
drawnow;  % necessary to work around HG bug   -SLE
set(figHandle, 'Units', figUnits);
set(axHandle, 'Units', axUnits);
set(0, 'Units', rootUnits);

% Set the nextplot property of the figure so that the
% axes object gets deleted and replaced for the next plot.
% That way, the new plot gets drawn in the default position.
set(figHandle, 'NextPlot', 'replacechildren');

if (scale < 100)
	f = 0;
	break;
else
	f = 1;
	break;
	set(figHandle, 'Position', figPos)
	set(axHandle, 'Position', axPos);
end

% Warn if the display is not truesize.
if (scale < 100)
    message = ['Image is too big to fit on screen; ', ...
                sprintf('displaying at %d%% scale.', floor(scale))];
    warning(message);
end

%--------------------------------------------
% Subfunction Resize2
%--------------------------------------------
% Resize figure containing multiple axes or
% other objects.  Basically we're going to
% compute a global figure scaling factor
% that will bring the target image into
% truesize mode.  This works reasonably well
% for subplot-type figures as long as all
% the images have the same size.  This is
% basically the guts of truesize.m from IPT
% version 1.

function f = Resize2(axHandle, imHandle, imSize)

if (isempty(imSize))
    imSize = size(get(imHandle, 'CData'));
end

figHandle = get(axHandle, 'Parent');
axUnits = get(axHandle, 'Units');
figUnits = get(figHandle, 'Units');
rootUnits = get(0,'Units');
set(axHandle, 'Units', 'normalized');
set([figHandle 0], 'Units', 'pixels');
axPosition = get(axHandle, 'Position');
figPosition = get(figHandle, 'Position');
screenSize = get(0,'ScreenSize');

% What should the new figure size be?
dx = ceil(imSize(2)/axPosition(3) - figPosition(3));
dy = ceil(imSize(1)/axPosition(4) - figPosition(4));
newFigWidth = figPosition(3) + dx;
newFigHeight = figPosition(4) + dy;

% Is the new figure size too big or too small?
figLeftBorder = 10;
figRightBorder = 10;
figBottomBorder = 10;
figTopBorder = 50;
minFigWidth = 128;
minFigHeight = 128;

if ((newFigWidth + figLeftBorder + figRightBorder) > screenSize(3))
    scaleX = screenSize(3) / (newFigWidth + figLeftBorder + figRightBorder);
else
    scaleX = 1;
end

if ((newFigHeight + figBottomBorder + figTopBorder) > screenSize(4))
    scaleY = screenSize(4) / (newFigHeight + figBottomBorder + figTopBorder);
else
    scaleY = 1;
end

if (newFigWidth < minFigWidth)
    scaleX = minFigWidth / newFigWidth;
end
if (newFigHeight < minFigHeight)
    scaleY = minFigHeight / newFigHeight;
end

if (min(scaleX, scaleY) < 1)
    % Yes, the new figure is too big for the screen.
    scale = min(scaleX, scaleY);
    newFigWidth = floor(newFigWidth * scale);
    newFigHeight = floor(newFigHeight * scale);
elseif (max(scaleX, scaleY) > 1)
    % Yes, the new figure is too small.
    scale = max(scaleX, scaleY);
    newFigWidth = floor(newFigWidth * scale);
    newFigHeight = floor(newFigHeight * scale);
else
    scale = 1;
end

figPosition(3) = newFigWidth;
figPosition(4) = newFigHeight;

% Translate figure position if necessary
deltaX = (screenSize(3) - figRightBorder) - (figPosition(1) + figPosition(3));
if (deltaX < 0)
    figPosition(1) = figPosition(1) + deltaX;
end
deltaY = (screenSize(4) - figTopBorder) - (figPosition(2) + figPosition(4));
if (deltaY < 0)
    figPosition(2) = figPosition(2) + deltaY;
end

% Change axes position to get exactly one pixel per image pixel.
% That is, as long as scale = 1.
dx = scale*imSize(2)/figPosition(3) - axPosition(3);
dy = scale*imSize(1)/figPosition(4) - axPosition(4);
axPosition = axPosition + [-dx/2 -dy/2 dx dy];

% OK, make the changes

%--
% MODIFICATION
%--

% Restore the original units
set(axHandle, 'Units', axUnits);
set(figHandle, 'Units', figUnits);
set(0, 'Units', rootUnits);

if (scale < 100)
	f = 0;
	break;
else
	f = 1;
	break;
	set(axHandle, 'Position', axPosition);
	set(figHandle, 'Position', figPosition);
end

% Warn if the display is not truesize.
if (scale < 1)
    message = ['Image is too big to fit on screen; ', ...
                sprintf('displaying at %d%% scale.', round(100*scale))];
    warning(message);
elseif (scale > 1)
    message = ['Image is too small for truesize figure scaling; ', ...
                sprintf('\ndisplaying at %d%% scale.', round(100*scale))];
    warning(message);
end

%--------------------------------------------
% Subfunction Resize3
%--------------------------------------------

function f = Resize3(axHandle, imHandle, imSize, colorbarHandle)

% Resize figure containing an image, a colorbar, 
% and nothing else.

if (isempty(imSize))
    % How big is the image?
    imageWidth = size(get(imHandle, 'CData'), 2);
    imageHeight = size(get(imHandle, 'CData'), 1);
else
    imageWidth = imSize(2);
    imageHeight = imSize(1);
end

figLeftBorder = 10;  % assume left figure decorations are 10 pixels
figRightBorder = 10;
figBottomBorder = 10;
figTopBorder = 50;

minFigWidth = 128; % don't try to display a figure smaller than this.
minFigHeight = 128;

colorbarGap = 30;   % pixels
colorbarWidth = 20; % pixels

caxHandle = get(colorbarHandle, 'Parent');
figHandle = get(axHandle, 'Parent');
figUnits = get(figHandle, 'Units');
axUnits = get(axHandle, 'Units');
caxUnits = get(caxHandle, 'Units');
rootUnits = get(0, 'Units');
set(figHandle, 'Units', 'pixels');
set(axHandle, 'Units', 'pixels');
set(caxHandle, 'Units', 'pixels');

axPos = get(axHandle, 'Position');
caxPos = get(caxHandle, 'Position');
figPos = get(figHandle, 'Position');

if ((axPos(1) + axPos(3)) < caxPos(1))
    orientation = 'vertical';
else
    orientation = 'horizontal';
end

% Use MATLAB's default gutters
defFigPos = get(0,'FactoryFigurePosition');
defAxPos = get(0,'FactoryAxesPosition');
gutterLeft = round(defAxPos(1) * defFigPos(3));
gutterRight = round((1 - defAxPos(1) - defAxPos(3)) * defFigPos(3));
gutterBottom = round(defAxPos(2) * defFigPos(4));
gutterTop = round((1 - defAxPos(2) - defAxPos(4)) * defFigPos(4));

% What are the screen dimensions
screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);
if ((screenWidth <= 1) | (screenHeight <= 1))
    screenWidth = Inf;
    screenHeight = Inf;
end

scale = 100;
done = 0;
while (~done)
    if (strcmp(orientation, 'vertical'))
        newFigWidth = imageWidth + gutterLeft + gutterRight + ...
                colorbarGap + colorbarWidth;
        newFigHeight = imageHeight + gutterBottom + gutterTop;
    else
        newFigWidth = imageWidth + gutterLeft + gutterRight;
        newFigHeight = imageHeight + gutterBottom + gutterTop + ...
                colorbarGap + colorbarWidth;
    end
    if (((newFigWidth + figLeftBorder + figRightBorder) > screenWidth) | ...
                ((newFigHeight + figBottomBorder + figTopBorder) > ...
                screenHeight))
        imageWidth = round(imageWidth / 2);
        imageHeight = round(imageHeight / 2);
        scale = 3 * scale / 4;
    else
        done = 1;
    end
end
        
newFigWidth = max(newFigWidth, minFigWidth);
newFigHeight = max(newFigHeight, minFigHeight);
figPos(3) = newFigWidth;
figPos(4) = newFigHeight;

% Translate figure position if necessary
deltaX = (screenSize(3) - figRightBorder) - (figPos(1) + figPos(3));
if (deltaX < 0)
    figPos(1) = figPos(1) + deltaX;
end
deltaY = (screenSize(4) - figTopBorder) - (figPos(2) + figPos(4));
if (deltaY < 0)
    figPos(2) = figPos(2) + deltaY;
end

axPos = [gutterLeft gutterBottom imageWidth imageHeight];

if (strcmp(orientation, 'vertical'))
    left = gutterLeft + imageWidth + colorbarGap;
    bottom = gutterBottom;
    width = colorbarWidth;
    height = imageHeight;
else
    left = gutterLeft;
    bottom = gutterBottom;
    width = imageWidth;
    height = colorbarWidth;
    axPos(2) = axPos(2) + colorbarGap + colorbarWidth;
end
caxPos = [left bottom width height];

%--
% MODIFICATION
%--

% Restore the units
drawnow;  % necessary to work around HG bug      -SLE
set(figHandle, 'Units', figUnits);
set(axHandle, 'Units', axUnits);
set(caxHandle, 'Units', caxUnits);
set(0, 'Units', rootUnits);

% Set the nextplot property of the figure so that the
% axes object gets deleted and replaced for the next plot.
% That way, the new plot gets drawn in the default position.
set(figHandle, 'NextPlot', 'replacechildren');

if (scale < 100)
	f = 0;
	break;
else
	f = 1;
	break;
	set(figHandle, 'Position', figPos);
	set(axHandle, 'Position', axPos);
	set(caxHandle, 'Position', caxPos);
end

% Warn if the display is not truesize.
if (scale < 100)
    message = ['Image is too big to fit on screen; ', ...
                sprintf('displaying at %d%% scale.', floor(scale))];
    warning(message);
end
