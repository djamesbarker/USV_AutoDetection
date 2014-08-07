function out = rank_log(in)

% rank_log - rank logs created by data template detector
% ------------------------------------------------------
%
% out = rank_log(in)
%
% Input:
% ------
%  in - log file locations
%
% Output:
% -------
%  out - output files (empty if no file was created)

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

% TODO:
% -----
% - rename log, handle multiple instances of ranking ???
% - add annotation including correlation value
% - add waitbar for handling multiple log files
% - improve starting location for log file search


%--------------------------------------
% LOAD LOGS
%--------------------------------------

%--
% load logs
%--

if (nargin < 1)
	
	log = load_log;
	
else
	
	if (~ischar(in) && ~iscell(in))
		disp(' ');
		error('Input must be a file or lost of files as character or cell array.');
		out = []; return;
	end
	
	log = load_log(in);
	
end
	
%--------------------------------------
% HANDLE MULTIPLE LOGS RECURSIVELY
%--------------------------------------

if (length(log) > 1)
	
	for k = 1:length(log)
		out(k) = rank_log(log(k));
	end 
	
	return;
	
end

%--------------------------------------
% RANK LOGS
%--------------------------------------

%--
% empty or single event logs are not ranked
%--

if (log.length < 2)
	out = ''; return;
end

%--
% check log generation information
%--

if (length(log.generation) > 1)
	
	disp(' ');
	disp('WARNING: log contains results of multiple detector runs.');
	
	out = ''; return;
	
end

if (~strcmp(log.generation.preset.extension,'Data Template'))
	
	disp(' ');
	disp('WARNING: log was not generated using ''Data Template'' detector.');
	
	out = ''; return;
	
end

%--
% remove events with no detection value information
%--

for k = length(log.event):-1:1
	if (isempty(log.event(k).detection.value)
		log.event(k) = [];
	end
end

%--
% get correlation values
%--

for k = 1:length(log.event)
	corr(k) = log.event(k).detection.value.corr;
end

%--
% reset event id values as rank
%--

[ignore,ix] = sort(corr(:),1,'descend');

for k = 1:length(log.event)
	log.event(k).id = 
end

