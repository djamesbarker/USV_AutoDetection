function [page, scan] = get_scan_page(scan, duration, position)

% get_scan_page - get page from scan
% ----------------------------------
%
% [page, scan] = get_scan_page(scan, duration, position)
%
% Input:
% ------
%  scan - scan
%  duration - page duration
%  position - page position
%
% Output:
% -------
%  page - scan page

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

% TODO: reorganize this code and add some comments

%--
% handle input
%--

if (nargin < 3)
	position = scan.position;
end

if (nargin < 2)
	duration = scan.page.duration;	
end

if (position >= 1)
	page = []; return;
end

% TODO: handle negative position input

%--
% get page from scan
%--

ix = find(position + eps > scan.progress, 1, 'last');

offset = position - scan.progress(ix);

page.start = scan.start(ix) + offset * scan.duration;

[page.duration, type] = min([duration, (scan.stop(ix) - page.start)]);

% TODO: figure out why this is needed

if (page.duration < eps)
	page = []; return;
end

%--
% update scan position and last page
%--

switch type
	
	case 1
		
		page.full = 1;
		
		scan.position = scan.position + (1 - scan.page.overlap) * (page.duration / scan.duration);
		
	case 2
		
		page.full = 0;
		
		scan.position = scan.position + (page.duration / scan.duration) + eps;
		
end

scan.position = min(1, scan.position);

scan.last_page = page;

%--
% compute page interval type from parent interval type, page start offset, and fullness of page
%--

% NOTE: this may be the most unintelligible line of code in the whole project

page.interval = (offset <= 2 * eps) * mod(scan.interval(ix), 2) + 2 * (~page.full) * (scan.interval(ix) > 1); 



