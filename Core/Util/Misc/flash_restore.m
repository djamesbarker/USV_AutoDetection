function flash_restore(state)

% flash_restore - restore values changed by 'flash_update'
% --------------------------------------------------------
%
% flash_restore(state)
%
% Input:
% ------
%  state - output from 'flash_update'

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
% $Revision: 1789 $
% $Date: 2005-09-15 17:23:27 -0400 (Thu, 15 Sep 2005) $
%--------------------------------

% NOTE: state contains handles updated in flash, properties and initial values

for j = 1:length(state.handles)
	
	% NOTE: handle object may have been destroyed since flash
	
	if (~ishandle(state.handles(j)))
		continue;
	end
	
	for k = 1:length(state.prop)
		set(state.handles(j),state.prop{k},state.init{j}{k});
	end
	
end
