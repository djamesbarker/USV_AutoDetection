function state = flash_update(obj, prop, value, delay)

% flash_update - flash updated of object properties
% -------------------------------------------------
%
% state = flash_update(obj, prop, value, delay)
%
% Input:
% ------
%  obj - object handles
%  prop - properties to update
%  value - values to flash
%  delay - duration of flash, negative is indefinite (def: 0.2)
%
% Output:
% -------
%  state - used to restore state for negative delays

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
% $Revision: 1789 $
% $Date: 2005-09-15 17:23:27 -0400 (Thu, 15 Sep 2005) $
%--------------------------------

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% set default delay
%--

% NOTE: this typically takes longer

if (nargin < 4) || isempty(delay)
	delay = 0.2;
end

%--
% simple check on properties and values
%--

% NOTE: put prop and value into cell if needed

if ischar(prop)
	prop = {prop};
end

if ~iscellstr(prop)
	error('Properties must be a cell array of strings.');
end

if ~iscell(value)
	value = {value};
end
	
if length(prop) ~= length(value)
	error('Properties and values do not match.');
end

%--------------------------------
% FLASH UPDATE
%--------------------------------

%--
% get object properties
%--

if length(obj) > 1
	
	if length(unique(get(obj, 'type'))) > 1
		error('Object to flash update must be of same ''type''.');
	end
	
end

props = lower(fieldnames(get(obj(1))));

%--
% check and remove properties if needed
%--

for k = length(prop):-1:1
	
	if isempty(find(strcmp(props, prop{k})))
		prop(k) = []; value(k) = [];
	end
	
end

if isempty(prop)
	return;
end

%--
% get starting values for properties
%--

for j = 1:length(obj)
	
	for k = 1:length(prop)
		init{j}{k} = get(obj(j), prop{k});
	end

end

%--
% flash property values
%--

% NOTE: set flash values, pause, and reset to initial values

% NOTE: handle improper property values exception and remove from list

for j = 1:length(obj)
	
	for k = length(prop):-1:1
		
		try
			set(obj(j), prop{k}, value{k});
		catch
			prop(k) = []; init(k) = [];
		end

	end
	
end

% NOTE: negative delay sets the flash values until restore is called

if delay > 0
	
	pause(delay);

	% NOTE: we obtained these values from the object so we know they are proper

	for j = 1:length(obj)
		
		for k = 1:length(prop)
			try
				set(obj(j), prop{k}, init{j}{k});
			end
		end

	end
	
end

%--
% store output state
%--

if nargout
	state.handles = obj; state.prop = prop; state.init = init;
end
