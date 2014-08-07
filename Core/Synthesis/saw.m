function y = saw(x)

x = mod(x, 2*pi);

y = (x - pi) ./ pi;
