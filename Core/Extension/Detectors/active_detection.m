function log = active_detection(par, data)

% active_detection - perform active detection
% -------------------------------------------
%
% log = active_detection(par, data)
%
% Input:
% ------
%  par - handle to browser figure
%  data - browser figure userdata
%
% Output:
% -------
%  log - active detection log

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
% $Revision: 677 $
% $Date: 2005-03-08 19:57:35 -0500 (Tue, 08 Mar 2005) $
%--------------------------------

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% get parent state if needed
%--

if (nargin < 2) || isempty(data)
	data = get_browser(par);
end

%--
% set default output to cleared active detection log
%--

% TODO: consider replacing this with active log accessor

log = log_clear(data.browser.active_detection_log);

%--
% get active detector
%--

detector = get_active_extension('sound_detector', par, data);

% NOTE: return if there is no active detector

if isempty(detector)
	return;
end

%-------------------------------------------------
% BUILD CONTEXT
%-------------------------------------------------

%--
% get sound and channels
%--

sound = data.browser.sound;

channels = get_channels(data.browser.channels);

%--
% get page start and duration
%--

% NOTE: we map the browser page boundaries to recording time

edges = [data.browser.time, data.browser.time + data.browser.page.duration];

edges = map_time(sound, 'record', 'slider', edges);

% NOTE: this happens when there is no data in the displayed page, due to expansion

if diff(edges) == 0
	return;
end

% NOTE: duck a page until the browser has a proper page

page.start = edges(1); page.duration = diff(edges);

%--
% build scan for page considering sound
%--

scan = scan_intersect(get_sound_scan(sound), get_page_scan(page));

% NOTE: the pager reads sound in recording time, the scan handles session boundaries

sound.time_stamp = [];

%%%% HACK %%%%

% NOTE: what we want is the scan page to be the browser page if possible

scan.page.duration = min(10, data.browser.page.duration);

%--
% pack context
%--

context = detector_context(detector, sound, scan, channels, [], par, data);

%-------------------------------------------------
% UPDATE ACTIVE DETECTION LOG
%-------------------------------------------------

%--
% scan using active detector
%--

log.event = detector_scan(context);

log.length = numel(log.event);


%----------------------------------------------
% CLEAR LOG
%----------------------------------------------

function log = log_clear(log)

log.event = empty(event_create);

log.length = 0;





