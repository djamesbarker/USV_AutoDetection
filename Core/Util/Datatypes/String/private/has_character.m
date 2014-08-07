function value = has_character(str, value)

% has_character - test for presence of character in string
% --------------------------------------------------------
%
% value = has_character(str, value)
%
% Input:
% ------
%  str - string
%  value - character
%
% Output:
% -------
%  value - result of test

% NOTE: this test is faster than the 'iscellstr' test

if ischar(str)
	
	value = ~isempty(find(str == value, 1)); return;
end

if iscellstr(str)
	
	value = false(size(str));
	
	for k = 1:numel(str)
		value(k) = has_character(str{k});
	end
	
	return;
end

error('Input must be string or string cell array.');
