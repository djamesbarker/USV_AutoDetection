function updated = widget_update(par, widget, event, data, layout)

% widget_update - update widget on event
% --------------------------------------
%
% updated = widget_update(par, widget, event, data)
%
% Input:
% ------
%  par - parent handle
%  widget - widget handle
%  event - event name
%  data - event data
%
% Output:
% -------
%  updated - update indicator

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

% TODO: implement handling of large pages, this should affect the API

%-----------------------
% HANDLE INPUT
%-----------------------

% NOTE: at this point we have not updated

updated = 0;

%--
% set no layout default
%--

if nargin < 5
	layout = 0;
end

%--
% get widget state and context
%--

[ext, context] = get_widget_extension(widget); 

%-----------------------
% UPDATE WIDGET
%-----------------------

%--
% layout widget
%--

if layout && ~isempty(ext.fun.layout)
	try
		ext.fun.layout(widget, ext.parameter, context);
	catch
		extension_warning(ext, 'Widget layout failed.', lasterror);
	end
end

%--
% get event handler
%--

fun = get_field(ext.fun.on, event); 

% NOTE: return if we don't know how to listen

if isempty(fun)
	return;
end

%--
% get widget data if needed
%--

% NOTE: the widget data is uniform for events

if (nargin < 4) || isempty(data)
	data = get_widget_data(par, event);
end

% NOTE: return if there is no widget data

if isempty(data)
	return;
end

%--
% perform widget event callback
%--

% NOTE: the widget callback does not need the parent directly

try
	fun(widget, data, ext.parameter, context); updated = 1;
catch
	extension_warning(ext, ['Widget ''', event, ''' update failed.'], lasterror);
end

