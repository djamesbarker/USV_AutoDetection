function value = eq(fun1, fun2)

% NOTE: this is probably not the fastest operation

n1 = numel(fun1); n2 = numel(fun2);

%--
% arrays of equal size
%--

if n1 == n2
	
	%--
	% scalar
	%--
	
	% NOTE: equal size arrays have scalar as a special case
	
	if n1 == 1
		
		if iscell(fun1)
			fun1 = fun1{1};
		end
		
		if iscell(fun2)
			fun2 = fun2{1};
		end
		
		value = eq_scalar(fun1, fun2); return;
		
	end
	
	%--
	% array
	%--
	
	value = zeros(size(fun1));
	
	for k = 1:n1
		value(k) = eq_scalar(fun1{k}, fun2{k});
	end

%--
% array scalar comparison
%--

else
	
	if min(n1, n2) > 1
		error('Comparison between vectors of unequal size is not possible.');
	end
	
	if n1 == 1
		
		value = zeros(size(fun2));
		
		for k = 1:n2
			value(k) = eq_scalar(fun1, fun2{k});
		end
		
	else
		
		value = zeros(size(fun1));
		
		for k = 1:n1
			value(k) = eq_scalar(fun1{k}, fun2);
		end
		
	end

end


%------------------
% EQ_SCALAR
%------------------

function value = eq_scalar(fun1, fun2)

value = isequal(functions(fun1), functions(fun2));
