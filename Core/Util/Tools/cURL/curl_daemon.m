function daemon = curl_daemon(file, pal)

% curl_daemon - get and update curl daemon
% ----------------------------------------
%
% daemon = curl_daemon(file, pal)
%
% Input:
% ------
%  file -
%  pal - 
%
% Output:
% -------
%  daemon - timer

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

% TODO: evolve to handle different type of 'curl' calls

%--
% get or create singleton timer
%--

name = 'curl-daemon';

daemon = timerfind('name', name);

if isempty(daemon)
	
	% NOTE: in this case a daemon does not exist and cannot be created
	
	if ~nargin
		return;
	end
	
	% NOTE: in this case we create a daemon to wait on our file
	
	listen.file = file; listen.pal = pal;
	
	daemon = timer( ...
		'name', name, ...
		'timerfcn', {@curl_timerfcn, listen}, ...
		'period', 0.1, ...
		'executionmode', 'fixeddelay' ...
	); 

	start(daemon); 
	
	return;

end

if ~nargin
	return;
end

%--
% update subscribed handles
%--

% NOTE: we should factor this operation

timerfcn = get(daemon, 'timerfcn');

listen.file = file; listen.pal = pal;

listens = timerfcn{2}; listens(end + 1) = listen; timerfcn{2} = listens;

set(daemon, 'timerfcn', timerfcn);

%--
% start daemon if needed
%--

if ~strcmp(get(daemon, 'running'), 'on')
	start(daemon);
end


%------------------------------
% CURL_TIMERFCN
%------------------------------

function curl_timerfcn(obj, eventdata, listens)

%--
% update waitbars, checking if they are still there
%--

update = 0;

for k = length(listens):-1:1
	
	if ~ishandle(listens(k).pal)
		listens(k) = []; update = 1; continue;
	end
	
	curl_waitbar(listens(k).file, listens(k).pal);
	
end

if ~update
	return;
end

%--
% stop and delete if there are no waitbars
%--

if isempty(listens)
	stop(obj); delete(obj); return;
end

%--
% update timer with updated waitbar information
%--

timerfcn = get(obj, 'timerfcn'); 

if iscell(timerfcn)
	timerfcn{2} = listens; set(obj, 'timerfcn', timerfcn);
end


%------------------------------
% CURL_WAITBAR
%------------------------------



