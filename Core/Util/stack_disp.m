function stack_disp(stack)

% stack_disp - linked display of stack
% ------------------------------------
%
% stack_disp(stack)
%
% NOTE: you can get a stack from 'dbstack'
%
% See also: dbstack

if ~nargin || isempty(stack)
	stack = dbstack(1, '-completenames');
end

for k = 1:length(stack)
	disp(['   ', int2str(k), '. ', stack_line(stack(k))]);
end
