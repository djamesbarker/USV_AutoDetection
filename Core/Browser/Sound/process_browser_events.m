function info = process_browser_events(par, ext, m, ix)

% process_browser_events - process events in browser
% --------------------------------------------------
%
% process_browser_events(par, ext, m, ix)
%
% Input:
% ------
%  par - browser
%  ext - extension
%  m - log store index 
%  ix - event store indices
%
% Output:
% -------
%  info - computation info

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

%-------------------------
% HANDLE INPUT
%-------------------------

if ~is_browser(par)
	error('Input handle is not browser handle.');
end

%-------------------------
% PROCESS
%-------------------------

% NOTE: this is an archaic and very dangerous API

%--
% process browser events and collect some profiling info
%--

t0 = clock;

try

	feval(ext.fun, 'events', par, m, ix);

	info.events = length(ix);

catch
	
	disp(['unable to compute ', ext.name]);
	
	disp(lasterr);
	
end
	
info.elapsed = etime(clock, t0);




