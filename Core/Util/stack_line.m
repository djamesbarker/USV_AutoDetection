function str = stack_line(stack, root, short) 

% stack_line - create a linked description for a stack line
% ---------------------------------------------------------
%
% str = stack_line(stack, root, short)
%
% Input:
% ------
%  stack - element of stack
%  root - root of tree to consider for linking
%  short - indicator for short form
%
% Output:
% -------
%  str - linked stack line description string

%--
% handle input
%--

if nargin < 3
	short = 0;
end

if nargin < 2 || isempty(root)
	root = xbat_root;
end

%--
% check whether file is in tree to link
%--

% NOTE: the 'root' establishes the code that we want to consider for editing

file = strrep(stack.file, root, '');

link = ~isequal(file, stack.file);

%--
% build stack line string
%--

% TODO: this should be made clearer

file = strrep(file, matlabroot, '(matlabroot)');

if short
	[p1, p2, p3] = fileparts(stack.file); file = [p2, p3];
else
	if link
		file = ['(xbat_root)', file];
	end
end

str = [file, ' at line ', int2str(stack.line)];

if link
	str = ['In <a href="matlab:opentoline(''', stack.file, ''',', int2str(stack.line), ')">', str, '</a>'];
else
	str = ['In ', str];
end
