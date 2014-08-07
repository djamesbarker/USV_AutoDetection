function scan = scan_create(start, stop, duration, overlap, interval)

% scan_create - create scan structure for paging
% ----------------------------------------------
%
% scan = scan_create(start, stop, duration, overlap, interval)
%
% Input:
% ------
%  start - scan block starts
%  stop - scan block stops
%  duration - page duration
%  overlap - page overlap
%  interval - interval indicators for blocks
%
% Output:
% -------
%  scan - scan

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

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% set default overlap and empty duration
%--

if ((nargin < 4) || isempty(overlap))
	overlap = 0;
end

if ((nargin < 3) || isempty(duration))
	duration = [];
end

%--
% align and check start and stop times
%--

start = start(:); stop = stop(:);

if (length(start) ~= length(stop))
	error('Start and stop time vectors need matching length.');
end

if (any(start >= stop))
	error('Start times must happen before stop times.');
end

%--
% set and check default interval indicators
%--

if (nargin < 5)
	interval = zeros(size(start));
end

interval = interval(:);

if (length(interval) ~= length(start))
	error('Start and interval vectors need matching length.');
end

%--------------------------
% CREATE SCAN
%--------------------------

%--
% start and stop times, and interval indicators
%--

scan.start = start;

scan.stop = stop;

scan.interval = interval;

%--
% current position
%--

% NOTE: position is fraction of traversal through scan

scan.position = 0;

scan.duration = sum(stop - start);

scan.progress = cumsum([0; stop - start]) / scan.duration;

%--
% page configuration
%--

scan.page.duration = duration;

scan.page.overlap = overlap;

%--
% adaptation fields
%--

scan.adapt = '';

scan.tol = 0.05;

% NOTE: this is last page extracted

scan.last_page = [];
