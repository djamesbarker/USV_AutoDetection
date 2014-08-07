function lines = str_wrap(str, width)

% str_wrap - wrap string into paragraph
% -------------------------------------
%
% lines = str_wrap(str, width)
%
% Input:
% ------
%  str - input string
%  width - line length (def: 72)
%
% Output:
% -------
%  lines - wrapped string lines

%--
% set line length
%--

if nargin < 2
	width = 72;
end

%--
% get blanks and compute breaks
%--

% TODO: this is not wrapping tightly enough, or the last line properly

ix = findstr(str, ' ');

spill = mod(ix, width);

b = [1,  ix(spill(1:end - 1) > spill(2:end)),  length(str)];

%--
% split string 
%--

lines{1} = str(b(1):b(2));

for k = 2:length(b) - 1
	lines{end + 1} = str(b(k) + 1:b(k + 1));
end

%--
% display string if no output
%--

if ~nargout

	% NOTE: display lines and also supress output
	
	for k = 1:length(lines)
		disp(lines{k});
	end

	clear lines;
	
end




