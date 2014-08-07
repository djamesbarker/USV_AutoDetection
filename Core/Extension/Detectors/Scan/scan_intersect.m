function scan = scan_intersect(varargin)

% scan_intersect - intersect scans
% --------------------------------
%
% scan = scan_intersect(scan_1, ... ,scan_n)
%
% Input:
% ------
%  scan_k - scan to intersect
%
% Output:
% -------
%  scan - intersection scan

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
% rename input for clarity
%--

scans = varargin;

%--
% handle variable number of input scans
%--

switch (length(scans))
	
	case (1), scan = scans{1}; return;

	case (2), scan = intersect_scans(scans{1}, scans{2});
	
	otherwise
		
		% NOTE: multiple scan intersection is iterative, consider direct implementation
		
		scan = scans{1};
		
		for k = 2:length(scans)
			
			scan = intersect_scans(scan, scans{k});
			
			if isempty(scan.start)
				return;
			end
			
		end
		
end


%---------------------------------
% INTERSECT_SCANS
%---------------------------------

function scan = intersect_scans(scan1, scan2)

% TODO: factor interval intersection, consider generalization

%--
% sort and label interval edges
%--

start = [scan1.start; scan2.start];

stop = [scan1.stop; scan2.stop];

interval = [scan1.interval; scan2.interval];

[edges, ix] = sort([start; stop]);

labels = [ones(size(start)); -ones(size(stop))]; labels = labels(ix);

intervals = [interval; interval]; intervals = intervals(ix);

%--
% get new block starts from indicator sum
%--

ix = find(cumsum(labels) == 2);

%--
% get intersection scan ingredients
%--

if (isempty(ix))
	start = []; stop = [];
else
	start = edges(ix,1); stop = edges(ix + 1,1);
end

% NOTE: compute new interval code based on start and stop source interval type

interval = mod(intervals(ix), 2) + 2 * (intervals(ix + 1) > 1);

% NOTE: min is the logical equivalent of intersection

duration = min(scan1.page.duration, scan2.page.duration);

overlap = min(scan1.page.overlap, scan2.page.overlap);

% NOTE: pick out bad intervals from ingredients  before packing 

bad = [start == stop]; start(bad) = []; stop(bad) = []; interval(bad) = [];

%--
% pack intersection scan
%--

scan = scan_create(start, stop, duration, overlap, interval);
