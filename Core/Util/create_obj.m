function [handle, created]  = create_obj(type, par, tag, varargin)

% create_obj - create tagged object of specific type within parent
% ----------------------------------------------------------------
%
% [handle, created] = create_obj(type, par, tag, field, value, ... )
%
% Input:
% ------
%  type - type
%  par - parent
%  tag - tag
%  field - field name
%  value - field value
%
% Output:
% -------
%  handle - object handle
%  created - creation indicator

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

% TODO: consider some form of caching, to skip 'findobj'

%---------------------
% HANDLE INPUT
%---------------------

%--
% check type
%--

types = {'figure', 'axes', 'line', 'patch', 'rectangle', 'uicontrol'};

if ~ismember(type, types)
	error('Unrecognized object type.');
end

%---------------------
% GET OBJECT HANDLE
%---------------------

%--
% get tagged object of type from parent, create if needed
%--

handle = findobj(par, 'type', type, 'tag', tag);

if ~isempty(handle)
	created = 0;
else
	handle = feval(type, 'parent', par, 'tag', tag); created = 1;
end

%--
% set object properties
%--

% NOTE: we at least check that fields and values are paired

if length(varargin) && ~mod(length(varargin), 2)
	
	try
		set(handle, varargin{:});
	catch
		
		% TODO: make some reasonable error display function
		
		str = 'WARNING: failed to set object properties.';
		disp(' '); 
		disp(str);
		str_line(str);
		out = lasterror; disp(out.message);
	
	end

end
