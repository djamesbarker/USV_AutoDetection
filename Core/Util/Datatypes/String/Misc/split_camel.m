function [result, parts] = split_camel(in, sep)

% split_camel - string
% --------------------
%
% [result, parts] = split_camel(in)
%
% Input:
% ------
%  in - string
%
% Output:
% -------
%  result - string
%  parts - count

%--
% handle input
%--

if nargin < 2
	sep = ' ';
end

if iscell(in)
	[result, parts] = iterate(mfilename, in, sep); return;
end

%--
% get uppers and split camel
%--

start = find(isstrprop(in, 'upper'));

if start(1) ~= 1
	start = [1, start];
end 

stop = [start(2:end) - 1, numel(in)];

result = in(start(1):stop(1));

for k = 2:numel(start)
	result = [result, sep, in(start(k):stop(k))];
end

if nargout > 1
	parts = numel(start);
end
