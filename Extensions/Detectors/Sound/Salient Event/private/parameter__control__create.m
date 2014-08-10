function control = parameter__control__create(parameter, context)

% ELP DETECTOR - parameter__control__create

control = empty(control_create);

control(end + 1) = control_create( ...
	'name','Sound Parameters', ...
	'string','Sound Parameters', ...
	'align','left', ...
	'style','separator' ...
	);

control(end + 1) = control_create( ...
	'name','alpha', ...
	'alias','Percent Noise Removed', ...
    'min',0, ...
	'max',1, ...
	'style','slider' ...
);
control(end + 1) = control_create( ...
	'name','min_freq', ...
	'alias','Lower freq. bound (Hz)', ...
    'min',1, ...
	'max',(context.sound.samplerate/2), ...
	'style','slider', ...
    'value', parameter.min_freq ...
);
control(end + 1) = control_create( ...
	'name','max_freq', ...
	'alias','Upper freq. bound (Hz)', ...
    'min',1, ...
	'max',(context.sound.samplerate/2), ...
	'style','slider', ...
    'value', parameter.max_freq ...
);

%--
% Separator
%--
control(end + 1) = control_create( ...
	'name','Event Parameters', ...
	'string','Event Parameters', ...
	'align','left', ...
	'style','separator' ...
	);

control(end + 1) = control_create( ...
	'name','min_dur', ...
	'alias','Minimum duration (s)', ...
    'min',0, ...
	'max',5, ...
	'style','slider', ...
    'value', parameter.min_dur ...
);
control(end + 1) = control_create( ...
	'name','min_bw', ...
	'alias','Minimum bandwidth (Hz)', ...
    'min',1, ...
	'max',3000, ...
	'style','slider', ...
    'value', parameter.min_bw ...
);
control(end + 1) = control_create( ...
	'name','score', ...
	'alias','Threshold', ...
    'min',0, ...
	'max',20, ...
	'style','slider' ...
);
%%%



