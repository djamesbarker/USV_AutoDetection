function [parameter, context] = parameter__compile(parameter, context)

% WHITENING - parameter__compile

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
% try to get the noise log from parameters
%--

log_name = parameter.noise_log;

if isempty(log_name)
	return;
end

if iscell(log_name)
	log_name = log_name{1};
end

[ignore, log_name] = fileparts(log_name);

%--
% get the actual log
%--

log = get_library_logs('logs', context.library, context.sound, log_name);

parameter.h = estimate_log_noise(log, parameter, context);
