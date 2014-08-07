function tool = get_svn(local)

% get_svn - get svn tool, from network if needed
% ----------------------------------------------
%
% tool = get_svn
%
% Output:
% -------
%  tool - svn tool

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
% get tool in linux
%--

if ~ispc
	tool = get_tool('svn'); return;
end

%--
% get tool for PC
%--

% NOTE: if we set the local flag, we force the use of a local version of subversion

if ~nargin
	local = 0;
end 

% NOTE: we use the system version if available and no local request

if ~local

	tool = get_windows_svn;

	if ~isempty(tool)
		return;
	end
	
end

tool = get_tool('svn.exe'); 

% NOTE: this unravels a possible recursive call to 'get_curl'

get_curl;

if isempty(tool) && install_tool('Subversion')

	tool = get_tool('svn.exe');
	
end


