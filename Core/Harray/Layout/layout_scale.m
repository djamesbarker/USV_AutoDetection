function layout = layout_scale(layout, scale)

% layout_scale - scale layout
% ---------------------------
%
% layout = layout_scale(layout, scale)
%
% Input:
% ------
%  layout - layout
%  scale - scale
%
% Output:
% -------
%  layout - scaled layout

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set default scale
%--

if (nargin < 2) || isempty(scale)
	scale = 1;
end

%--
% check scale
%--

if ~isreal(scale) || (length(scale) > 1) || (scale <= 0)
	error('Layout scale must be a positive real number.');
end

%--
% handle multiple layouts recursively
%--

if length(layout) > 1
	
	for k = 1:length(layout)
		layout(k) = layout_scale(layout(k), scale);
	end 
	
	return;
	
end

%--
% return if the input and output scales are the same
%--

% NOTE: this would lead to a 1 scaling factor

if scale == layout.scale
	return;
end

%---------------------------------------
% SCALE LAYOUT
%---------------------------------------

% NOTE: layout scaling scales tool, status, and color bars and various margins

%--
% compute scaling factor and update scale
%--

fac = scale / layout.scale;

layout.scale = scale;

%--
% scale tool, status, and color bar sizes
%--

layout.tool.size = fac * layout.tool.size;

layout.status.size = fac * layout.status.size;

layout.color.size = fac * layout.color.size;

layout.color.pad = fac * layout.color.pad;

%--
% scale margins
%--

layout.margin = fac * layout.margin;

%--
% scale row and column padding
%--

layout.row.pad = fac * layout.row.pad;

layout.col.pad = fac * layout.col.pad;
