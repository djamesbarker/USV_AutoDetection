function log = log_create(varargin)

% log_create - create empty log structure
% ---------------------------------------
%
% log = log_create(p,'field1',value1,'field2',value2,...)
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
% $Revision: 950 $
% $Date: 2005-04-20 02:22:39 -0400 (Wed, 20 Apr 2005) $
%--------------------------------

%---------------------------------------------------------------------
% CREATE EVENT STRUCTURE
%---------------------------------------------------------------------

persistent LOG_PERSISTENT;

if (isempty(LOG_PERSISTENT))

	%--------------------------------
	% CREATE LOG STRUCTURE
	%--------------------------------
	
	log.type = 'log'; % type of structure
	
	log.version = 1; % version of log structure
	
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	%--
	% id for log
	%--
	
	rand('state',sum(100*clock));
	
	log.id = round(rand * 10^12); % random id for log, tries to be unique
	
	%--
	% location of log file
	%--
	
	log.path = []; % path of log file, subject to change often
	
	log.file = 'new_log.mat'; % log filename, subject to change less often
	
	
	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	log.author = []; % author of log, requested creation of log
	
	log.created = now; % creation date
	
	log.modified = []; % modification date
	
	
	%--------------------------------
	% DATA AND METADATA FIELDS
	%--------------------------------
	
	%--
	% sound annotated in log
	%--
	
	log.sound = [];
	
	%--
	% events contained in log
	%--
	
	event = event_create;
	
	log.event = event; % array of events in log
	
	log.deleted = event; % array of events deleted from log
	
	%--
	% number of events and current id
	%--
	
	log.length = 0; % number of events in log
	
	log.curr_id = 1; % id to be used for next event
	
	%--
	% extent of events in log
	%--
	
	log.channel = []; % channels containing events from log
	
	log.time = []; % minimum and maximum time over all events
	
	log.freq = []; % minimum and maximum frequency over all events
	
	log.duration = []; % duration of set of log events
	
	log.bandwidth = []; % bandwith of set of log events
	
	%--
	% annotation and measurement fields
	%--
	
	log.annotation = annotation_create; % array of annotation structures
	
	log.measurement = measurement_create; % arrat of measurement structures
	
	
	%--------------------------------
	% DISPLAY FIELDS
	%--------------------------------
	
	log.visible = 1; % display state
	
	log.color = color_to_rgb('Green'); % color for various display objects
	
	log.linestyle = '-'; % event boundary linetype
	
	log.linewidth = 2; % event boundary linewidth
	
	log.patch = -1; % patch display alpha
	
	
	%--------------------------------
	% DOCUMENT INTEGRITY FIELDS
	%--------------------------------
	
	log.open = 0; % open state flag
	
	log.readonly = 0; % read only state flag
	
	log.autosave = 1; % automatic save state
	
	log.saved = 0; % saved state flag
	
	
	%--------------------------------
	% USERDATA FIELDS
	%--------------------------------
	
	log.userdata = []; % userdata field is not used by system
	
	%--
	% set persistent log
	%--
	
	LOG_PERSISTENT = log;

else
	
	%--
	% copy persistent log and set creation date
	%--
	
	log = LOG_PERSISTENT;

	log.created = now;
	
end

%---------------------------------------------------------------------
% SET LOG FIELDS
%---------------------------------------------------------------------

if (length(varargin))
	
	%--
	% set fields provided at the command line
	%--
	
	log = parse_inputs(log,varargin{:});
	
	%--
	% set path and filename
	%--
	
	if (isempty(log.path))
		log = ui_set_path(log);
	end
	
else
	
	%--
	% set path and filename
	%--
	
	log = ui_set_path(log);
	
	%--
	% set properties interactively
	%--
	
	if (~isempty(log))
		log = ui_set_properties(log);
	end
	
end	

%--------------------------------
% CREATE LOG FILE
%--------------------------------

if (~isempty(log))
	
	%--
	% save log
	%--
	
	log_save(log);
	
else

	%--
	% log creation was cancelled
	%--
	
	disp(' ');
	warning('No file was created, XBAT log creation was cancelled.');
	
	log = [];
	
	return;
	
end


%---------------------------------------------------------------------
% UI_SET_PATH
%---------------------------------------------------------------------

function log = ui_set_path(log)

% ui_set_properties - set log properties interactively
% ----------------------------------------------------
%
% log = ui_set_properties(log)
%
% Input:
% ------
%  log - input log
%
% Output:
% -------
%  log - modified log

%--
% get current directory
%--

pi = pwd;

%--
% interactively get path and filename
%--

fn = [];

while (isempty(fn))
	
	%--
	% move to log path if available
	%--
	
	if (~isempty(get_env('xbat_path_log')))
		cd(get_env('xbat_path_log'));
	end
	
	%--
	% get path and filename
	%--
	
	[fn,p] = uiputfile([log.file '.mat'],'Create XBAT Log File:');
	
	%--
	% set log path and reset filename
	%--
	
	if (fn ~= 0)
		set_env('xbat_path_log',p);
		filename = file_ext(fn);
	end
	
	%--
	% check that name starts with a alphabetic character
	%--
	
	if (~isempty(find(double(fn(1)) == double('0123456789'))))
		
		tmp = warn_dialog( ...
			'Filename must begin with alphabetic character.', ...
			'XBAT Warning  -  Log Filename', ...
			'modal' ...
		);
		waitfor(tmp);
		
		fn = [];
		
	end
	
end

%--
% process was cancelled
%--

if (~fn)
	log = [];
end


%---------------------------------------------------------------------
% UI_SET_PROPERTIES
%---------------------------------------------------------------------

function log = ui_set_properties(log)

% ui_set_properties - set log properties interactively
% ----------------------------------------------------
%
% log = ui_set_properties(log)
%
% Input:
% ------
%  log - input log
%
% Output:
% -------
%  log - modified log

%--
% get log display parameters
%--

ans = input_dialog( ...
	{ ...
		'Path','File', 'Author', ...
		'Visible','Color','Line Style','Line Width','Opacity' ...
	}, ...
	'New Log ...', ...
	[ ...
		1,48; 1,48; 1,48; ...
		1,32; 1,32; 1,32; 1,32; 1,32; ...
	], ...
	{ ...
		{p},fn, author, ...
		{'On','Off'}, ...
		color_to_rgb, ...
		linestyle_to_str('','strict'), ...
		{'1 Point','2 Point','3 Point','4 Point',2}, ...
		{'Transparent','1/8 Alpha','1/4 Alpha','1/2 Alpha','3/4 Alpha','Opaque'} ...
	}, ...
	{ ...
		'Log file directory', ...
		'Log file name', ...
		'Author of log', ...
		'Visiblity of log', ...
		'Color of log event display objects', ...
		'Line style of event boundaries', ...
		'Line width of event boundaries', ...
		'Transparency level of event patch' ...
	} ...
);

if (isempty(ans))	
	log = [];
	return;
else
	
	%--
	% set file location and author
	%--
	
	p = ans{1};
	fn = ans{2};
	
	author = ans{3};
	
	%--
	% set display options
	%--
	
	visible = str2bin(ans(4));
	
	color = color_to_rgb(ans{5}); 
	linestyle = linestyle_to_str(ans{6},'strict');
	linewidth = str2num(strtok(ans{7},' '));
	
	if (strcmp(ans{8},'Transparent'))
		patch = -1;
	elseif (strcmp(ans{8},'Opaque'))
		patch = 1;
	else
		patch = eval(strtok(ans{8},' '));
	end
	
end








