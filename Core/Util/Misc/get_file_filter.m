function filter = get_file_filter(ext,type,name,all)

% get_file_filter - build file filter specifications
% --------------------------------------------------
%
% filter = get_file_filter(ext,type,name,all)
%
% Input:
% ------
%  ext - file extensions
%  type - file types
%  name - name of type class
%  all - include all files filter flag
%
% Output:
% -------
%  filter - file filter specification

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

% TODO: this code needs testing, then use it within get_formats_filter

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set default all
%--

if (nargin < 4)
	all = 1;
end

%--
% set default type name
%--

if (nargin < 3)
	name = [];
else
	if (~ischar(name))
		error('File type class name must be a string.');
	end
end

%--
% check extension and type input
%--

if (ischar(ext) && ischar(type))
	
	ext = {{ext}}; type = {type};	
	
elseif (iscell(ext) && iscellstr(type) && (numel(ext) == numel(type)))
		
	% NOTE: the extension structure may be a cell array within a cell
	
else
	
	error('Extension and type input must strings or string cell arrays of equal length.');

end

%----------------------------------
% TYPE SPECIFIC FILTERS
%----------------------------------

for k = 1:length(type)
	
	%--
	% compile extension strings into the right format
	%--
	
	t1 = lower(strcat('*.',ext{k})); t2 = upper(t1);
	
	t = {t1{:}, t2{:}};
	
	str = t{1};
	
	for j = 2:length(t)
		str = [str, '; ', t{j}];
	end
		
	%--
	% build file filter specification using extensions and names of formats
	%--
	
	filter{k + 1,1} = str;
	
	filter{k + 1,2} = type{k};
	
end

%----------------------------------
% ALL TYPES FILES FILTER 
%----------------------------------

if (~isempty(name))

	str = filter{2,1};

	for k = 2:length(type)
		str = [str, '; ', filter{k + 1,1}];
	end

	filter{1,1} = str;
	filter{1,2} = ['All ', name, ' Files'];

else
	
	filter(1,:) = [];

end

%----------------------------------
% ALL FILES FILTER
%----------------------------------

% NOTE: optionally include all files filter

if (all)

	n = size(filter,1);
	
	filter{n + 1,1} = '*.*';
	filter{n + 1,2} = 'All Files';
	
end
