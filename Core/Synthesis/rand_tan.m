function x = rand_tan(varargin)

x = (rand(varargin{:}) * pi) - pi/2;

x(x > 0) = tan(x(x > 0));

x(x < 0) = tan(x(x < 0));

