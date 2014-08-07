function [layout, tile] = browser_tile_layout(status, color, slider)

% browser_layout - give browser layout sizes in tiles
% ---------------------------------------------------
%
% [layout, tile] = browser_tile_layout(status, color, slider)
%
% Inputs:
% -------
% status - status bar indicator
% color - color bar indicator
% slider - slider indicator
%
% Outputs:
% --------
% layout - layout structure
% tile - tile size in pixels

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
% Author: Matt Robbins
%--------------------------------
% $Revision: 1935 $
% $Date: 2005-10-14 16:58:12 -0400 (Fri, 14 Oct 2005) $
%--------------------------------

%-------------------
% HANDLE INPUT
%-------------------

if (nargin < 3)
	slider = 1;
end

%-------------------
% GET PARAMETERS
%-------------------

param = get_palette_settings;

%-------------------
% CREATE LAYOUT
%-------------------

tile = param.tilesize * 1.2; 

%--
% axes array spacing
%--

% NOTE: these are in tile units

layout.yspace = 0.5;

layout.xspace = 0.5;

layout.top = 2;

layout.left = 2.5;

layout.right = 1.5;

%--
% modify margins based on layout elements
%--

layout.bottom = 3 + status + slider;

layout.colorbar = 2.5 * color;

