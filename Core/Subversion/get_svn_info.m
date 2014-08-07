function info = get_svn_info(file)

% get_svn_info - get svn info for file or directory
% -------------------------------------------------
%
% info = get_svn_info(file)
% 
% Input:
% ------
%  file - file or directory
%
% Output:
% -------
%  info - info

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

%-------------------
% HANDLE INPUT
%-------------------

%--
% set default file
%--

if ~nargin
	file = pwd;
end

% NOTE: we try to get a full filename for files in the MATLAB path, better info path output

if ~exist(file, 'dir') && ~isempty(which(file))
	file = which(file);
end

%-------------------
% GET INFO
%-------------------

% TODO: make sure this handles unavailable 'svn' and non-versioned controlled files

[status, result] = svn('info', file);

info = parse_svn_info(result);


%-------------------------
% PARSE_SVN_INFO
%-------------------------

function info = parse_svn_info(result)

info = struct;

lines = file_readlines(result); 

if isempty(lines{end})
	lines(end) = []; 
end

for k = 1:length(lines)
	
	[field, value] = strtok(lines{k}, ':'); 
	
	field = lower(strrep(field, ' ', '_')); value = strtrim(value(2:end));
	
	if ~isvarname(field) 
		field = genvarname(field);
	end
	
	try
		info.(field) = eval(value);
	catch
		info.(field) = value;
	end
	
end
