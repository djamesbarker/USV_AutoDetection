function control = parameter__control__create(parameter, context)

% FIND GROUPS - parameter__control__create

control = empty(control_create);

control(end + 1) = control_create( ... 
	'name', 'gap', ...
	'style', 'edit', ... 
	'type', 'time', ...
	'value', sec_to_clock(parameter.gap) ...
);
