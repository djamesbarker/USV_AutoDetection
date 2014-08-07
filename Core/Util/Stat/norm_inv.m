function x = norm_inv(p)

% norm_inv - inverse of normal cumulative

x = -sqrt(2)* erfcinv(2 * p);
