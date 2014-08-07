function scan = page_through(start, stop, duration, overlap)

%--
% handle input
%--

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

if (nargin < 1) || isempty(start)
	start = 10:11:111;
end

if (nargin < 2) || isempty(stop)
	stop = 15:12:125; stop(end) = 137;
end

if (nargin < 3) || isempty(duration)
	duration = 2;
end

if (nargin < 4) || isempty(overlap)
	overlap = 0.25;
end

%--
% create scan
%--

scan = scan_create(start, stop); 

scan.page.duration = duration; scan.page.overlap = overlap;
		
%--
% display scan blocks and pages
%--

disp(' '); disp('SCAN BLOCKS AND PAGES');

k = 1; display_block_header(scan, k);

[page, scan] = get_scan_page(scan); 
	
while ~isempty(page)

	disp([page_to_str(page), ' (', num2str(page.duration, 20), ')']);
	
	if ~page.full
		k = k + 1; display_block_header(scan, k);
	end
	
	[page, scan] = get_scan_page(scan); 
	
end

disp(' ');


%--
% display_block_header
%--

function display_block_header(scan, k)

if k > length(scan.start)
	return;
end

block = [scan.start(k), scan.stop(k)]; str = block_to_str(block); 

disp(' '); disp(str); str_line(str);
