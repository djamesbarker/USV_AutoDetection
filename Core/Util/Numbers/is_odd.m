function value = is_odd(in, strict)

% is_odd - test for odd property in numeric array
% -----------------------------------------------
%
% value = is_odd(in, strict) 
%
% Input:
% ------
%  in - numbers
%  strict - indicator
%
% Output:
% -------
%  value - indicator

if nargin < 2
	strict = 0;
end 

if strict 

	fraction = in - round(in);
	
	if any(fraction(:))
		error('Strict evaluation required input consist of integers.');
	end

end

value = mod(in, 2);
