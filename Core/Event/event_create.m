function event = event_create(varargin)

% event_create - create event structure
% -------------------------------------
%
%  event = event_create
%
% Output:
% -------
%  event - event structure

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
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

% TODO: replace stored duration and bandwidth with access function

%---------------------------------------
% PERSISTENT EVENT
%---------------------------------------

persistent EVENT_PERSISTENT;

if isempty(EVENT_PERSISTENT)
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	% NOTE: 'id' supports event hierarchy among other things
	
	event.id = [];
	
	% NOTE: tags, rating, and notes support simple annotation
	
	event.tags = {};
	
	event.rating = [];
	
	event.notes = {};
	
	% NOTE: score (also rating to some extent) supports priority based navigation

	event.score = [];
	
	%--
	% event fields
	%--
	
	event.channel = []; 
	
	event.time = []; 
	
	event.freq = [];
	
	% NOTE: these will be replaced by accesor functions
	
	event.duration = [];
	
	event.bandwidth = [];
	
	%--
	% event data fields
	%--
	
	event.samples = [];
	
	event.rate = [];
	
	%--
	% hierarchy event fields
	%--
	
	% NOTE: the level it the max child level incremented by one
	
	event.level = []; 
	
	% NOTE: children and parents contain 'id'
	
	event.children = []; 
	
	event.parent = []; 
	
	%--
	% administrative fields
	%--
	
	% NOTE: consider separate authors for create and modify
	
	event.author = '';
	
	event.created = now;
	
	event.modified = [];
	
	%--
	% userdata
	%--
	
	event.userdata = [];
	
	%--------------------------------
	% DATA FIELDS
	%--------------------------------
	
	% NOTE: values using in detection, not well defined
	
	event.detection.value = [];
	
	% NOTE: each of these contains an array of measures or annotation
	
	event.annotation = empty(annotation_create);
	
	event.measurement = empty(measurement_create); 
	
	%--
	% set persistent event
	%--
	
	EVENT_PERSISTENT = event;

end

%---------------------------------------
% CREATE EVENT
%---------------------------------------

%--
% copy persistent event and modify
%--

event = EVENT_PERSISTENT;

event.created = now;

%--
% set and check fields
%--

if length(varargin)
	
	%--
	% try to get field value pairs from input
	%--
	
	event = parse_inputs(event, varargin{:});
	
	%--
	% set event level
	%--
	
	event.level = event_level(event);
	
	%--
	% compute duration and bandwidth
	%--

	if ~isempty(event.time)
		event.duration = event_duration(event);
	end
	
	if ~isempty(event.freq)
		event.bandwidth = event_bandwidth(event);
	end

end


