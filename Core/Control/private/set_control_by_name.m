function flag = set_control_by_name(pal,control)

% set_control_by_name - update control using name
% -----------------------------------------------
%
% flag = set_control_by_name(pal,control)
%
% Input:
% ------
%      pal - palette handle
%  control - control to set
%
% Output:
% -------
%  flag - success indicator flag

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
% $Revision: 3408 $
% $Date: 2006-02-06 15:40:18 -0500 (Mon, 06 Feb 2006) $
%--------------------------------

%--------------------------------------
% HANDLE INPUT
%--------------------------------------

%--
% handle multiple controls recursively
%--

% TODO: consider option to not use recursion

if (numel(control) > 1)
	
	for k = 1:numel(control)
		flag(k) = set_control_by_name(pal,control(k));
	end
	
	return;
	
end

%--------------------------------------
% SET CONTROL
%--------------------------------------

%--
% get palette controls and index of named control
%--

controls = get_palette_controls(data.control);

[ignore,ix] = get_control_by_name(pal,control.name,controls);

if (isempty(ix))
	flag = 0; return;
end

%--
% update named control and set palette controls
%--

controls(ix) = control;

% NOTE: set function will render palette according to the new controls

flag = set_palette_controls(pal,controls);
