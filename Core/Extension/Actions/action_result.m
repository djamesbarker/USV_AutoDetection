function result = action_result(status, target, value, message, started)

% action_result - package action result
% -------------------------------------
%
% result = action_result('done', target, output, message, started)
%
%        = action_result('failed', target, error, message, started)
%
%        = action_result('undefined', target, [], message);
% 
% Input:
% ------
%  target - action target
%  output - action output
%  error - error during action, output of 'lasterror'
%  started - clock when action started
%
% Output:
% -------
%  result - result

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% check result status
%--

types = {'undefined', 'failed', 'done'}; status = lower(status);

if ~ismember(status, types)
	error('Unrecognized result status.');
end 

%--
% set default values
%--

% NOTE: only the status is absolutely needed

if nargin < 5
	started = [];
end

if nargin < 4
	message = ''; 
end 

if nargin < 3
	value = [];
end

if nargin < 2
	target = [];
end 

%--
% check string target
%--

% NOTE: the target may be an actual target, or to 'prepare' and 'conclude'

if ischar(target)
	
	target = lower(target);
	
	if ~ismember(target, {'prepare', 'conclude'})
		error('Unrecognized target name.'); 
	end
	
end

%-----------------------
% PRODUCE RESULT
%-----------------------

%--
% create result
%--

result.target = target; 

result.status = status;

result.message = message;

result.error = [];

if isempty(started)
	result.elapsed = [];
else
	result.elapsed = etime(clock, started);
end

result.output = [];

%--
% fill result
%--

switch status
		
	case 'failed'

		% NOTE: this is the output of lasterror
		
		result.error = value;
		
		% TODO: handle input message here
		
		result.message = result.error.message;
		
	case 'done'
		
		result.output = value;
		
end

