function [field, value] = get_field_value(args, allow)

% get_field_value - get_field value pairs from cell array
% -------------------------------------------------------
%
% [field, value] = get_field_value(args, allow)
%
% Input:
% ------
%  args - cell array of field value pairs
%  allow - field names allowed
%
% Output:
% -------
%  field - field names cell array
%  value - values cell array

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
% $Revision: 6863 $
% $Date: 2006-09-30 12:44:51 -0400 (Sat, 30 Sep 2006) $
%--------------------------------

% TODO: packing into struct

% TODO: partial case-insensitive match when allowed fields are provided

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% set default allow anything
%--

if (nargin < 2)
	allow = {};
end

%--
% handle empty input
%--

if isempty(args)
	field = {}; value = {}; return;	
end

%--
% check for cell input of even length
%--

if ~iscell(args)
	error('Input must be of type cell.');
end

if mod(length(args), 2)
	error('Input cell array must be of even length.');
end

%---------------------------------------------
% GET FIELDS AND VALUES
%---------------------------------------------

%--
% separate putative fields and values
%--

field = args(1:2:end); value = args(2:2:end);

%--
% check that field names are strings
%--

if ~iscellstr(field)
	error('Contents of odd indexed cells must be strings.');
end

%--
% check for allowed fields
%--

% NOTE: consider ignoring the not allowed field

if ~isempty(allow)
	
	for k = 1:length(field)
		
		if ~ismember(field{k}, allow)
			error(['Field ''' field{k} ''' is not an allowed field.']);
		end

	end

end

%--
% sort the field value pairs by field names
%--

[field, ix] = sort(field);

value = value(ix);
	
