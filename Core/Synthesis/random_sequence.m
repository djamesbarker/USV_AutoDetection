function x = random_sequence(startix, n, fun, state)

if nargin < 4
	state = 0;
end

if nargin < 3
	fun = @randn;
end

%--
% set initial state
%--

fun('state', state);

%--
% setup
%--

stopix = startix + n;

pariod = 10000;

%--
% iterate
%--

x = [];

n_discard = mod(startix, period);

n_read = period - n_discard;

state_jump = floor(startix / period);

fun('state', state + state_jump);

ignore = fun(n_discard, 1);

x = fun(n, 1);



	
	

