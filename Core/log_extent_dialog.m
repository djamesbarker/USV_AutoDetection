function [ix,dil,row,col] = log_extent_dialog(log,ix,dil,row,col)

% log_extent_dialog - get log browser extent variables
% ----------------------------------------------------
%
% [ix,dil,row,col] = log_extent_dialog(log,ix,dil,row,col)
%
% Input:
% ------
%  log - log structure to display
%  ix - starting index
%  dil - event dilation factor
%  row - rows per page
%  col - columns per page
%
% Output:
% -------
%  ix - starting index
%  dil - event dilation factor
%  row - rows per page
%  col - columns per page

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
% $Revision: 550 $
% $Date: 2005-02-17 23:49:03 -0500 (Thu, 17 Feb 2005) $
%--------------------------------

%--
% handle variable input
%--

if (nargin < 5 | isempty(col))
	col = 4;
end

if (nargin < 4 | isempty(row))
	row = 2;
end

if (nargin < 3  | isempty(dil))
	dil = 3;
end

if (nargin < 2 | isempty(ix))
	ix = 1;
end

%--
% create start index slider description (integer sliders)
%--

start_index = [ix, 1, log.length, 2];

%--
% create rows and columns slider descriptions (integer sliders)
%--

% TODO: this is the source of some of the log browser problems

page_rows = [row, 2, 8, 1/7, 1/7, 2]; 

page_columns = [col, 2, 8, 1/7, 1/7, 2];

%--
% create event dilation slider descriptions (real slider)
%--

event_dilation = [dil, 1.25, 5];

%--
% create input dialog
%--

ans = input_dialog( ...
	{'Start Index', 'Event Dilation', 'Page Rows', 'Page Columns'}, ...
	['XBAT Log  -  ' file_ext(log.file) ' Display'], ...
	[1, 40; 1, 40; 1, 26; 1, 26], ...
	{start_index, event_dilation, page_rows, page_columns} ...
);

%--
% get answers
%--

if (isempty(ans))
	
	ix = [];
	return;
	
else
	
	ix = ans{1};
	dil = ans{2};
	
	% FIXME: rounding at this point is crazy and horrific
	
	row = round(ans{3});
	col = round(ans{4});
	
end

