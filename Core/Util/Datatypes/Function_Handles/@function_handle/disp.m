function disp(obj)

% disp - display function handle information
% ------------------------------------------
%
% disp(fun)
%
% Input:
% ------
%  fun - handle

% NOTE: this function may have limited usefulness as is, we need to display the literal

name = inputname(1); ans = functions(obj);

if isempty(name)
	disp(ans);
else
	eval([name, ' = ans; disp(', name, ');']);
end

