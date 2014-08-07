function env = get_linux_env

% get_linux_env - get linux environment variables
% -----------------------------------------------
%
% env = get_linux_env
%
% Output: 
% -------
%  env - environment variable struct

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

if ~strcmpi(computer, 'glnx86')
	error('This function is only available for Linux.');
end

%--
% get full env string
%--

% NOTE: we get env string and parse elements into cells

[status, result] = system('env'); 

env = parse_env(result);


%----------------
% PARSE_ENV
%----------------

% NOTE: we could further parse some of the fields for convenience

function env = parse_env(result)

env = struct;

lines = file_readlines(result); 

if isempty(lines{end})
	lines(end) = []; 
end

for k = 1:length(lines)
	
	[field, value] = strtok(lines{k}, '='); 
	
	field = lower(strrep(field, ' ', '_')); value = strtrim(value(2:end));
	
	if ~isvarname(field) 
		field = genvarname(field);
	end
	
	env.(field) = value;
	
end
