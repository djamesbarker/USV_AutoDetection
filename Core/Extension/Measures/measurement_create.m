function measurement = measurement_create(varargin)

% measurement_create - create measurement structure
% -------------------------------------------------
%
% measurement = measurement_create
%
% Output:
% -------
%  measurement - XBAT measurement (result) structure

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
% CREATE MEASUREMENT STRUCTURE
%---------------------------------------------------------------------

persistent MEASUREMENT_PERSISTENT;

if (isempty(MEASUREMENT_PERSISTENT))

	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	measurement.name = ''; % name of measurement
	
	measurement.fun = ''; % function implementing measurement
	
	
	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	measurement.author = ''; % author of measurement
	
	measurement.created = now; % creation date 
	
	measurement.modified = []; % modification date
	
	
	%--------------------------------
	% METADATA FIELDS
	%--------------------------------
	
	measurement.value = []; % measurement values computed
	
	measurement.parameter = []; % paremeters used in measurement computation
	
	
	%--------------------------------
	% USERDATA FIELDS
	%--------------------------------
	
	measurement.userdata = [];
	
	%--
	% set persistent measurement
	%--
	
	MEASUREMENT_PERSISTENT = measurement;
	
else 
	
	%--
	% copy persistent measurement and update creation date
	%--
	
	measurement = MEASUREMENT_PERSISTENT;
	
	measurement.created = now;
	
end


%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	measurement = parse_inputs(measurement,varargin{:});
end
