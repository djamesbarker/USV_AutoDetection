function str = xbat_version(name)

% xbat_version - output XBAT version string
% -----------------------------------------
%
% str = xbat_version(name)
%
% Input:
% ------
%  name - version name
%  info - subversion info
%
% Output:
% -------
%  str - version string

% Copyright (C) 2002-2012 Cornell University


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
% $Revision: 6971 $
% $Date: 2006-10-09 15:34:23 -0400 (Mon, 09 Oct 2006) $
%--------------------------------

%-----------------------
% HANDLE INPUT
%-----------------------

copy = is_working_copy(xbat_root);

%--
% set default name
%--

% NOTE: if we are not a working copy, surely we are using the release

% TODO: consider subversion details, to handle a working copy of the release branch!

if nargin < 1
	if copy
		name = 'DEVEL';
	else
		name = 'R7';
	end
end

%-----------------------
% VERSION STRING
%-----------------------

%--
% get matlab version info
%--

rel = ver('matlab'); rel = rel.Version;

%--
% build version string
%--

% NOTE: this is used in figure titles and structure version fields

str = [name, '  (MATLAB ', rel, ')'];

%-----------------------
% SVN VERSION STRING
%-----------------------

%--
% check SVN info is relevant
%--

if ~copy % || isempty(tsvn_root)
	return;
end

%--
% get svn info
%--

info = get_svn_info(xbat_root);

if isempty(info) % || ~isfield(info, 'rev')
	return;
end

%--
% create string with svn info 
%--

str = ['SVN  ', upper(strrep(info.url, info.repository_root, '')), '  (', int2str(info.last_changed_rev), ')'];

% str = [name, '  (SVN ', int2str(info.rev), ')  (MATLAB ', rel, ')'];


