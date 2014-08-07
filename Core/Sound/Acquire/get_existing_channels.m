function [existing_channels existing_hw_channels] = get_existing_channels(ai_obj)

if iscell(ai_obj.channel.index)

	existing_channels = cell2mat(ai_obj.channel.index);

	existing_hw_channels = cell2mat(ai_obj.channel.hwchannel);
	
else

	existing_channels = ai_obj.channel.index;

	existing_hw_channels = ai_obj.channel.hwchannel;
	
end
