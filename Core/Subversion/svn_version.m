function [version, exported, info] = svn_version(file)

% svn_version - get svn version string
% ------------------------------------
%
% [version, exported, info] = svn_version(file)
%
% Input:
% ------
%  file - file or directory
%
% Output:
% -------
%  version - string
%  exported - exported test, directory is not a working copy
%  info - svn info

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
% set default file
%--

if nargin < 1
	file = pwd;
end 

%--
% get exported state and version string from info
%--

info = get_svn_info(file);

exported = isempty(info) || isfield(info, 'svn') || (length(fieldnames(info)) < 2);

if exported
	version = ''; 
else
	version = int2str(info.revision);
end

