function ix = find_struct(in, varargin)

% find_struct - elements matching conditions
% ------------------------------------------
%
% ix = find_struct(in, field, value, ... )
%
% Input:
% ------
%  in - struct array
%  field - to match or test
%  value - match for field or indicator function
%
% Output:
% -------
%  ix - linear index into input array
%
% See also: find, sub2ind, ind2sub

%--
% handle filter conditions
%--

if isempty(varargin)
	ix = 1:numel(in); return;
end

[field, value] = get_field_value(varargin, fieldnames(in));

if isempty(field)
	return;
end 

% NOTE: determine whether value test is an indicator function

fun = zeros(size(value));

for k = 1:numel(value)
	
	if isa(value{k}, 'function_handle')
		fun(k) = 1; continue;
	end
	
	if iscell(value{k}) && isa(value{k}{1}, 'function_handle')
		fun(k) = 2;
	end
end

%--
% filter and keep track of selected indices
%--

ix = 1:numel(in);

for j = numel(in):-1:1
	
	for k = 1:numel(field)
		
		switch fun(k)
			case 0
				keep = isequal(in(j).(field{k}), value{k});
				
			case 1
				keep = value{k}(in(j).(field{k}));
				
			case 2
				keep = value{k}{1}(in(j).(field{k}), value{k}{2:end});
		end
		
		if keep
			continue;
		end
		
		ix(j) = [];
	end
	
end
