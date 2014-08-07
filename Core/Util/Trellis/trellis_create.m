function tre = trellis_create(varargin)

% trellis_create - create trellis display data structure
% ------------------------------------------------------
%
% tre = trellis_create
%
% Output:
% -------
%  tre - trellis display data structure

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
% $Revision: 1.0 $
% $Date: 2003-06-11 18:21:46-04 $
%--------------------------------

%---------------------------------------------------------------------
% CREATE TRELLIS STRUCTURE
%---------------------------------------------------------------------

persistent TRELLIS_PERSISTENT;

if (isempty(TRELLIS_PERSISTENT))
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	tre.name = []; % name of trellis display
	
	%--
	% data field
	%--
	
	tre.data = [];
	
	%--
	% axis variable fields
	%--
		
	axis.field = {'','',''}; % data fields to display as axis variables in X, Y, and Z
	
	axis.color = color_to_rgb('Green'); % color for axis variable display
	
	axis.linestyle = '-'; % linestyle for axis variable display
	
	axis.linewidth = 1; % linewidth for axis variable display
	
	axis.marker = 'o'; % marker for axis variable display
	
	axis.markersize = 8; % size for axis variable marker display
	
	tre.axis = axis;
	
	%--
	% conditioning variable fields
	%--
	
	cond.field = {'',''};
	
	cond.type = {'',''};
		
	tre.cond = cond;
		
	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	tre.author = ''; % author of tre
	
	tre.created = now; % creation date
	
	tre.modified = []; % modification date
	
	%--------------------------------
	% USERDATA FIELD
	%--------------------------------
	
	tre.userdata = []; % userdata field is not used by system
	
	%--
	% set persistent tre
	%--
	
	TRELLIS_PERSISTENT = tre;
	
else
	
	%--
	% copy persistent tre and update creation date
	%--
	
	tre = TRELLIS_PERSISTENT;
	
	tre.created = now;
	
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	tre = parse_inputs(tre,varargin{:});
end
