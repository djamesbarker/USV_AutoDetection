function [sel, opt] = get_axes_selections(ax)

% get_axes_selections - get selections from axes
% ----------------------------------------------
%
% [sel, opt] = get_axes_selections(ax)
%
% Input:
% ------
%  ax - parent axes
%
% Output:
% -------
%  sel - selections
%  opt - selection options

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
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%--
% find patch objects in axes
%--

obj = findobj(ax, 'type', 'patch');

if isempty(obj)
	sel = []; opt = []; return;
end

%--
% check for patches tagged as selections
%--

tags = get(obj, 'tag');

for k = length(tags):-1:1
	
	if isempty(strfind(tags{k}, '::SELECTION::'))
		tags(k) = []; obj(k) = [];
	end
	
end

if isempty(obj)
	sel = []; opt = []; return;
end

%--
% get selections from patches
%--

for k = 1:length(obj)
	
	% NOTE: we store options in cell to handle empty options
	
	callback = get(obj(k), 'buttondownfcn'); sel(k) = callback{2}; opt{k} = callback{3};
	
end
