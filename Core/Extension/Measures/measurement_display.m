function measurement_display(par, m, ix, data)

% measurement_display - display measurement data in browser
% ---------------------------------------------------------
% 
% handles = measurement_display(par, m, ix, data)
%
% Input:
% ------
%  par - parent browser
%  m - log index
%  ix - event index
%  data - browser data (def: get_browser(par))
%
% Output:
% -------
%  error

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

% TODO: update display controls (and store) and allow for 'none', 'always
% on', and 'on selection' display

% NOTE: the goal of this function is to update the display for a single
% event

%---------------------------
% HANDLE INPUT
%---------------------------

%--
% skip active detection log
%--

% NOTE: active detections currently have no measures

if ischar(m) || isempty(m)
	return;
end

%--
% get browser state if needed
%--

if nargin < 4 || isempty(data)
	data = get_browser(par);
end

%--
% get display measurements
%--

view = data.browser.measurement.view;

if isempty(view)
	return;
end

%---------------------------
% DISPLAY MEASUREMENTS
%---------------------------

event = data.browser.log(m).event(ix); 

%--
% loop over event measurements
%--

for j = 1:length(event.measurement)

	%--
	% check if we are being displayed
	%--
	
	if ~ismember(event.measurement(j).name, view)
		continue;
	end
	
	%--
	% display measurement
	%--
	
	fun = event.measurement(j).fun; tag = [int2str(m) '.' int2str(ix)];

	try
		handles = fun('display', par, m, ix, data); set(handles, 'tag', tag);
	catch
		nice_catch(lasterror, 'measurement display failed'); 
	end
				
end

