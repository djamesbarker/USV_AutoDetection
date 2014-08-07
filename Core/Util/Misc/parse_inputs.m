function [in, field, value] = parse_inputs(in,varargin)

% parse_inputs - put field value pairs into a structure
% -----------------------------------------------------
%
% [out, field, value] = parse_inputs(in, 'field', value, ...)
%
% Input:
% ------
%  in - struct to update
%  field - field name
%  value - field value
%
% Output:
% -------
%  out - updated struct
%  field - fields
%  value - values

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

% NOTE: consider renaming this function

%--------------------------------
% HANDLE INPUT
%--------------------------------

%--
% check input is scalar struct
%--

if ~isstruct(in) || (length(in) > 1)
	error('Input must be scalar struct.');
end

%--
% check pairing of field and value pairs
%--

n = length(varargin);

if n < 1
	field = {}; value = {}; return;
end

if mod(n, 2)
	error('Input fields and values are not properly paired.');
end

%--------------------------------
% PARSE AND UPDATE
%--------------------------------

%--
% separate and check field value pairs
%--

n = n / 2; field = cell(1, n); value = cell(1, n);

for k = 1:n

	field{k} = varargin{(2 * k) - 1}; value{k} = varargin{2 * k};
	
	if ~ischar(field{k})
		error('Field names must be strings.');
	end
	
end

%--
% update input struct fields 
%--

for k = 1:n

	%--
	% skip unrecognized fields
	%--
	
	if ~isfield(in, field{k})
		disp(['WARNING: Non-matching input field ''', field{k}, ''' ignored.']); continue;
	end
	
	%--
	% update fields
	%--
	
	switch field{k}
		
		% NOTE: implement 'notes' as a decoration, similar to tags
		
		case 'tags'
			try
				in = set_tags(in, value{k});
			catch
				nice_catch(lasterror, 'Failed to set tags.');
			end
			
		otherwise
			in.(field{k}) = value{k};
	
	end

end
