function in = struct_simplify_values(in, skip, opt)

% struct_simplify_values - simplify field values 
% ----------------------------------------------
%
% in = struct_simplify_values(in, skip, opt)
%
% Input:
% ------
%  in - struct
%  skip - fields to skip
%  opt - field value simplification options
%
% Output:
% -------
%  in - struct with simplified field values

%--
% handle input
%--

% NOTE: most of this configuration if not typically used

if nargin < 3
	opt.flatten = 1; opt.free_strings = 1; opt.eval_digits = 1;
end

if ~nargin
	in = opt; return;
end

% NOTE: by default skip nothing

if nargin < 2
	skip = {};
end 

if ~is_scalar_struct(in)
	error('Scalar struct input is required.');
end

%--
% simplify field values
%--

if opt.flatten
	in = flatten(in);
end

field = fieldnames(in); 

% NOTE: we remove skip fields from consideration

if ~isempty(skip)
	field = setdiff(field, skip);
end

for k = 1:numel(field)
	
	current = in.(field{k});
	
	% NOTE: if we find a scalar string cell array and we are asked to free strings, extract string from cell
	
	if opt.free_strings && iscellstr(current) && (numel(current) == 1)
		current = current{1};
	end
	
	% NOTE: the only further simplification may be evaluating digit strings
	
	if ~opt.eval_digits || ~ischar(current)
		continue;
	end
	
	% NOTE: evaluate pure digit string

	% TODO: consider if we can do more than this
	
	if all(isstrprop(current, 'digit'))
		current = eval(current);
	end
		
	in.(field{k}) = current;

end
		
if opt.flatten
	in = unflatten(in);
end

