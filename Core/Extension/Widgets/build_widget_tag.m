function tag = build_widget_tag(par, ext)

% build_widget_tag - build tag for widget figure
% ----------------------------------------------
%
% tag = build_widget_tag(par, ext)
%
% Input:
% ------
%  par - parent browser
%  ext - widget extension
%
% Output:
% -------
%  tag - widget figure tag

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

%---------------------
% HANDLE INPUT
%---------------------

%--
% check for browser and get info
%--

[proper, info] = is_browser(par);

if ~proper
	error('Input handle is not browser handle.');
end

%---------------------
% BUILD TAG
%---------------------

%--
% build tag with common information
%--

header = 'XBAT_WIDGET'; type = 'WIDGET'; sep = '::';

% NOTE: we match user, library, and sound, change type and add widget name

tag = [header, sep, type, sep, ext.name, sep, info.user, sep, info.library, sep, info.sound, sep, get_listen(ext)];


%-------------------------------------
% GET_LISTEN
%-------------------------------------

function listen = get_listen(ext)

%--
% get events and initialize listen
%--

event = get_widget_events; listen = '';

%--
% test if we know how to listen to each event
%--

for k = 1:length(event)
	
	% NOTE: this is effectively a 'collapse' on a string not a struct
	
	fun = eval(['ext.fun.on.', strrep(event{k}, '__', '.')]);
	
	if isempty(fun)
		listen(end + 1) = '0';
	else
		listen(end + 1) = '1';
	end
	
end


