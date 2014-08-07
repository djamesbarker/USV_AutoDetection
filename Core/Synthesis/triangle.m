function y = triangle(x)

x = mod(x, 2*pi);

y = 2 * abs((x - pi) ./ pi) - 1;
