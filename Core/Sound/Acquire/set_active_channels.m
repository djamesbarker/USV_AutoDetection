function channels = set_active_channels(ai, desired_channel_names)

[N, names, IDs] = num_channels(ai);

adapter = find_adapter(ai);

desired_channels = cell_find(names, desired_channel_names);

delete(ai.channel);

if ~strcmp(adapter.type, 'winsound')
	
	%--
	% Normal DAQ behavior, channels are independant
	%--

	if ~isempty(desired_channels)

		addchannel(ai, IDs(desired_channels));

	end			

else

	%--
	% Winsound Driver behavior, sequentially added/removed channels
	%--

	indexes = 1:max(desired_channels);

	if ~isempty(indexes)

		addchannel(ai, indexes);

	end

end
