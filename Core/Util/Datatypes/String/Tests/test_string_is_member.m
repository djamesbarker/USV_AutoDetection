function test_string_is_member

% test_string_is_member - test correctness and performance of 'string_is_member'

strs = {'red', 'green', 'blue', 'cat', 'dog', 'bird'}; n = 1000;

% NOTE: test the multiple string case

disp(' ');

disp('multiple strings in set')

start = clock;
for k = 1:n
	value0 = ismember(strs, strs(1:3));
end
time.builtin = etime(clock, start);

start = clock;
for k = 1:n
	value1 = string_is_member(strs, strs(1:3));
end
time.string = etime(clock, start)

if ~isequal(value0, value1)
	error('Failed test.');
end 

% NOTE: test the single string case

disp('single string not in set')

start = clock;
for k = 1:n
	value0 = ismember('not-in-set', strs);
end
time.builtin = etime(clock, start);

start = clock;
for k = 1:n
	value1 = string_is_member('not-in-set', strs);
end
time.string = etime(clock, start)

if ~isequal(value0, value1)
	error('Failed test.');
end

% NOTE: test the single string case

disp('single string in set')

start = clock;
for k = 1:n
	value0 = ismember(strs(end), strs);
end
time.builtin = etime(clock, start);

start = clock;
for k = 1:n
	value1 = string_is_member(strs(end), strs);
end
time.string = etime(clock, start)

if ~isequal(value0, value1)
	error('Failed test.');
end
