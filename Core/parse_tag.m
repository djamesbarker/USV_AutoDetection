function info = parse_tag(str, sep, field)

% parse_tag - parse tag string for xbat figures
% ---------------------------------------------
%
% info = parse_tag(str, sep, field)
%
% Input:
% ------
%  str - tag string
%  sep - separator between string fields
%  field - names of fields to extract
%
% Output:
% -------
%  info - tag string info structure

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
% $Revision: 5975 $
% $Date: 2006-08-07 18:19:44 -0400 (Mon, 07 Aug 2006) $
%--------------------------------

% TODO: develop field value version of this function that gets fields from tag

% TODO: remove defaults, these entangle code that should be independent

% TODO: send note to mathworks on strread, length of separator problem

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% set default fields
%--

% NOTE: these fields are used in the sound browser figure tags

if (nargin < 3) || isempty(field)
	field = {'type', 'user', 'library', 'sound'};
end

%--
% return empty structure on empty tag string
%--

if isempty(str)	
		
	%--
	% put fieldnames into row vector, interleave empty cells, and create struct
	%--
	
	% NOTE: this is an interesting use of comma-separated lists

	field = field(:)'; 
	
	field = [field; cell(1, length(field))];
	
	info = struct(field{:});
	
	return;
	
end

%--
% set default separator
%--

if (nargin < 2) || isempty(sep)
	sep = '::';
end

%------------------------------------------
% PARSE TAG STRING
%------------------------------------------

%--
% get values from tag
%--

% NOTE: parseable strings are of the form 'field sep field sep ... sep field'

value = str_split(str, sep);

%--
% pack values
%--

for k = 1:min(length(value), length(field))
	info.(field{k}) = value{k};
end

% NOTE: make sure we return all fields we were asked for

if length(field) > length(value)
	
	for k = (length(value) + 1):length(field)
		info.(field{k}) = [];
	end
	
end
