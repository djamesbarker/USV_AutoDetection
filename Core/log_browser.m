function g = log_browser(h,log,ix,dil,row,col)

% log_browser - browse log along with sound browser parent
% --------------------------------------------------------
%
% g = log_browser(h,log,ix,dil,row,col)
%
% Input:
% ------
%  h - parent figure
%  log - name of log to browse
%  ix - starting event index
%  dil - dilation of event duration for display
%  row - number of rows per page
%  col - number of columns per page
%
% Output:
% -------
%  g - log browser figure handle

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
% $Date: 2005-02-17 23:49:03 -0500 (Thu, 17 Feb 2005) $
% $Revision: 550 $
%--------------------------------

% NOTE: this code needs MAJOR UPDATING, however this should not be too hard

%--
% set default values for event dilation, rows and columns, and starting index
%--

if nargin < 5 || isempty(col)
	col = 4;
end

if nargin < 5 || isempty(row)
	row = 2;
end

if nargin < 4 || isempty(dil)
	dil = 2;
end

if nargin < 3 || isempty(ix)
	ix = 1;
end

%--
% create figure and get browser structure from parent
%--

g = figure;

data = get(h,'userdata');

data.browser.parent = h;
data.browser.children = [];

data.browser.axes = [];
data.browser.images = [];
data.browser.slider = [];

data.browser.log = log;
data.browser.index = ix;
data.browser.row = row;
data.browser.column  = col;
data.browser.dilation = dil;

set(g,'userdata',data);

%--
% set display related figure properties
%--

set(g,'doublebuffer','on');

set(g,'numbertitle','off');

set(g,'tag','XBAT_LOG_BROWSER');

tmp = get(h,'name');
[tmp,snd] = strtok(tmp,'-');
snd = snd(4:end);

set(g,'name',[' XBAT Log  -  ' log '  (' snd ')']);

%--
% create log browser display
%--

[ax,im,sli] = log_browser_display('create',log,ix,dil,row,col);

%--
% update log browser userdata
%--

data = get(g,'userdata'); 

data.browser.axes = ax;
data.browser.images = im;
data.browser.slider = sli;

data.browser.log = log;
data.browser.index = ix;
data.browser.row = row;
data.browser.column  = col;
data.browser.dilation = dil;

set(g,'userdata',data);

%--
% update sound browser parent userdata
%--

data = get(h,'userdata');

n = length(data.browser.children);
data.browser.children(n + 1) = g;

set(h,'userdata',data);

%--
% setup interface
%--

log_file_menu(g);

% log_view_menu(g);

log_edit_menu(g);
% 
% log_sound_menu(g);
% 
% log_log_menu(g);

% log_select_menu(g);

% log_annotate_menu(g);

% log_measure_menu(g);

browser_window_menu(g);

% log_help_menu;

%--
% key bindings to menu commands
%--

log_kpfun(g);

%--
% resize function to produce desirable resizing behavior
%--

log_resizefcn(g);
 
%--
% ensure window is not accidentaly closed (does not protect from delete)
%--
% 
% set(g,'closerequestfcn','log_file_menu(gcf,''Close'')');

%--
% set parent workaround 
%--

data = get(g,'userdata');
data.browser.parent = h;
set(g,'userdata',data);
