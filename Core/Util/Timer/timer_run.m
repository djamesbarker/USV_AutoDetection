function obj = timer_run(name, fun)

% timer_run - start named timer, possibly create
% ----------------------------------------------
%
% obj = timer_run(name, fun)
%
% Input:
% ------
%  name - timer name
%  fun - timer constructor
%
% Output:
% -------
%  obj - timer considered

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

%------------------------------------
% SETUP
%------------------------------------

% NOTE: configure timer action

prop = 'running'; state = 'off'; action = @start;

%------------------------------------
% HANDLE INPUT
%------------------------------------

% NOTE: act on existing timers when no input

if nargin < 1
	obj = timer_action(timerfind, prop, state, action); return;
end

%------------------------------------
% ACT ON TIMERS
%------------------------------------

%--
% look for named timer
%--

obj = timerfind('name', name);

%--
% try to create timer if constructor was provided
%--

if isempty(obj) && (nargin > 1)
	obj = fun(); obj = timerfind('name', name);
end

% NOTE: return if we still don't have a timer with given name

if isempty(obj)
	return;
end

% NOTE: we consider non-singleton timer problem

if length(obj) > 1
	warning(['There are multiple timers named ''', name, '''.']);
end

%--
% act on timer
%--

timer_action(obj(1), prop, state, action);
