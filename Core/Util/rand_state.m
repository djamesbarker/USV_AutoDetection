function [value, state] = rand_state(n, init, method)

% rand_state - call rand with set and get state
% ---------------------------------------------
%
% [value, state] = rand_state(n, init, method)
%
% Input:
% ------
%  n - values to generate
%  init - initial state
%  method - generation method
%
% Output:
% -------
%  value - values
%  state - states before generating each value

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

% TODO: create 'randn_state' and 'randn_state_blocks', reconsider last name

%--
% handle input
%--

if (nargin < 3) || isempty(method)
	method = 'twister';
end

if nargin < 2
	init = 0;
end

if nargin < 1
	n = 10;
end

%--
% configure generator
%--

% TODO: consider getting initial state of generator and setting at end

rand(method, init);

%--
% get values and states if needed
%--

% NOTE: the states are the states before generating the value

if nargout < 2
	
	value = rand(n, 1);
	
else
	
	value = zeros(n, 1);
	
	for k = 1:n
		state(:, k) = rand(method); value(k) = rand(1);
	end

end
