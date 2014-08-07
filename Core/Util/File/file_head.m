function [head, offset] = file_head(file, n)

% file_head - the first few lines of a file
% -----------------------------------------
%
% [head, offset] = file_head(file, n)
%
% Input:
% ------
%  file - to scan
%  n - number of lines
%
% Output:
% -------
%  head - lines
%  offset - in bytes from start of file
%
% See also: file_tail, file_readlines

if nargin < 2
	n = 10;
end

fid = fopen(file); k = 0;

while (k < n)
	current = fgetl(fid);
	
	if ischar(current)
		head{k + 1} = current; k = k + 1; %#ok<AGROW>
	else
		break;
	end
end

if nargout > 1
	offset = ftell(fid);
end

fclose(fid);

head = head(:);

