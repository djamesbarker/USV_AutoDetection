function state = control_flash(varargin)

% control_flash - flash control
% -----------------------------
%
% state = control_flash(obj, prop, value)
%
%       = control_flash(control, pal, prop, value)
%
% Input:
% ------
%  obj - handle of control component
%  control - control name and handles
%  pal - control parent name and handle
%  prop - properties to update
%  value - values to flash
%
% Output:
% -------
%  state - used to restore initial state

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

% NOTE: we are currently not revealing the delay options

%-------------------------------------
% HANDLE INPUT
%-------------------------------------

%--
% handle various calling forms
%--

% NOTE: flag indicates whether we need to set default properties and values

switch length(varargin)
	
	case (1)
		obj = varargin{1}; flag = 1;
		
	case (2)
		control = varargin{1}; pal = varargin{2}; flag = 1;
		
	case (3)
		obj = varargin{1}; prop = varargin{2}; value = varargin{3}; flag = 0;
		
	case (4)
		control = varargin{1}; pal = varargin{2}; prop = varargin{3}; value = varargin{4}; flag = 0;
		
end

%--
% get context handles if needed
%--

% NOTE: existence of object variable indicates whether we need context

if exist('obj', 'var')
	[control, pal] = get_callback_context(obj);
end

%--
% set default flash properties
%--

% NOTE: we really want a hash here

if flag
	prop = {'backgroundcolor'}; value = {[0.8, 0.9, 1]};
end

%-------------------------------------
% FLASH CONTROL
%-------------------------------------

%--
% check one of out control elements is the callback object
%--

% NOTE: the only thing we are not sure about is the structure of handles

if isempty(gcbo) || ~ismember(gcbo, control.handles)
	return;
end

%--
% visual indicator
%--

% NOTE: flash edit background

obj = findobj(control.handles, 'style', 'edit');
 
if ~isempty(obj)
	flash_update(obj, prop, value);
end

%--
% audible indicator
%--

% TODO: use click when available

