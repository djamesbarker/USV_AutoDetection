function show_palettes(obj,eventdata)

% show_palettes - show child figures

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

% TODO: change the name to something like 'show_children'

% TODO: to be used as a function handle callback replacement for the 'Show' case in 'browser_palettes'

%--
% check for double click
%--

front = double_click(h);

%--
% check for timers
%--

% NOTE: this is probably best handled through the timer's errorfcn 

if (isempty(timerfind('name','XBAT Palette Daemon')))
	start(palette_daemon);
end

% NOTE: this is no currently in use, consider using again

% 		if (isempty(timerfind('name','XBAT Palette Glue Daemon')))
% 			start(palette_glue_daemon);
% 		end

if (isempty(timerfind('name','XBAT Browser Daemon')))
	start(browser_daemon);
end

%--------------------------
% HIDE AND SHOW CODE
%--------------------------

% TODO: this functionality should be configurable globally

%--
% hide children of all other sound figures
%--

others = setdiff(get_xbat_figs('type','sound'),h);

for k = 1:length(others)
	set(get_xbat_figs('parent',others(k)),'visible','off');
end

% NOTE: also hide other sound windows, make this an option

% TODO: make this configuration option available to users

% NOTE: editing of preferences can be available from each of the
% sound windows even though they have a global effect, this is not
% unlike the way many web browsers and the operating systems
% behave

if (0) % NOTE: keep the most familiar behavior active for now

	set(others,'visible','off');

else

	for k = 1:length(others)
		if (strcmpi(get(others(k),'visible'),'off'))
			set(others(k),'visible','on');
		end
	end

end

%--
% show our chidren
%--

ch = get_xbat_figs('parent',h);

for k = 1:length(ch)

	%--
	% update visibility if needed
	%--

	if (strcmpi(get(ch(k),'visible'),'off'))
		set(ch(k),'visible','on');
	end

	%--
	% update focus (using double click event)
	%--

	if (front)
		figure(ch(k));
	else
		figure(h);
	end

end

% NOTE: this is cheap keep on always

if (strcmpi(get(h,'visible'),'off'))
	set(h,'visible','on');
end

%--
% output nothing
%--

out = [];
