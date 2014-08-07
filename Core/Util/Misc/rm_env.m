function rm_env(name,flag)

% rm_env - remove environment variable
% ------------------------------------
%
% rm_env(name,flag)
%
% Input:
% ------
%  name - variable name
%  flag - display flag (def: 0)

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

% TODO: update the environment variable framework to use application data

%--
% set display flag
%--

if ((nargin < 2) | isempty(flag))
	flag = 1;
end

%--
% get root userdata
%--

data = get(0,'userdata');

%--
% check for existence of environment variable
%--

if (~isfield(data,'env'))
	
	%--
	% report non-existent environment variable structure
	%--
	
	disp(' ');
	warning('There is no environment variable structure available.');
	
	return;
	
end

%--
% check for variable to delete
%--

if (isfield(data.env,name))
	
	%--
	% remove variable and update root userdata
	%--
	
	data.env = rmfield(data.env,name);
	
	set(0,'userdata',data);
	
	%--
	% report removal of variable
	%--
	
	if (flag)
		disp(' ');
		warning(['Environment variable ''' name ''' removed.']);
		disp(' ');
	end
	
else

	%--
	% report missing variable
	%--
	
	if (flag)
		disp(' ');
		warning(['Environment variable ''' name ''' does not currently exist.']);
		disp(' ');
	end
	
end
	
