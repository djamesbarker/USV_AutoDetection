function value = get_env(name, flag)

% get_env - get value of environment variable
% -------------------------------------------
%
% value = get_env(name, flag)
%
% Input:
% ------
%  name - variable name
%  flag - display flag (def: 0)
%
% Output:
% -------
%  value - variable value

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
% $Revision: 6971 $
% $Date: 2006-10-09 15:34:23 -0400 (Mon, 09 Oct 2006) $
%--------------------------------

% TODO: update the environment variable framework to use application data

%--
% set display flag
%--

if (nargin < 2) || isempty(flag)
	flag = 0;
end

%--
% get root userdata
%--

data = get(0, 'userdata');

%--
% return empty if we can't find environment variable
%--

if ~isfield(data, 'env')

	value = [];

	if flag
		disp('There is no environment variable structure available.');
	end

	return;
	
end

%--
% display named variable or existing environment variables
%--

if nargin && ~isempty(name)

	%--
	% return empty if we can't find named environment variable
	%--

	if ~isfield(data.env, name)
		
		value = [];

		if flag
			disp(['Environment variable ''' name ''' is not currently defined.']);
		end
		
		return;
		
	end
	
	%--
	% output value of environment variable
	%--

	value = data.env.(name);

else

	%--
	% output full contents of environment variable structure
	%--

	value = data.env;

end
