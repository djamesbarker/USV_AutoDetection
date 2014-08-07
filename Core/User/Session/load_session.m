function session = load_session(name, user)

% load_session - load user session
% --------------------------------
%
% session = load_session(name, user)
%
% Input:
% ------
%  name - session name
%  user - user 
%
% Output:
% -------
%  session - session name and content

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

%-------------------------------
% HANDLE INPUT
%-------------------------------

ext = '.txt';

%--
% set default active user
%--

if (nargin < 2)
	user = get_active_user;
end 

%--
% select most recent session
%--

% NOTE: consider factoring most session files and recent file code

if (nargin < 1) || isempty(name)
	
	%--
	% get user sessions
	%--
	
	sessions = get_sessions('', user);
	
	if isempty(sessions)
		session = []; return;
	end
	
	%--
	% select most recently modified session file
	%--
	
	for k = 1:length(sessions)
		info(k) = dir([sessions_root(user), filesep, sessions{k}, ext]);
	end
	
	modified = datenum({info.date}');
	
	[ignore, ix] = max(modified);
	
	%--
	% get name and file
	%--
	
	name = info(ix).name;
	
	in = sessions(ix);
	
%--
% get session file from name
%--

else
	
	in = get_sessions(name, user);
	
end

%--
% return if there is no session to load
%--

if isempty(in) || isempty(in{1})
	session = []; return;
end

%-------------------------------
% LOAD SESSION
%-------------------------------

%--
% create session struct
%--

session.user = user.name;

% NOTE: the name is stored in the filename, a similar pattern could be used elsewhere

session.name = name;

in = [sessions_root(user), filesep, in{1}, ext];

opt = file_readlines; opt.comment = '%'; opt.skip = 1;

session.content = file_readlines(in, [], opt);
