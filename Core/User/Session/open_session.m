function par = open_session(varargin)

% open_session - open session browsers
% ------------------------------------
%
% par = open_session(name, user)
%
% Input:
% ------
%  session - session struct
%
% Output:
% -------
%  par - browser handles

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

% TODO: consider a different signature, perhaps same as load session. use varargin

%--
% load session
%--

% NOTE: this function handles the variable input

if isempty(varargin)
	session = load_session(varargin);
else
	session = load_session(varargin{:});
end

% NOTE: return if we can't find session

if isempty(session)
	par = []; return;
end

%--
% open session sounds
%--

par = [];

for k = 1:length(session.content)
	
	info = parse_browser_tag(session.content{k});
	
	lib = get_user_library(info.library);
	
	par(end + 1) = open_library_sound(info.sound, lib);
	
end
