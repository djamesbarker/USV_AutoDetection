function scan = get_page_scan(page, duration, overlap)

% get_page_scan - create scan from page
% -------------------------------------
%
% scan = get_page_scan(page, duration, overlap)
%
% Input:
% ------
%  page - page
%  duration - scan page duration
%  overlap - scan page overlap
%
% Output:
% -------
%  scan - page scan

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

%--
% handle input
%--

if (nargin < 3) || isempty(overlap)
	overlap = 0;
end

if (nargin < 2) || isempty(duration)
	duration = page.duration;
end

%--
% create scan
%--

start = page.start; stop = page.start + page.duration;

scan = scan_create(start, stop, duration, overlap);
