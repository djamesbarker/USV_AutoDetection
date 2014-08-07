function set_user_data(obj, name, value)

d = get(obj, 'UserData');

if ~isstruct(d)
	
	d = struct;
	
end

d = setfield(d, name, value);

set(obj, 'UserData', d);
