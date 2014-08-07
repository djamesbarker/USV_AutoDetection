function g = control_highlight(h,field,value,color)

% control_highlight - highlight controls
% --------------------------------------
%
% control_highlight(h,field,value,color)
%
% Input:
% ------
%  h - parent handle
%  field - uicontrol field
%  value - uicontrol field value
%  color - highlight color (def: [1 1 0])
%
% Output:
% -------
%  g - handles of modified objects

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
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%---------------------------------
% HANDLE INPUT
%---------------------------------

%--
% set color
%--

if ((nargin < 4) || isempty(color))
	color = [1 1 0];
end

%--
% set value
%--

if (nargin < 3)
	value = '';
end

%--
% set field
%--

if (nargin < 2)
	field = '';
end

%--
% set parent figure
%--

if ((nargin < 1) || isempty(h))
	h = gcf;
end

%---------------------------------
% HIGHLIGHT CONTROLS
%---------------------------------

%--
% select and subselect controls
%--

g0 = findobj(h,'type','uicontrol');

if (iscell(value))
	g = [];
	for k = 1:length(value)
		g = [g, findobj(g0,field,value{k})];
	end
else
	g = findobj(g0,field,value);
end 

%--
% update background color
%--

set(g,'backgroundcolor',color);
