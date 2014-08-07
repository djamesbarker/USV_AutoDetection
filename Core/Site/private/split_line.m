function [seg, process] = split_line(line, bra, ket)

%--
% set default segment indicators
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

if nargin < 2
	bra = '<%'; ket = '%>';
end

ketoff = length(ket) - 1;

%--
% get processing segment end points
%--

start = strfind(line, bra); stop = strfind(line, ket);

% NOTE: we cannot process this line, so leave as is

if ~length(start) || ~length(stop) || (length(start) ~= length(stop))
	seg = line; process = 0; return;
end

edges = [start; stop];

% NOTE: we cannot process this line, so leave as is

if any(diff(edges(:)) < 0)
	seg = line; process = 0; return;
end

%--
% get segments and processing indicators
%--

seg = {}; process = [];

if start(1) > 1
	seg{end + 1} = line(1:(start(1) - 1)); process(end + 1) = 0;
end

seg{end + 1} = line(start(1):(stop(1) + ketoff)); process(end + 1) = 1;

for k = 2:size(edges, 2)
	
	laststop = stop(k - 1) + ketoff;
	
	if (laststop + 1) < start(k)
		seg{end + 1} = line((laststop + 1):(start(k) - 1)); process(end + 1) = 0;
	end
	
	seg{end + 1} = line(start(k):(stop(k) + ketoff)); process(end + 1) = 1;
	
end

if stop(end) < length(line)
	seg{end + 1} = line((stop(end) + ketoff + 1):end); process(end + 1) = 0;
end


