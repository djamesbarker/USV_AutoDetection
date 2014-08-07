function value = next_even(value, helper)

if nargin < 2
	helper = @round; 
end

value = helper(value); 

value = value + mod(value, 2);
