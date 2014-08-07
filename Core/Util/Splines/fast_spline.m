function b = fast_spline(x, precision)

x = x(:);

if nargin < 2 || isempty(precision)
	precision = length(x);
end

precision = min(precision, length(x));

b = fast_spline_mex(x, precision);
