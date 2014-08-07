function browser_resizefcn(par, data)

% browser_resizefcn - resize function for sound browser
% -----------------------------------------------------
%
% browser_resizefcn(par)
%
% Input:
% ------
%  par - browser handle

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
% $Date: 2005-08-25 10:08:52 -0400 (Thu, 25 Aug 2005) $
% $Revision: 1676 $
%--------------------------------

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% check browser handle input
%--

if ~nargin
	
	par = get_active_browser;

	if isempty(par)
		return;
	end
	
else

	% NOTE: we throw an error, because we should know when we input garbage
	
	if ~is_browser(par)
		error('Browser handle input is not browser handle.');
	end
	
end

%--
% set resize function callback
%--

resizefcn = get(par, 'resizefcn');

if isempty(resizefcn) && ~isa(resizefcn, 'function_handle')
	
	set(par, 'resizefcn', @browser_resize_callback);

end

%--
% get parent state
%--

if (nargin < 2) || isempty(data)
	data = get_browser(par);
end

%-----------------------------------
% SETUP
%-----------------------------------

%--
% get relevant handles for resize
%--

handles = get_browser_handles(par, data);

%--
% create object indicators
%--

status_bar = ~isempty(handles.status.bar);

color_bar = ~isempty(handles.colorbar);

slider = strcmpi(get(handles.slider, 'visible'), 'on');

%--
% set figure pixel units and get size
%--

set(par, 'units', 'pixels'); 

pos = get(par, 'position');

%--
% compute values needed for updating positions
%--

[layout, tile] = browser_tile_layout(status_bar, color_bar, slider);

%--
% compute tile width and height as fractions of figure
%--

scale = 1;

hh = (scale * tile) / pos(4); 

ww = (scale * tile) / pos(3);

%--
% convert layout to fractions of width/height
%--

layout.top = layout.top * hh;

layout.bottom = layout.bottom * hh;

layout.yspace = layout.yspace * hh;

layout.left = layout.left * ww;

layout.right = layout.right * ww;

%--
% compute axes positions using axes array
%--

n = length(handles.axes);

pos = axes_array(n, 1, layout);

if isempty(pos)
	return;
end

%-----------------------------------
% UPDATE OBJECT POSTIONS
%-----------------------------------

%--
% resize when no colorbar
%--

if isempty(handles.colorbar)

	%--
	% update positions of channel axes
	%--
	
	for k = 1:n
		if any(pos{k} <= 0)
			return;
		end
	end
	
	for k = 1:n
		set(handles.axes(k), 'position', pos{k});
	end
	
	%--
	% update position of support axes
	%--

	set(handles.support, ...
		'position', [ ...
			layout.left, ...
			layout.bottom, ...
			1 - (layout.left + layout.right), ...
			1 - (layout.top + layout.bottom) ...
		] ...
	);
	
	%--
	% update position of slider and status bar if available
	%--

	if isempty(handles.status.bar)
		
		set(handles.slider, ...
			'position', [layout.left, hh, pos{1}(3), hh] ...
		);
		
	else	
		
		set(handles.slider, ...
			'position',[layout.left, 2.5*hh, pos{1}(3), hh] ...
		);
		
		set(handles.status.bar, 'position', [0, 0, 1, 1.25*hh]);

		tmp = get(handles.status.text.left, 'position'); tmp(1) = 4.5*ww/tile;
		
		set(handles.status.text.left, 'position', tmp);
		
		tmp = get(handles.status.text.right, 'position'); tmp2 = get(handles.status.text.right, 'extent'); tmp(1) = (1 - 3*ww/tile) - tmp2(3);
		
		set(handles.status.text.right, 'position', tmp);

	end
	
%--
% resize when colorbar present
%--

else

	%--
	% update positions of channel axes
	%--
	
	% compute positions of channel axes, return when figure is too small
	
	for k = 1:n
		tmp{k} = [pos{k}(1), pos{k}(2), 1 - (layout.left + 4*ww), pos{k}(4)];
		if any(tmp{k} <= 0)
			return;
		end
	end
	
	% set positions of channel axes
	
	for k = 1:n
		set(handles.axes(k), 'position', tmp{k});
	end
	
	%--
	% update position of support axes and colorbar
	%--

	posk = [layout.left, layout.bottom, 1 - (layout.left + 8*ww), 1 - (layout.top + layout.bottom)];
	set(handles.support, 'position', posk);

	posk = [1 - 3.5*ww, layout.bottom, 1.5*ww, 1 - (layout.top + layout.bottom)];
	set(handles.colorbar, 'position', posk);

	%--
	% update position of slider and status bar if available
	%--

	if isempty(handles.status.bar)
		
		posk = [layout.left, hh, 1 - (layout.left + 4*ww), hh];
		
		set(handles.slider, 'position', posk);
		
	else 
		
		posk = [layout.left, 2.25*hh, 1 - (layout.left + 4*ww), hh];
		set(handles.slider, 'position', posk);
		set(handles.status.bar, 'position', [0, 0, 1, 1.25*hh]);

		tmp = get(handles.status.text.left, 'position');
		tmp(1) = 4.5*ww/tile;
		set(handles.status.text.left, 'position', tmp);
		
		tmp = get(handles.status.text.right, 'position');
		tmp2 = get(handles.status.text.right, 'extent');
		
		tmp(1) = (1 - 3*ww/tile) - tmp2(3);
		set(handles.status.text.right, 'position', tmp);

	end
	
end

%--
% position buttons
%--

% TODO: move this to a function

pos = get_size_in(handles.slider, 'pixels', 1);

button.bottom = pos.bottom - 3; button.height = pos.height + 6;

button.width = 1.5 * button.height; 

button.margin = 3;

pos.width = pos.width - 3 * button.width - 2 * button.margin - 5;

set_size_in(handles.slider, 'pixels', pos);

button.left = pos.left + pos.width + 5;

for k = 1:length(handles.zoom.all)
	
	set_size_in(handles.zoom.all(k), 'pixels', button);
	
	button.left = button.left + button.width + button.margin;
	
end

%--
% refresh figure
%--

refresh(par);


%-----------------------------------
% BROWSER_RESIZE_CALLBACK
%-----------------------------------

% NOTE: this is a trivial function handle callback wrapper for the resize

function browser_resize_callback(obj, eventdata)

browser_resizefcn(obj);


%-----------------------------------
% GET_BROWSER_HANDLES
%-----------------------------------

function handles = get_browser_handles(par, data)

% get_browser_handles - get resize relevant browser handles
% ---------------------------------------------------------
%
% handles = get_browser_handles(par, data)
% 
% Input:
% ------
%  par - browser
%
% Output:
% -------
%  handles - resize relevant handles struct

% TODO: document where the various tags used by this function are set

% NOTE: this handles problems while deleting figures

%--
% get data if needed
%--

if nargin < 2
	data = get_browser(par);
end

%--
% get display axes handles
%--

try
	handles.axes = data.browser.axes;
catch
	handles = []; return;
end

handles.support = findobj(par, 'type', 'axes', 'tag', 'support');

%--
% get control handles
%--

handles.slider = findobj(par, 'tag', 'BROWSER_TIME_SLIDER');

zoom.out = findobj(par, 'tag', 'BROWSER_ZOOM_OUT');

zoom.in = findobj(par, 'tag', 'BROWSER_ZOOM_IN');

zoom.sel = findobj(par, 'tag', 'BROWSER_ZOOM_SEL');

zoom.all = [zoom.out, zoom.in, zoom.sel];

handles.zoom = zoom;

%--
% get colorbar and statusbar handles
%--

% NOTE: colorbar tag is provided by MATLAB and could change

handles.colorbar = findobj(par, 'type', 'axes', 'tag', 'Colorbar');

status.bar = findobj(par, 'type', 'axes', 'tag', 'Status', 'visible', 'on');

if ~isempty(status.bar)
	
	status.text.left = findobj(status.bar, 'tag', 'Status_Text_Left');
	
	status.text.right = findobj(status.bar, 'tag', 'Status_Text_Right');
	
end

handles.status = status;


%-----------------------------------
% RESIZE_CONTROLS
%-----------------------------------

% NOTE: this will modify the slider position to accomodate the buttons

function resize_controls(handles)

