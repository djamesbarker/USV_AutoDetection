function [result, context] = compute(log, parameter, context)

% STRIP - compute

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

result = [];

%--
% strip log events
%--

if parameter.all
	
	for k = 1:length(log.event)
		log.event(k).measurement = empty(measurement_create);
	end
	
else
	
	for k = 1:length(log.event)
		
		for j = length(log.event(k).measurement):-1:1
			
			if ~ismember(log.event(k).measurement(j).name, parameter.measures)
				continue;
			end
			
			log.event(k).measurement(j) = [];
			
		end
		
	end
	
end

%--
% save stripped log
%--

% NOTE: if we are modifying the input log file backup 

if parameter.inplace || isempty(parameter.suffix)
	log_backup(log);
else
	log.file = [file_ext(log.file), parameter.suffix, '.mat'];
end

log_save(log);




