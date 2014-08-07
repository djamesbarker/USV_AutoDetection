function level = event_level(event,log)

% event_level - compute event level
% ---------------------------------
%
% level = event_level(event,log)
%
% Input:
% ------
%  event - event
%  log - parent log
%
% Output:
% -------
%  level - event level

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
% $Revision: 563 $
% $Date: 2005-02-21 05:59:20 -0500 (Mon, 21 Feb 2005) $
%--------------------------------

% TODO: consider simply getting the children and computing the level

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% set naive level if no log is available
%--

% NOTE: produce warning when there are children

if (nargin < 2)
	level = 1; return;
end

%--
% handle multiple events recursively
%--

% NOTE: there is nothing to be gained from supporting sequences

if (numel(event) > 1)
	error('Only single event input is supported.');
end

%-------------------------
% COMPUTE LEVEL
%-------------------------

%--
% return quickly for simple event
%--

if (isempty(event.children))
	event.level = 1; return;
end

%--
% compute composite event level
%--

% NOTE: this is a recursive computation that dereferences children

for k = 1:length(event.children)
	level(k) = event_level(get_log_events(log,'id',event.children(k)));
end

level = max(level) + 1;
