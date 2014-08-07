function flag = wakeup(t)

% wakeup - restart timers
% -----------------------
% 
% flag = wakeup(t)
%
% Input:
% ------
%  t - timer array
%
% Output:
% -------
%  flag - timer state change flag

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
% $Revision: 923 $
% $Date: 2005-04-07 10:15:20 -0400 (Thu, 07 Apr 2005) $
%--------------------------------

%-------------------------------------------
% HANDLE INPUT
%-------------------------------------------

%--
% set default timer array
%--

if (nargin < 1)
	t = timerfind;
end

% NOTE: return when there are no timers

if (isempty(t))
	flag = 0; return;
end

%-------------------------------------------
% WAKE TIMERS
%-------------------------------------------

%--
% get current running state
%--

s1 = get(t,'running');

%--
% restart timers
%--

stop(t); start(t);

%--
% get new running state
%--

s2 = get(t,'running');

%--
% compare states to determine if restart changed anything
%--

flag = 0;

for k = 1:length(s1)
	
	if (~strcmp(s1{k},s2{k}))
		flag = 1; break;
	end
	
end
