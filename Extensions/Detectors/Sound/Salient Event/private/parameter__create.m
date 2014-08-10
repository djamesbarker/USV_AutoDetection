function parameter = parameter__create(context)

% ELP DETECTOR - parameter__create

parameter = struct;

parameter.alpha = .15; 
parameter.score = 1.5;

parameter.min_freq = 10;
parameter.max_freq = round(context.sound.samplerate/2);
parameter.min_dur = .5;
parameter.min_bw = 5;