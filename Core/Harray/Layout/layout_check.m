function [flag, str] = layout_check(layout)

% layout_check - check that layout is valid
% ------------------------------------------
%
% [flag, str] = layout_check(layout)
%
% Input:
% ------
%  layout - layout structure
%
% Output:
% -------
%  flag - validity flag
%  str - error message

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
% $Revision: 976 $
% $Date: 2005-04-25 19:27:22 -0400 (Mon, 25 Apr 2005) $
%--------------------------------

%--
% create persistent units table
%--

persistent PAD_UNITS;

if isempty(PAD_UNITS)
	PAD_UNITS = {'centimeters', 'inches', 'pixels'};
end 

%----------------------------------------------
% HANDLE INPUT
%----------------------------------------------

%--
% handle layout arrays recursively
%--

if length(layout) > 1
	
	for k = 1:length(layout)
		[flag(k),str{k}] = layout_check(layout(k)); str{k} = [int2str(k), '. ', str{k}];
	end
	
	return;
	
end

%----------------------------------------------
% CHECK LAYOUT
%----------------------------------------------

% NOTE: the function returns on the first error found

flag = 1; str = 'Layout is valid.';

%--
% check layout units
%--

if isempty(find(strcmpi(layout.units ,PAD_UNITS), 1))
	flag = 0; str = ['Unrecognized layout units ''', layout.units, '''.']; return;
end

%--
% check layout margins
%--

%--
% check layout rows
%--

m = layout.row.size;

if ~isequal(size(layout.row.frac(:)), [m, 1])
	flag = 0; str = 'Row fraction layout length does not match row size.'; return;
end

if sum(layout.row.frac) ~= 1
	flag = 0; str = 'Row fraction layout does not sum to 1.'; return;
end

if ~isequal(size(layout.row.pad(:)), [m - 1, 1])
	flag = 0; str = 'Row padding layout length does not match row size.'; return;
end

%--
% check layout columns
%--

n = layout.col.size;

if ~isequal(size(layout.col.frac(:)), [n, 1])
	flag = 0; str = 'Column fraction layout length does not match column size.'; return;
end

if sum(layout.col.frac) ~= 1
	flag = 0; str = 'Column fraction layout does not sum to 1.'; return;
end

if ~isequal(size(layout.col.pad(:)), [n - 1, 1])
	flag = 0; str = 'Column padding layout length does not match column size.'; return;
end
