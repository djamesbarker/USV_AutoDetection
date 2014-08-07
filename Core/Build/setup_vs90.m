function [status, result] = setup_vs90

% setup_vs90 - tools, by updating the system path
% -----------------------------------------------
%
% [status, result] = setup_vs90
%
% Output:
% -------
%  status - code
%  result - string 

% NOTE: nothing happens if we are not a PC

if ~ispc
	status = 0; result = 'This is not a PC.'; return;
end

% NOTE: this should fail if the compiler is not available

[status, result] = system('"%VS90COMNTOOLS%vsvars32.bat"');

if status
	error('Failed to setup Microsoft Visual Studio 9.0 tools.');
end

if ~nargout
	disp(' '); disp(result); clear status
end
