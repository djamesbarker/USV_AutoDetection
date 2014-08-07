function in = struct_inject(in, field, value)

if ischar(value) || numel(value) == 1
	
	for k = 1:numel(in)
		in(k).(field) = value;
	end
	
else
	
	if ~ischar(value) && numel(value) ~= numel(in)
		error('Multiple values must match input size.');
	end

	if iscell(value)
		for k = 1:numel(in)
			in(k).(field) = value{k};
		end
	else
		for k = 1:numel(in)
			in(k).(field) = value(k);
		end
	end
	
end
