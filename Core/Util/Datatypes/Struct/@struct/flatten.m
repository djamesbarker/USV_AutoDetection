function out = flatten(in, n, sep)

% flatten - flatten struct
% ------------------------
%
% out = flatten(in, n, sep)
%
% Input:
% ------
%  in - scalar struct
%  n - number of levels to flatten (def: -1, flatten all)
%  sep - field separator (def: '__', double underscore)
%
% Output:
% -------
%  out - flat struct

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
% $Revision: 1597 $
% $Date: 2005-08-17 18:33:05 -0400 (Wed, 17 Aug 2005) $
%--------------------------------

% TODO: extend to struct arrays, this is a non-trivial extension

% TODO: stop recursive flattening if we hit 'namelengthmax'

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% set default separator
%--

if nargin < 3
	sep = '__';
end

%--
% set number of levels to flatten
%--

if (nargin < 2) || isempty(n)
	n = -1;
end

%--
% check for scalar struct
%--

if (length(in) ~= 1)
	error('Scalar struct input is required.');
end

%-------------------------------------------------
% FLATTEN STRUCT
%-------------------------------------------------

switch n
	
	%--
	% flatten recursively
	%--
	
	case -1
		
		[out, flag] = flatten_int(in, sep);
		
		while flag
			[out, flag] = flatten_int(out, sep);
		end
		
	%--
	% identity
	%--
	
	case 0
		
		out = in;
		
	%--
	% fixed number of levels
	%--
	
	otherwise

		[out, flag] = flatten_int(in, sep);
		
		if flag
			
			for k = 2:n
				
				[out, flag] = flatten_int(out, sep); 
				
				if ~flag 
					return;	
				end
				
			end
		end
		
end
			

%------------------------------------------
% FLATTEN_STRUCT_1
%------------------------------------------

function [out, flag] = flatten_int(in, sep)

% flatten_int - internal flatten structure, flatten one level
% -----------------------------------------------------------
%
% [out, flag] = flatten_int(in, sep)
%
% Input:
% ------
%  in - input structure
%
% Output:
% -------
%  out - flatter structure

%--
% flatten struct one level
%--

flag = 0;

field = fieldnames(in);

for k = 1:length(field)
	
	tmp = in.(field{k});

	if isstruct(tmp) && (length(tmp) == 1)
		
		%--
		% flag change in struct
		%--
		
		flag = 1;
		
		%--
		% get field fields and flatten field
		%--
		
		tmp_field = fieldnames(tmp);
		
		% NOTE: we string together the level fields with a double underscore

		for j = 1:length(tmp_field)
			out.([field{k}, sep, tmp_field{j}]) = tmp.(tmp_field{j});
		end
		
	%--
	% output other fields unchanged
	%--
	
	else
		
		out.(field{k}) = tmp;
		
	end
	
end
