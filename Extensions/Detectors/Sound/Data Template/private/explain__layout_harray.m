function handles = explain__layout(par, parameter, context)

% DATA TEMPLATE - explain__layout

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
% create explain axes layout
%--

% TODO: eventually move to 'harray'

layout = layout_create(2, 2);

layout.col.frac = [0.9 0.1];

base = layout_create(0, 0); base.color.on = 0; base.status.on = 0; base.tool.on = 0;

array = harray(base, layout, par);

handles = [array.axes];


%--
% set axes limits and grid
%--

start = context.scan.start(1); stop = context.scan.stop(end); time = [start, stop];

set(handles, ...
	'box', 'on'...
);

set(handles([2,3]), ...
	'xlim', time ...
);

set(handles([2:end]), ...
	'ylim', [-0.1, 1.1] ...
);

set(handles(2), ...
	'xticklabel',[] ...
);

set(handles([4 5]), ...
	'yticklabel', [] ...
);

set_time_grid(handles([2,3]), context.grid, time, context.sound.realtime, context.sound);

%--
% tag and position axes
%--

% NOTE: tag display axes with channel number

nch = (length(handles)-1)/2;

for k = 2:(2+nch-1)
	
	set(handles(k), ...
		'tag', int2str(context.channels(k-1)) ...
	);

end

for k = (2+nch):length(handles)
	set(handles(k), ...
		'tag', ['dist_' int2str(k-(1+nch))] ...
	);
end

%--
% set resize function
%--

% set(par, 'resizefcn', @explain_resize);


%------------------------------------------------------------------------
% EXPLAIN_RESIZE
%------------------------------------------------------------------------

% NOTE: some tools should be created to provide users a uniform explain display

function explain_resize(obj,eventdata)

% explain_resize - resize function for explain figure
% ---------------------------------------------------
%
% explain_resize(obj,eventdata)
%
% Input:
% ------
%  obj - callback object
%  eventdata - not currently used

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

% NOTE: this may not be needed in the latest version of matlab

%--
% get axes handles
%--

data = get(findobj(obj,'type','axes','tag','support'),'userdata');

%--
% get figure size
%--

% positions are expressed as [left, bottom, width, height]

tmp = get(obj,'position');

w = tmp(3);

h = tmp(4);

%--
% set axes array options
%--

% the size in pixels of the margins is set here

opt = axes_array;

opt.top = 48 / h;

opt.right = 48 / w;

opt.bottom = 64 / h;

opt.left = 64 / w;

%--
% recompute axes positions
%--

pos = axes_array(data.row,data.col,opt);

%--
% update positions
%--

for k = 1:(data.row * data.col)
	set(data.child(k),'position',pos{k});
end


