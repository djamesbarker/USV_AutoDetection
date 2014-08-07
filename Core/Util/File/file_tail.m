function tail = file_tail(file, n)

% file_tail - the last few lines of a file
% ----------------------------------------
%
% tail = file_tail(file, n)
%
% Input:
% ------
%  file - to scan
%  n - number of lines
%
% Output:
% -------
%  tail - lines
%
% See also: file_head, file_readlines

if nargin < 2
	n = 10;
end

% TODO: create efficient windows version, and make sure output is consistent accross platforms

if ispc
	lines = file_readlines(file); tail = lines(max(1, numel(lines) - n + 1):end);
else
	[status, tail] = system(['tail -n ', int2str(n), ' "', file, '"']);
end
