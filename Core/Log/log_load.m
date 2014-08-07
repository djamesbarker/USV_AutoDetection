function log = log_load(in)

% log_load - load log structures from files
% -----------------------------------------
%
% log = log_load(in)
%
% Input:
% ------
%  in - input file(s)
%
% Output:
% -------
%  log - log structure(s)

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

%-------------------------------------------
% HANDLE INPUT
%-------------------------------------------

%--
% get log files interactively
%--

if (nargin < 1)
	
	%--
	% get log files
	%--
	
	% NOTE: try to start at current library location
	
	init = pwd;
	
	try
		lib = get_active_library; cd(lib.path);
	end

	filter = { ...
		'*.mat','MAT-files (*.mat)'; ...
		'*.*', 'All Files (*.*)' ...
	};
	
	[f,p] = uigetfile2(filter,'Select Log File(s):','multiselect','on');
	
	cd(init);
		
	% NOTE: return empty on cancel
	
	if (isempty(p))
		log = []; return;
	end
	
	%--
	% put file names together
	%--

	if iscell(f)
		for k = 1:length(f)
			in{k} = [p, f{k}];
		end
	else
		in = [p, f];
	end
	
end

%--
% handle multiple log files recursively
%--

if iscell(in)
	
	% TODO: add some fault tolerance here

	for k = 1:length(in)
		log(k) = log_load(in{k});
	end
	
	return;
	
end

%-------------------------------------------
% LOAD LOG
%-------------------------------------------

% TODO: consider incremental loading of logs, also move to sqlite

%--
% inspect mat file to see if we are working with a log file
%--

% TODO: develop 'islog' that inspects file contents

if ~exist(in, 'file')
	log = []; return;
end

% TODO: ask the filesystem for the log size, display a message for large?

try
	content = load(in);
catch
	disp(['Failed to load log file "', in, '".']); log = []; return;
end
	
% NOTE: we get log variable name here

names = fieldnames(content);

ix = union(strmatch('Log_', names), strmatch('log', names));

if length(ix) ~= 1
	
	error_dialog( ...
		['The file "', in, '" is not an XBAT log.'], ...
		'Failed to load log file', ...
		'modal' ...
	); 

	log = []; return;
	
end

name = names{ix};

%--
% load log from file
%--

log = content.(name);
