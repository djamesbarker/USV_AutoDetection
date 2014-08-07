function name = event_name(event, log)

% event_name - get event name
% ---------------------------
%
% name = event_name(event, log)
%
% Input:
% ------
%  event - event
%  log - log name
%
% Output:
% -------
%  name - event name

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

%------------------------
% HANDLE INPUT
%------------------------

%--
% set default prefix
%--

if nargin < 2
	log = 'Event';
end

%--
% handle multiple events recursively
%--

if numel(event) > 1
	
	for k = 1:numel(event)
		name{k} = event_name(event(k), log);
	end
	
	return;
	
end

%------------------------
% GET NAME
%------------------------

name = [log, ' # ', int2str(event.id)];
