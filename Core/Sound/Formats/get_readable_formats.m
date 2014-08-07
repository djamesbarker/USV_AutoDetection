function format = get_readable_formats(format)

% get_readable_formats - get readable formats
% -------------------------------------------
%
% format = get_readable_formats(format)
%
% Input:
% ------
%  format - list of formats to evaluate
%
% Output:
% -------
%  out - readable formats

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
% get all formats if needed
%--

if nargin < 1
	format = get_formats;
end

%--
% remove non-readable formats
%--

for k = length(format):-1:1
	if isempty(format(k).info) || isempty(format(k).read)
		format(k) = [];
	end
end
