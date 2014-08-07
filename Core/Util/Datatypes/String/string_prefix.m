function prefix = string_prefix(varargin)

% string_prefix - computation
% ---------------------------
%
% prefix = string_prefix(str1, ... , strk)
%
% Input:
% ------
%  str1, ... , strk - strings
%
% Output:
% -------
%  prefix - string

%--
% get number of strings and maximum length
%--

count = numel(varargin); len = zeros(1, count);

for k = 1:count
	len(k) = numel(varargin{k});
end

len = max(len); 

%--
% create numeric matrix to assist in prefix computation
%--

C = zeros(count, len);

for k = 1:count
	current = varargin{k}; current(end + 1:len) = ' ';
	
	C(k, :) = double(current);
end

%--
% compute stop index for prefix and output prefix
%--

stop = find(sum(abs(diff(C))), 1) - 1;

prefix = varargin{1}(1:stop);
	
