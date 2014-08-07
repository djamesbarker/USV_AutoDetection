function [seg, match] = line_split(line, pat)

% line_split - split line using pattern
% -------------------------------------
%
% [seg, match] = line_split(line, pat)
%
% Input:
% ------
%  line - input line
%  pat - split pattern
%
% Output:
% -------
%  seg - line segments, line or string cell array
%  match - line match indicator

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

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set default pattern
%--

% NOTE: this pattern is used in templates

if nargin < 2
	pat = '<%.*%>';
end

%--
% return quickly on empty
%--

% NOTE: there is nothing to match, there is nothing to split

if isempty(line) || isempty(pat)
	seg = line; match = 0; return;
end

%----------------------------------
% SPLIT LINE
%----------------------------------

%--
% match split pattern
%--

mat = reg_exp(line, '<%.*%>');

%--
% split line separating tokens
%--

if isempty(mat.match)
	
	seg = line; match = 0;

else

	%--
	% perform naive split
	%--
	
	seg = cell(0); match = [];
	
	seg{end + 1} = line(1:(mat.start(1) - 1)); match(end + 1) = 0;
	
	seg{end + 1} = line(mat.start(1):mat.end(1)); match(end + 1) = 1;
	
	for k = 2:length(mat.match)
		
		seg{end + 1} = line((mat.end(k - 1) + 1):(mat.start(k) - 1)); match(end + 1) = 0;
		
		seg{end + 1} = line(mat.start(k):mat.end(k)); match(end + 1) = 1;
		
	end

	seg{end + 1} = line((mat.end(end) + 1):end); match(end + 1) = 0;
	
	%--
	% remove effectively empty cells
	%--
	
	for k = length(seg):-1:1
		
		if isempty(seg{k}) || all(isspace(seg{k}))
			seg(k) = []; match(k) = [];
		end 
		
	end
	
end
