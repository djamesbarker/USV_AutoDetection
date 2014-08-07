function [obj,adapter,info] = get_analog_input(name, type)

% get_input - get input object and associated adapter
% ---------------------------------------------------
% 
% [obj,adapter] = get_input(name)
%
% Input:
% ------
%  name - input object adapter name
%
%  type - desired adapter type
%
% Output:
% -------
%  obj - input object
%
%  adapter - adapter
%
%  info - hardware info about this specific adapter
%
%--
% get named input object, create if needed
%--

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

obj = daqfind('name',name);

if (~isempty(obj))
    	
	obj = obj{1};
	
	adapter = find_adapter(obj);
			  
else
	
	adapters = get_adapters;
	
	%--
	% create and name input object
	%--
	
	if nargin < 2
	
		adapter = adapters(1);
		
	else
		
		adapter = find_adapter(type);
		
	end
	
	obj = analoginput(adapter.type, adapter.ID);
	
end

%--
% Set up initial acquisition parameters
%--

set(obj, ...
	'name', name ...
);

if nargout > 2

	info = daqhwinfo(obj);
	
end
