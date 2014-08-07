function value = is_even(in, strict)

% is_even - test for even property in numeric array
% -------------------------------------------------
%
% value = is_even(in, strict) 
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

value = is_odd(in + 1, strict);
