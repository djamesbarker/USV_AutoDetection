function  view = browser_view_update(par,data)

% browser_view_update - update view state array upon change of state
% ------------------------------------------------------------------
%
% view = browser_view_update(par,data)
% 
% Input:
% ------
%  par - parent handle
%  data - parent userdata (to get view from)
%
% Output:
% -------
%  view - updated view state array

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
% $Revision: 1674 $
% $Date: 2005-08-25 10:08:51 -0400 (Thu, 25 Aug 2005) $
%--------------------------------

%----------------------------------------------
% HANDLE INPUT
%----------------------------------------------

%--
% get parent userdata if needed
%--

% TODO: replace this with a proper get

if (nargin < 2)
	data = get(par,'userdata');
end

%----------------------------------------------
% UPDATE VIEW
%----------------------------------------------

%--
% get view state array
%--

view = data.browser.view;

%--
% collect view state variables
%--

% NOTE: this should be a function and could contain other aspects of view

state.time = data.browser.time;

state.page = data.browser.page;

state.channels = data.browser.channels;

state.play.channel = data.browser.play.channel;

state.specgram = data.browser.specgram;

%--
% update the view state
%--

pre = view.length - view.position;

%--
% the view is the last view, append to view array
%--

if (pre == 0)
	
	%--
	% check that we have not exceeded the maximum view length
	%--
	
	if (view.length < view.max)
		
		tmp = view.position + 1;
		
		view.state(tmp) = state;
		
		view.position = tmp;
		
		view.length = tmp;
		
	else
		
		view.state(1:(end - 1)) = view.state(2:end);
		
		view.state(end) = state;
		
	end
	
%--
% the view is not the last view, fold the previous view views 
%--

else
	
	%--
	% fold next views into past checking
	%--
	
	pos = view.position;
	
	view.state = [view.state(1:view.length), fliplr(view.state(pos:(pos + pre - 1))), state];
	
	tmp = length(view.state);
	
	view.position = tmp;
	
	view.length = tmp;
	
	%--
	% truncate views array to maximum length
	%--
	
	if (length(view.state) > view.max)
		
		tmp = view.max;
		
		view.state = view.state((end - tmp + 1):end);
		
		view.position = tmp;
		
		view.length = tmp;
	
	end
	
end

%--
% update state of view navigation menus
%--

tmp = data.browser.view_menu.page;

set(get_menu(tmp,'Next View'),'enable','off'); 

set(get_menu(tmp,'Previous View'),'enable','on');


tmp = findall(get(data.browser.slider,'uicontextmenu'));

set(get_menu(tmp,'Next View'),'enable','off'); 

set(get_menu(tmp,'Previous View'),'enable','on');

%--
% update navigation controls
%--

control_update(par,'Navigate','Next View','__DISABLE__',data);

control_update(par,'Navigate','Previous View','__ENABLE__',data);

tmp = control_update(par,'Navigate','View',[],data);

sli = findobj(tmp,'style','slider');

set(sli, ...
	'max',view.length,'value',view.position ...
);

tmp = control_update(par,'Navigate','View',view.position,data);

%--
% update controls related to view change
%--

% page display controls

% spectrogram controls

% navigation controls
