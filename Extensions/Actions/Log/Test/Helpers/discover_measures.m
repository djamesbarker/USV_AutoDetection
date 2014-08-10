function measures = discover_measures(target, lib)

% discover_measures - get measure names from target log
% -----------------------------------------------------
%
% measures = discover_measures(target, lib)
%
% Input:
% ------
%  target - target list
%  lib - parent library
%
% Output:
% -------
%  measures - encountered measures

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
% handle input
%--

% NOTE: we typically rely on the active library

if nargin < 2
	lib = get_active_library;
end

%--
% get log files from target names
%--

for k = 1:length(target)
	target{k} = [lib.path, strrep(target{k}, filesep, [filesep, 'Logs', filesep]), '.mat'];
end

%--
% discover measures in target files
%--

measures = {};

for k = 1:length(target)
	
	%--
	% load target log
	%--
	
	% NOTE: this is the costly step in this computation
	
	log = log_load(target{k});
	
	%--
	% get available measure names from events
	%--
	
	for j = 1:length(log.event)
		measures = union(measures, {log.event(j).measurement.name});
	end
	
end

% NOTE: this removes the empty measure name

for k = length(measures):-1:1
	
	if isempty(measures{k})
		measures(k) = [];
	end

end
