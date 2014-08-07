function [pos, unit] = get_size_in(obj, unit, pack)

% get_size_in - get position of object in specified units
% -------------------------------------------------------
%
% [pos, unit] = get_size_in(obj, unit, pack)
%
% Input:
% ------
%  obj - object handle
%  unit - desired unit
%  pack - pack as struct flag
%
% Output:
% -------
%  pos - position
%  unit - position unit

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

% TODO: rename and extend to multiple handle input

%-----------------------
% HANDLE INPUT
%-----------------------

% NOTE: no packing is the original behavior

if nargin < 3
	pack = 0;
end

%--
% check handle input
%--

if ~ishandle(obj)
	error('Input must be a handle.');
end

types = {'root', 'figure', 'axes', 'uicontrol', 'uitable'}; type = lower(get(obj, 'type'));

if ~ismember(type, types)
	error(['Input handle type ''', type, ''' is not supported.']);
end

%--
% update property name in case of root
%--

% NOTE: root is screen, the 'position' is screensize

if obj == 0
	prop = 'screensize';
else
	prop = 'position';
end

%-----------------------
% GET SIZE
%-----------------------

%--
% get position in current units if no units input
%--

if (nargin < 2) || isempty(unit)
	
	pos = get(obj, prop); unit = get(obj, 'units'); 
	
	if pack
		pos = pack_size(pos);
	end
	
	return;
	
end

%--
% check units input
%--

[proper, unit] = is_proper_size_unit(obj, unit);

if ~proper
	error(['Input units ''', unit, ''' are not valid units for input object.']);
end

%-----------------------
% GET POSITION
%-----------------------

init = get(obj, 'units'); set(obj, 'units', unit); pos = get(obj, prop); set(obj, 'units', init);

if pack
	pos = pack_size(pos);
end


% TODO: make these functions

%-----------------------
% PACK_SIZE
%-----------------------

function out = pack_size(pos)

name = {'left', 'bottom', 'width', 'height'};

for k = 1:4
	out.(name{k}) = pos(k);
end


%-----------------------
% UNPACK_SIZE
%-----------------------

function out = unpack_size(pos)

name = {'left', 'bottom', 'width', 'height'};

pos = zeros(1, 4);

for k = 1:4
	pos(k) = out.(name{k});
end
