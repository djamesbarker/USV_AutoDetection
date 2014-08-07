function value = set_env(name, value, verb)

% set_env - set environment variable
% ----------------------------------
%
% value = set_env(name, value, verb)
%
% Input:
% ------
%  name - variable name
%  value - variable value
%  verb - verbosity flag (def: 0)
%
% Output:
% -------
%  value - value set

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
% $Revision: 6572 $
% $Date: 2006-09-18 12:45:44 -0400 (Mon, 18 Sep 2006) $
%--------------------------------

% TODO: update the environment variable framework to use application data

% TODO: update framework to alloe for saving to a file

%--
% set display verb
%--

if (nargin < 3) || isempty(verb)
	verb = 0;
end

%--
% get root userdata
%--

data = get(0, 'userdata');

%--
% check for existing environment variable structure
%--

if isfield(data, 'env')
	
	if isfield(data.env, name)
		
		%--
		% update value of existing environment variable
		%--
		
		data.env.(name) = value;
		
	else
		
		%--
		% create new environment variable
		%--
		
		data.env.(name) = value;
		
		%--
		% report creation of new environment variable
		%--
		
		if verb
			disp(['Environment variable ''', name, ''' created.']);
		end
		
	end
	
else
	
	%--
	% create new environment variable
	%--
		
	data.env.(name) = value;
	
	%--
	% report creation of environment variable structure and new environment variable
	%--
	
	if verb
		disp(['Environment variable structure created.']);
		disp(['Environment variable ''', name, ''' created.']);
	end
	
end

%--
% update root userdata
%--

set(0, 'userdata', data);
