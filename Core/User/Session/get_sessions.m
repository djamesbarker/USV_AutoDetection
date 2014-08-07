function sessions = get_sessions(name, user)

% get_sessions - get user sessions
% --------------------------------
%
% sessions = get_sessions(name, user)
%
% Input:
% ------
%  name - session name
%  user - user 
%
% Output:
% -------
%  sessions - session files

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
% $Revision: 1869 $
% $Date: 2005-09-28 16:45:31 -0400 (Wed, 28 Sep 2005) $
%--------------------------------

%-------------------------------
% HANDLE INPUT
%-------------------------------

%--
% set default active user
%--

if (nargin < 2)
	user = get_active_user;
end 

%--
% set no name selection
%--

if (nargin < 1)
	name = '';
end

%-------------------------------
% GET SESSIONS
%-------------------------------

%--
% get user sessions root content
%--

% NOTE: it might be useful to have the structure output

content = what_ext(sessions_root(user), 'txt');

%--
% get all available session files
%--

if isempty(name)

	sessions = cell(0);
	
	for k = 1:length(content.txt)
		sessions{end + 1} = file_ext(content.txt{k});
	end

	% NOTE: output column vector

	sessions = sessions(:);
	
%--
% get session file from name
%--

else

	ix = find(strcmp(file_ext(content.txt), name));
	
	if isempty(ix)
		sessions = ''; return;
	end
	
	sessions = {name};
	
end
