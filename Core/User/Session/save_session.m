function [info, file] = save_session(name, user)

% save_session - save user session
% --------------------------------
% 
% [info, file] = save_session(name, user)
%
% Input:
% ------
%  name - session name
%
% Output:
% -------
%  info - session file info
%  file - session file

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
% set session extension
%--

ext = 'txt';

%----------------------
% HANDLE INPUT
%----------------------

%--
% set default user
%--

if (nargin < 2)
	user = get_active_user;
end

%--
% set default session name
%--

% NOTE: consider using dates for session names

if (nargin < 1)
	name = 'last_session';
end

if ~proper_filename(name)
	error('Session name must be a proper filename.');
end

%----------------------
% SAVE SESSION
%----------------------

%--
% capture session content
%--

content = capture_session;

%--
% write session file and get file info
%--

file = [sessions_root(user), filesep, name, '.', ext];

try
	info = file_writelines(file, content);
catch
	info = [];
end

%--
% display session info
%--

if ~nargout && ~isempty(info)
	
	disp(' '); disp(info.name); str_line(info.name);
	
	for k = 1:length(content)
		disp(content{k});
	end

	disp(' ');
	
end
