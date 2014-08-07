function value = has_sessions_enabled(sound)

if ~isfield(sound, 'time_stamp')
	value = 0; return;
end

value = ~isempty(sound.time_stamp) && sound.time_stamp.enable;
