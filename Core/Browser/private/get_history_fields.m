function fields = get_history_fields(mode)

fields = fieldnames(history_create);

switch (mode)
	
	case ('set'), fields = setdiff(fields,'created');
	
	case ('get'), % nothing to do
		
	otherwise, error('Unrecognized get fields mode.');
		
end

fields = fields(:);
