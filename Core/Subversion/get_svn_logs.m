function logs = get_svn_logs(rev, file)

% get_svn_logs - get subversion log for interval
% ----------------------------------------------
%
% logs = get_svn_logs(rev, file)
%
% Input:
% ------
%  rev - revision range
%  file - file to consider
%
% Output:
% -------
%  logs - logs

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

% TODO: provide some display on no output

%-----------------
% SETUP 
%-----------------

logs = [];

%--
% get svn tool and info
%--

tool = svn;

if isempty(tool)
	return;
end

info = svn_info; 

if isempty(info) 
	return;
end 

%-----------------
% HANDLE INPUT
%-----------------

%--
% set all files default
%--

if nargin < 3
	file = '';
end

%--
% set and check revisions
%--

% NOTE: this is the default for the client when revision is empty

if ~nargin || isempty(rev) 
	rev = 'HEAD:1';
end

% NOTE: allow integers and integer sequences for convenience

if ~ischar(rev)
	
	if length(rev) > 1
		
		start = min(rev); stop = max(rev); 
		
		if stop > info.rev
			rev = [int2str(start), ':HEAD'];
		else
			rev = [int2str(start), ':', int2str(stop)];
		end
		
	else
		
		if rev > info.rev
			rev = 'HEAD';
		else
			rev = int2str(rev);
		end
		
	end
	
end

%-----------------
% GET LOGS
%-----------------

%--
% build command string 
%--

str = ['svn log -r', rev, ' "', info.url, '"'];

if ~isempty(file)
	str = [str,  '" ', file, '"'];
end

[status, result] = system(str);

% TODO: provide some error display

if status
	logs = []; return;
end

%--
% parse result into logs
%--

logs = parse_result(file_readlines(result));


%---------------------
% PARSE_RESULT
%---------------------

function logs = parse_result(result)

%--
% initialize logs
%--

logs.info = []; logs.message = {}; logs = empty(logs);

%--
% get logs from result
%--

k = 1;

while k < length(result)

	%--
	% skip empty lines
	%--
	
	if isempty(result{k})
		k = k + 1; continue;
	end
	
	%--
	% handle start of revision log
	%--
	
	if all(result{k} == '-')

		k = k + 1;

		if k > length(result)
			break;
		end

		try
			logs(end + 1).info = parse_info(result{k});
		catch
			logs(end + 1).info = result{k}; 
			nice_catch(lasterror, 'Failed to parse subversion log info line.');
		end

	%--
	% read revision log message lines
	%--
	
	else

		if ~isempty(result{k})
			logs(end).message{end + 1} = strtrim(result{k});
		end

	end
	
	%--
	% move to next line
	%--
	
	k = k + 1;

end


%---------------------
% PARSE_INFO
%---------------------

function info = parse_info(str)

%--
% get values from string
%--

value = strread(str, '%s', -1, 'delimiter', '|');

value = strtrim(value);

%--
% pack into struct
%--

fields = {'rev', 'author', 'date', 'lines'};

info = struct;

for k = 1:length(fields)
	info.(fields{k}) = value{k};
end

info.str = str;

%--
% parse fields intelligently
%--

info.rev = eval(info.rev(2:end));

% NOTE: we also create a couple of redundant date fields

ix = strfind(info.date, ' (');

if ~isempty(ix)
	info.week_date = info.date((ix + 2):end - 1);
end

ix = strfind(info.date, ' -');

if ~isempty(ix)
	info.short_date = info.date(1:(ix - 1));
end

info.lines = eval(strtok(info.lines, ' '));

	
	
	
