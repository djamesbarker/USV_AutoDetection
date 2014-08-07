function value = get(obj, field)

% convert object to struct

obj = struct(obj);

% get full object as struct

if nargin < 2
	value = obj; return; 
end

% get one field 

if ischar(field) 
	
	if ~isfield(obj, field)
		error(['There is no ''', field, ''' property in the ''interval'' class.']);
	end 
	
	value = obj.(field); return; 

end

% get multiple fields

if iscellstr(field)
	
	value = struct; 
	
	for k = 1:numel(field)

		if ~isfield(obj, field{k})
			error(['There is no ''', field{k}, ''' property in the ''interval'' class.']);
		end

		value.(field{k}) = obj.(field{k});
		
	end
	
	return;
	
end

error('Field input must be a string or string cell array.');

