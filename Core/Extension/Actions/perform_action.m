function [result, context] = perform_action(target, ext, parameter, context)

% perform_action - perform action on target
% -----------------------------------------
%
% result = perform_action(target, ext, parameter, context)
%
% Input:
% ------
%  target - action target
%  ext - action extension
%  parameter - action parameters
%  context - action context
%
% Output:
% -------
%  result - result of action

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

%--
% action is undefined
%--

if isempty(ext.fun.compute)
	
	result = action_result('undefined', target); return;
	
end

%--
% try to perform action on target
%--

started = clock;
	
try
	
	% NOTE: this line uses all the input variables
	
	[output, context] = ext.fun.compute(target, parameter, context); 
	
	result = action_result('done', target, output, '', started);
	
catch
	
	result = action_result('failed', target, lasterror, '', started);

end


