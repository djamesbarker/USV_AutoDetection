function set_time_grid(ax,opt,t,realtime,sound,max_ticks)

% set_time_grid - set time grid for signal display axes
% -----------------------------------------------------
% 
% set_time_grid(ax,opt,t,realtime,time_stamps)
%
% Input:
% ------
%  ax - axes to set
%  opt - grid options
%  t - time limits (in seconds)
%  realtime - real time offsets

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
% $Revision: 819 $
% $Date: 2005-03-27 15:06:08 -0500 (Sun, 27 Mar 2005) $
%--------------------------------

%--------------------------------------------------------
% HANDLE INPUT
%--------------------------------------------------------

%--
% set default maximum number of ticks
%--

if (nargin < 6)
	max_ticks = 50;
end

%--
% set default realtime
%--

if (nargin < 4)
	realtime = [];
end

% NOTE: this is to handle a missing real time

if (isempty(realtime) && strcmp(opt.time.labels,'date and time'))
	opt.time.labels = 'clock'; 
end

%--
% get and check time limits if needed
%--

if ((nargin < 3) || isempty(t))
	
	%--
	% get time limits
	%--

	t = get(ax(1),'xlim');

	%--
	% check that axes have same time limits if needed
	%--

	if (length(ax) > 1)

		for k = 2:length(ax)
			
			if (~isequal(t,get(ax(k),'xlim')))
				error('Input axes must have shared ''xlim'' property.');
			end 
			
		end

	end
	
end

%--------------------------------------------------------
% SET TIME GRID SPACING
%--------------------------------------------------------

if (~isempty(opt.time.spacing))

	%--
	% specified spacing
	%--
	
	n = t / opt.time.spacing;
	
	% NOTE: this ensures an anchored grid
	
	startix = floor(n(1)); stopix = ceil(n(2));
	
	ntix = stopix - startix;
	
	%--
	% optionally decimate index vector according to the max_ticks parameter
	%--
	
	if ( ntix < max_ticks ) 
		inc = 1;
	else
		inc = floor(ntix / max_ticks ); 
	end
	
	%--
	% compute tick locations and set ticks in axes
	%--
	
	ix = (startix:inc:stopix) * opt.time.spacing;

	set(ax,'xtick',ix);	

else

	%--
	% automatic spacing
	%--

	ix = get(ax(end),'xtick');

end

% NOTE: times are in slider time, we want them in real time

ix = map_time(sound, 'real', 'slider', ix);

%--------------------------------------------------------
% SET TIME LABELS
%--------------------------------------------------------

switch (opt.time.labels)

	%--
	% Seconds
	%--
	
	case ('seconds')

		%--
		% compute labels
		%--

		labels = cell(length(ix), 1);
		
		for k = 1:length(ix)
			labels{k} = num2str(ix(k));
		end
		
		str = decimate_labels(labels); % decimate labels to reduce clutter
		
		set(ax(end),'xticklabel',str);

		%--
		% clear date from title
		%--

		set(get(ax(1),'title'),'string','');
		
	%--
	% Clock
	%--

	case ('clock')

		%--
		% convert xticklabels to clock notation
		%--

		str = decimate_labels(sec_to_clock(ix)); % decimate labels to reduce clutter
	
		set(ax(end),'xticklabel',str);
		
		%--
		% clear date from title
		%--

		set(get(ax(1),'title'),'string','');
		
	%--
	% Date and Time
	%--

	case ('date and time')

		%--
		% compute time offset using sound realtime
		%--
		
		date = datevec(realtime);
		
		time = ix + date(4:6)*[3600,60,1]';

		%--
		% convert offset xticklabels to clock notation
		%--

		str = decimate_labels(sec_to_clock(mod(time, 86400))); % decimate labels to reduce clutter
		
		set(ax(end),'xticklabel',str);

		%--
		% display date on top of display
		%--
		
		g = get(ax(1),'title');
		
		%--
		% display page start date
		%--
		
		date = datevec(datenum(date) + ix(1)/86400);
		
		str = datestr(date, 1);
		
		set(g, ...
			'string',str, ...
			'color',opt.color ...
		);

end

% NOTE: we should be able to skip these on update

%--------------------------------------------------------
% SET TIME GRID DISPLAY
%--------------------------------------------------------

% FIXME: there are problems displaying this in the selection zoom

if (opt.on && opt.time.on)
	set(ax,'xgrid','on');
else
	set(ax,'xgrid','off');
end

%--------------------------------------------------------
% SET TIME GRID COLOR
%--------------------------------------------------------

set(ax,'xcolor',opt.color);
