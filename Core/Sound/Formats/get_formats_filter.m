function filter = get_formats_filter(format)

% get_formats_filter - create file filter from formats
% ----------------------------------------------------
%
% filter = get_formats_filter(format)
%
% Input:
% ------
%  format - sound file format array
%
% Output:
% -------
%  filter - file filter as used in 'uigetfile'

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% set default format list
%--

if (nargin < 1)
	format = get_formats; 
end

%-------------------------------------------------
% CREATE FILE FILTERS
%-------------------------------------------------

%----------------------------------
% FORMAT SPECIFIC FILTERS
%----------------------------------

for k = 1:length(format)
	
	%--
	% compile extension strings into the right format
	%--
	
	t1 = lower(strcat('*.',format(k).ext));
	t2 = upper(t1);
	
	t = {t1{:}, t2{:}};
	
	str = t{1};
	
	for j = 2:length(t)
		str = [str, '; ', t{j}];
	end
		
	%--
	% build file filter specification using extensions and names of formats
	%--
	
	filter{k + 1,1} = str;
	filter{k + 1,2} = format(k).name;
	
end

%----------------------------------
% ALL SOUND FILES FILTER 
%----------------------------------

str = filter{2,1};

for k = 2:length(format)
	str = [str, '; ', filter{k + 1,1}];
end

filter{1,1} = str;
filter{1,2} = 'All Sound Files';

%----------------------------------
% ALL FILES FILTER
%----------------------------------

n = length(format) + 2;

filter{n,1} = '*.*';
filter{n,2} = 'All Files';

