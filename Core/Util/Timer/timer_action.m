function obj = timer_action(obj, prop, state, action)

% timer_action - timer action on property state
% ---------------------------------------------
%
% obj = timer_action(obj, prop, state, action)
%
% Input:
% ------
%  obj - action timers
%  prop - property to watch
%  state - value to watch for
%  action - action callback
%
% Output:
% -------
%  obj - action timers

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1935 $
% $Date: 2005-10-14 16:58:12 -0400 (Fri, 14 Oct 2005) $
%--------------------------------

% TODO: add checking on property and state

for k = 1:length(obj)
	
	% NOTE: check that property is in prescribed action state
	
	if ~isequal(get(obj(k), prop), state)
		continue;
	end
	
	% TODO: modify this to handle general callbacks via 'eval_callback'
	
	action(obj(k));
	
end
