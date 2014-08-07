function [val] = get_user_data(obj, name)

val = [];

if nargin < 2 || isempty(name)
	
	val = obj.UserData;
	
	return;
	
end

if isfield(obj.userdata, name)
	
	val = getfield(obj.UserData, name);
	
end
