function h = estimate_log_noise(log, parameter, context)

h = [];

noise = [];

event = log.event;

if isempty(event)
	return;
end

% NOTE: we will run out of memory doing this.

for k = 1:length(event)
	
	samples = sound_read(context.sound, 'time', event(k).time(1), event(k).duration, event(k).channel);
	
	noise = [noise;samples];
	
end

h = aryule(noise, parameter.order);
