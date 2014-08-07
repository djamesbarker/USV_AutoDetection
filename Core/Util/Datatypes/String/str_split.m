function [parts, count] = str_split(str, sep, fun, trim)

% str_split - split strings using delimiter or size
% -------------------------------------------------
%
% [parts, count] = str_split(str, sep, fun, trim)
%
% Input:
% ------
%  str - string to split
%  sep - separator (def: space)
%  fun - fragment callback (def: no callback)
%  trim - option to trim fragments (def: 1)
%
% Output:
% -------
%  parts - string tokens as defined by delimiter
%  count - token count
%
% NOTE: an integer separator will split string into parts of that size, excepting the last 

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% set trim and no callback default
%--

if nargin < 4
	trim = 1;
end

if nargin < 3
	fun = [];
end

%--
% set space as default delimiter
%--

if nargin < 2
	sep = ' ';
end

%--
% handle special trivial cases
%--

if isempty(str)
    parts = {}; count = 0; return;
end

% NOTE: return full string as cell if delimiter is empty

if isempty(sep)
	parts = {str}; count = 1; return
end

%-----------------------------------
% SPLIT STRING
%-----------------------------------

%--
% separate string by part length
%--

if ~ischar(sep) && round(sep) == sep
	
	parts = {};
	
	for k = 1:floor(numel(str)/sep)
		start = 1 + (k - 1) * sep; stop = start + sep - 1; parts{end + 1} = str(start:stop);
	end
	
	start = 1 + k * sep; stop = min(start + sep - 1, numel(str));
	
	if ~isempty(start:stop)
		parts{end + 1} = str(start:stop);
	end
	
	return;
end

%--
% separate string using delimiter
%--

n = length(sep);

switch n
	
	%--
	% single character separator
	%--
	
	case 1	
		% NOTE: this is only worthwhile if 'strread' is generally much faster
		
		% NOTE: 'strread' fails for the '\' separator, maybe for others
		
		try
			parts = strread(str, '%s', 'delimiter', sep);
		catch
			parts = str_split_int(str, sep, n);
		end
		
	%--
	% multiple character separator
	%--
	
	otherwise

		parts = str_split_int(str, sep, n);
end

%--
% output token count
%--

if nargout > 1
	count = numel(parts);
end

%--
% trim and then apply callback if needed
%--

% NOTE: the order of course is not trivial, however the callback should have the last word as default? 

if trim
	for k = 1:numel(parts)
		parts{k} = strtrim(parts{k});
	end
	
% 	parts = iterate(@strtrim, parts);
end

if ~isempty(fun)
	if iscell(fun)
		parts = iterate(fun{1}, parts, fun{2:end});
	else
		parts = iterate(fun, parts);
	end
end


%-----------------------------------
% STR_SPLIT_INT
%-----------------------------------

function parts = str_split_int(str, sep, n)

ix = findstr(str, sep);

if isempty(ix)
	parts = {str}; return;
end

ix1 = [1, ix + n];

ix2 = [ix - 1, length(str)];

parts = cell(size(ix(1)));

for k = 1:length(ix1)
	parts{k} = str(ix1(k):ix2(k));
end
