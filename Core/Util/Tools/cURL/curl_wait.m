function value = curl_wait(file)

% curl_wait - indicate that curl is currently waiting on a file
% -------------------------------------------------------------
%
% value = curl_wait(file)
%
% Input:
% ------
%  file - file
%
% Output:
% -------
%  value - wait indicator

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

value = 0;

%--
% check for daemon
%--

daemon = curl_daemon;

if isempty(daemon)
	return;
end

%--
% check if daemon is considering file
%--

timerfcn = get(daemon, 'timerfcn');

if ~iscell(timerfcn) || (length(timerfcn) < 2)
	return;
end

listens = timerfcn{2};

value = ismember(file, {listens.file.name});

