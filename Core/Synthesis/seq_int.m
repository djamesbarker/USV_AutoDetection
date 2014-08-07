function X = seq_int(x, method)

if nargin < 2 || isempty(method)
	method = 'nearest';
end

switch (method)
	
	case('nearest')
		
		X = cumsum(x);
		
	case('linear')
		
		x = x(:);
		
		X = cumsum((x + [0;x(1:end-1)]) / 2);
		
	case('spline')
		
		fun = @(t) interp1(x, t, 'spline', 'extrap');
		
		X = zeros(1, length(x));
		
		for j = 1:length(x)
			
			X(j) = quad(fun, j - 1, j);
			
		end
		
		X = cumsum(X);
		
end
