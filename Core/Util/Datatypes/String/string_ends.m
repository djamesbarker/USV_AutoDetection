function value = string_ends(str, pat, fun, n)

% string_ends - indicate if string ends with pattern
% --------------------------------------------------
%
% value = string_ends(str, pat, fun)
%
% Input:
% ------
%  str - string or string cell array
%  pat - pattern
%  fun - for compare (default: @strcmp)
%
% Output:
% -------
%  value - indicator
%
% See also: string_begins, string_contains

% NOTE: using this approach this function returns a logical vector rather than indices

% NOTE: we get length of pattern if needed to streamline iteration

%--
% handle input
%--

if nargin < 4
	n = numel(pat);
end

if nargin < 3
	fun = @strcmp;
end

%--
% handle multiple strings
%--

if iscell(str)
	value = false(size(str));
	
	for k = 1:numel(str)
		value(k) = string_ends(str{k}, pat, fun, n);
	end
	
	return;
end

%--
% check for occurence of pattern and indicate
%--

if numel(str) < n
	value = false;
else
	value = fun(pat, str(end - n + 1:end));
end
