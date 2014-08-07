function data_event = data_event_create(varargin)

% data_event_create - create data event structure
% -----------------------------------------------
%
%  data_event = data_event_create
%
% Output:
% -------
%  data_event - data event structure

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
% CREATE DATA_EVENT STRUCTURE
%---------------------------------------------------------------------

persistent DATA_EVENT_PERSISTENT;

if (isempty(DATA_EVENT_PERSISTENT))
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	data_event.id = []; % data event id, used to support selection sequences among other things
	
	%--
	% event location fields 
	%--
	
	data_event.variables = []; % x and y variables
	
	data_event.x = []; % x coordinate selection
	
	data_event.y = []; % y coordinate selection
	
	data_event.dx = []; % x range 
	
	data_event.dy = []; % y range
	
	%--
	% hierarchical event fields
	%--
	
	data_event.level = []; % hierarchy level, maximum of the children levels incremented by one
	
	data_event.children = []; % children events, array of data_event id numbers
	
	data_event.parents = []; % parent events, array of data_event id numbers
	
	%--
	% selection sequence fields
	%--
	
	% these fields should help implement selection of data points based on
	% a selection sequence (roughly a log of data events) evaluation of the
	% result of a selection sequence proceeds by evaluating the atomic
	% propositions, those for which all these fields are empty. evaluation
	% of the result of more complex propositions is postponed until the
	% atomic ones are available.
	
	% this is just a first thought on the implementation of this concept
	% and requires formalization. through this there is place for any other
	% number of optimization for evaluation of these rules
	
	% this may not even be the way that we want selections represented
	
	data_event.and = [];
	
	data_event.or = [];
	
	data_event.xor = [];
	
	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	data_event.author = ''; % author of data_event
	
	data_event.created = now; % creation date
	
	data_event.modified = []; % modification date
	
	
	%--------------------------------
	% METADATA FIELDS
	%--------------------------------
	
	% there may be use for these later
	
% 	data_event.annotation = annotation_create; % array of annotation structures
% 	
% 	data_event.measurement = measurement_create; % array of measurement structures
	
	
	%--------------------------------
	% USERDATA FIELD
	%--------------------------------
	
	data_event.userdata = []; % userdata field is not used by system
	
	%--
	% set persistent data_event
	%--
	
	DATA_EVENT_PERSISTENT = data_event;
	
else
	
	%--
	% copy persistent data_event and update creation date
	%--
	
	data_event = DATA_EVENT_PERSISTENT;
	
	data_event.created = now;
	
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	data_event = parse_inputs(data_event,varargin{:});
end
