function measure = measure_create(varargin)

% measure_create - create measure structure
% -----------------------------------------
% 
% measure = measure_create
%
% Output:
% -------
%  measure - XBAT measure (process) description structure

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
% CREATE MEASURE STRUCTURE
%---------------------------------------------------------------------

persistent MEASURE_PERSISTENT;

if (isempty(MEASURE_PERSISTENT))

	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------

	measure.type = 'measure';
	
	measure.name = ''; % name of measure

	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	measure.version = []; % version number of measure
	
	measure.modified = []; % release date of current version
	
	measure.author = ''; % author of measure
	
	%--------------------------------
	% FUNCTION FIELDS
	%--------------------------------
	
	measure.fun.main = ''; % container function
	
	measure.fun.parameter = []; % parameter handling function
	
	measure.fun.compute = []; % computation funtion
	
	measure.fun.value = []; % value handling function
	
	measure.fun.menu = []; % context menu construction function
	
	measure.fun.display = []; % inline display function
		
	measure.fun.plot = []; % external plotting function
	
	%--------------------------------
	% SYSTEM INTERACTION FIELDS
	%--------------------------------
	
	measure.required = []; % required sound attributes
	
	measure.recompute = []; % recompute on event editing flag
	
	%--------------------------------
	% INPUT AND OUTPUT FIELDS
	%--------------------------------
	
	measure.parameter = []; % measure parameter structure
	
	measure.value = []; % measure values structure
	
	%--------------------------------
	% USERDATA FIELDS
	%--------------------------------
	
	measure.userdata = [];
	
	%--
	% set persistent measure
	%--
	
	MEASURE_PERSISTENT = measure;
	
else 
	
	%--
	% copy persistent measure
	%--
	
	measure = MEASURE_PERSISTENT;
		
end


%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	measure = parse_inputs(measure,varargin{:});
end
