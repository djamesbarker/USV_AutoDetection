function p = norm_cdf(x)

% norm_cdf - normal cumulative function

p =	0.5 * erfc(-x / sqrt(2));
