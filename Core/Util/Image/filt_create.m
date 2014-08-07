function F = filt_create(varargin)

% filt_create - create filter structure
% -------------------------------------
%
%  F = filt_create
%
% Output:
% -------
%  F - filter structure

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%---------------------------------------------------------------------
% CREATE FILTER STRUCTURE
%---------------------------------------------------------------------

persistent FILTER_PERSISTENT;

if isempty(FILTER_PERSISTENT)
	
	%--------------------------------
	% DATA FIELDS
	%--------------------------------
	
	F.H = []; % filter mask
	
	F.S = []; % singular values
	
	F.X = []; % horizontal filters
	
	F.Y = []; % vertical filters
	
	F.c = []; % normalization constant
	
	F.t = []; % mean translation
	
	%--------------------------------
	% APPROXIMATION FIELDS
	%--------------------------------
		
	F.tol = []; % rank computation tolerance
	
	F.rank = []; % numerical rank of filter matrix

	F.normalize = 1; % norm to use in normalization

	F.zeromean = 0; % zero mean indicator flag
		
	%--------------------------------
	% METADATA FIELDS
	%--------------------------------
	
	F.error = []; % error for different rank approximations
	
	F.speed = []; % computational speed up from approximation
			
	%--------------------------------
	% USERDATA FIELD
	%--------------------------------
	
	F.userdata = []; % userdata field is not used by system
	
	%--
	% set persistent filter
	%--
	
	FILTER_PERSISTENT = F;
	
else
	
	%--
	% copy persistent filter and update creation date
	%--
	
	F = FILTER_PERSISTENT;
		
end


