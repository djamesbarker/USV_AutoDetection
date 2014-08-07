function value = exist(fun) 

% exist - test function handle points to a valid function
% -------------------------------------------------------
%
% value = exist(fun)
%
% Input:
% ------
%  fun - function handle
%
% Output:
% -------
%  value - indicator
    
% NOTE: we check that the function handle information points to a file

info = functions(fun); value = ~isempty(info.file);

% NOTE: double check when the value is negative, the previous test misses built-in functions

if ~value
	value = ~isempty(which(info.function));
end
