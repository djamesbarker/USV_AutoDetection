function out = flatten_struct(in, n, sep)

% flatten_struct - flatten structure
% ----------------------------------
%
% out = flatten_struct(in, level, sep)
%
% Input:
% ------
%  in - arbitrary struct
%  level - levels to flatten (def: -1, flatten all)
%  sep - field separator (def: '__', double underscore)
%
% Output:
% -------
%  out - flat struct
%
% See also: unflatten_struct

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

if length(in) ~= 1
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

flag = 0; field = fieldnames(in);

out = struct;

if isempty(field)
	return;
end

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
