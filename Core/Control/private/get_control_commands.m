function commands = get_control_commands

% get_control_commands - get list of available control commands
% -------------------------------------------------------------
%
% commands = get_control_commands 
%
% Output:
% -------
%  commands -  commands

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
% $Revision: 3297 $
% $Date: 2006-01-29 12:34:00 -0500 (Sun, 29 Jan 2006) $
%--------------------------------

%--
% create persistent list of commands if needed
%--

persistent UPDATE_COMMANDS;

if (isempty(UPDATE_COMMANDS))
	
	names = {'show','hide','enable','disable'};
	
	UPDATE_COMMANDS = strcat('__',upper(names),'__')';
	
end

%--
% return list
%--

commands = UPDATE_COMMANDS;
