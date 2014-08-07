function log = log_create(varargin)

% log_create - create empty log structure
% ---------------------------------------
%
% log = log_create(p,'field',value, ...)
%
% Input:
% ------
%  p - location of log file (def: file dialog)
%  field - log field name
%  value - log field value
%
% Output:
% -------
%  log - empty log structure

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
% $Revision: 1174 $
% $Date: 2005-07-13 16:54:00 -0400 (Wed, 13 Jul 2005) $
%--------------------------------

%--
% parse input arguments
%--

switch (nargin)

%--
% set location, use default values for log properties
%--

case ({0,1})
	
	%--
	% set file location
	%--
	
	if (nargin == 0)
		p = '';
	else
		p = varargin{1};
	end
	
	%--
	% set default values for other log properties
	%--
	
	% set filename and backup default
	
	filename = 'Untitled_Log';
	
	backup = 1;
	
	% set sound
	
	sound = [];
	
	%--
	% set display conditions
	%--
	
	visible = 1;
	
	color = color_to_rgb('Green');
	
	linestyle = linestyle_to_str('Solid');
	
	linewidth = 2;
	
	patch = -1;
	
	%--
	% set notes and author
	%--
	
	notes = '';
	
	author = '';
	
%--
% check for field value pairs to provide values for log properties
%--
	
otherwise
	
	%--
	% set location
	%--
	
	p = varargin{1};
	
	%--
	% get property values from field value pairs
	%--
	
	if (mod(nargin,2))
		
		%--
		% get field value pairs from input arguments
		%--
	
		for k = 1:floor(nargin / 2)
			
			ix = 2*k - 1;
			
			% get field names
			
			tmp = varargin{1 + ix};
			if (isstr(tmp))
				field{k} = lower(varargin{1 + ix});
			else
				disp(' ');
				error('Improper field value pair.'); 
			end
			
			% get values
			
			value{k} = varargin{2 + ix};
			
		end
		
		%--
		% assign selected values to properties
		%--
		
		% create table of properties and default values
		
		T = { ...
			'filename','XBAT_Log_Untitled'; ...
			'sound', []; ...
			'visible', 1; ...
			'color', color_to_rgb('Green'); ...
			'linestyle', linestyle_to_str('Solid'); ...
			'linewidth', 2; ...
			'patch', -1; ...
			'notes', ''; ...
			'author', '' ...
		};
			
		% set properties
		
		for k = 1:size(T,1)
			ix = find(strcmp(field,T{k,1}));
			if (~isempty(ix))
				eval([T{k,1} ' = value{' num2str(ix) '};']); 
			else
				eval([T{k,1} ' = T{' num2str(k) ',2};']); 
			end
		end
		
	else 
		
		disp(' ');
		error('Improper number of input arguments.');
		
	end
		
end

%--
% get file location interactively, and provide opportunity to edit
%--

if (isempty(p))

else
	
	%--
	% parse input location to match uigetfile output
	%--
    
    [p,f1,f2] = fileparts(p);
	
    p = [p filesep];
	fn = [f1 f2];
	
end 

%--
% create empty log strucuture
%--

log.type = 'log';

% at the moment there are logs out there with no version field and with
% version field and equal to 1. this should be enough to discriminate older 
% logs and apply an update.

log.version = xbat_version;

%--------------------------------
% PRIMITIVE FIELDS
%--------------------------------

%--
% id for log
%--

rand('state',sum(100*clock));

log.id = round(rand * 10^16);

%--
% location of log file
%--

log.path = p;

log.file = fn;

%--------------------------------
% ADMINISTRATIVE FIELDS
%--------------------------------

%--
% author of log, requested creation of log
%--

log.author = author;

%--
% creation and modification date of log
%--

log.created = now;

log.modified = '';

%--------------------------------
% DATA AND METADATA FIELDS
%--------------------------------

%--
% sound annotated in log
%--

log.sound = sound;

log.annotation = annotation_create;

%--
% events contained in log
%--

event = empty(event_create);

log.event = event;

log.deleted_event = event;

%--
% selected event subsets
%--

% create a structure to represent event selections

log.selected_events = selected_create;

%--
% extent fields
%--

log.length = 0;

log.curr_id = 1;

log.channel = [];

log.time = [];

log.freq = [];

log.duration = [];

log.bandwidth = [];

%--------------------------------
% METADATA FIELDS
%--------------------------------

log.measurement = measurement_create;	% log measurements

log.annotation = annotation_create;		% log annotations

log.generation = [];					% log generation summary, extension computation summaries

%--------------------------------
% DISPLAY FIELDS
%--------------------------------

log.visible = visible;

log.color = color;

log.linestyle = linestyle;

log.linewidth = linewidth;

log.patch = patch;

log.event_id = 1;

%--------------------------------
% DOCUMENT INTEGRITY FIELDS
%--------------------------------

log.open = 0;

log.readonly = 0;

log.autosave = 1;

log.autobackup = 1;

log.saved = 0;

%--
% userdata field
%--

log.userdata = [];

%--------------------------------
% CREATE LOG FILE
%--------------------------------

log_save(log);


%------------------------------------------------------
% LOG_CREATE_IN
%------------------------------------------------------

function log = log_create_in(varargin)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2319 $
% $Date: 2005-12-16 19:26:33 -0500 (Fri, 16 Dec 2005) $
%--------------------------------

%--------------------------------
% CREATE STRUCT
%--------------------------------

%--
% source fields
%--

% NOTE: older logs may have no version field or version field equal to 1

log.type = 'log';

log.version = xbat_version;

rand('state',sum(100*clock));

log.id = round(rand * 10^16);

log.path = '';

log.file = '';

%--
% document fields
%--

log.open = 0;

log.readonly = 0;

log.autosave = 1;

log.autobackup = 1;

log.saved = 0;

%--
% admin fields
%--

log.author = author;

log.created = now;

log.modified = '';

log.userdata = [];

%--
% data and metadata fields
%--

log.sound = sound;

log.annotation = annotation_create;

%--
% events contained in log
%--

event = event_create;

log.event = event;

log.deleted_event = event;

%--
% selected event subsets
%--

% create a structure to represent event selections

log.selected_events = selected_create;

%--
% extent fields
%--

log.length = 0;

log.curr_id = 1;

log.channel = [];

log.time = [];

log.freq = [];

log.duration = [];

log.bandwidth = [];

%--------------------------------
% METADATA FIELDS
%--------------------------------

log.measurement = measurement_create;	% log measurements

log.annotation = annotation_create;		% log annotations

log.generation = [];					% log generation summary, extension computation summaries

%--------------------------------
% DISPLAY FIELDS
%--------------------------------

log.visible = visible;

log.color = color;

log.linestyle = linestyle;

log.linewidth = linewidth;

log.patch = patch;

log.event_id = 1;

