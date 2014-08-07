function [adapter] = find_adapter(in)

adapters = get_adapters;
	
if strcmp(class(in), 'analoginput')

	info = daqhwinfo(in);
	
	device_name = info.DeviceName;

else
	
	device_name = in;
	
end

for ix = 1:length(adapters)

	if (strcmp(adapters(ix).name, device_name))

		adapter = adapters(ix);

		break;

	end

end
