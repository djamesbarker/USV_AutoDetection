function [interval_str, page_str] = scan_info_str(scan, sound, verb)

% TODO: allow getting of interval and page information separately

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

if nargin < 3
	verb = 0;
end

%--
% initialize scan information string
%--

interval_str = cell(0);

page_str = cell(0);

if isempty(scan.start)
	return;
end

if verb

	%--
	% display scan duration and interval information
	%--

	interval_str{end + 1} = ['SCAN: (', sec_to_clock(scan.duration), ')'];
	interval_str{end + 1} = '-----';

end
	
for k = 1:length(scan.start)
	interval_str{end + 1} = ['[', sec_to_clock(scan.start(k)), ' - ', sec_to_clock(scan.stop(k)), ']'];
end

if nargout < 2
	return;
end

%--
% display page information
%--

if verb

	page_str{end + 1} = '';

	page_str{end + 1} = ['PAGES: (', sec_to_clock(scan.page.duration), ')'];

	if (scan.page.overlap)
		page_str{end} = [page_str{end}, ' (', sec_to_clock(scan.page.overlap * scan.page.duration), ')'];
	end 

	page_str{end + 1} = '------';

end

% NOTE: set scan position to zero to get all pages

scan.position = 0; [page, scan] = get_scan_page(scan);

while ~isempty(page)
	page_str{end + 1} = page_to_str(page); [page, scan] = get_scan_page(scan);
end
