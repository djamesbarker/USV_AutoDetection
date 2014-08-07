function name = get_action_target_name(target, type) 

% get_action_target_name - get name of target
% -------------------------------------------
%
% name = get_action_target_name(target, type)
%
% Input:
% ------
%  target - action target
%  type - action type
%
% Output:
% -------
%  name - target name

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%------------------------------------------
% HANDLE INPUT
%------------------------------------------

%--
% handle multiple targets recursively
%--

if (length(target) > 1) && ~ischar(target)
	
	switch class(target)
		
		%--
		% struct target input
		%--
		
		case 'struct'
			
			for k = 1:length(target)
				name{k} = get_action_target_name(target(k), type);
			end
	
		%--
		% cell array of strings target input
		%--
		
		case 'cell'
			
			for k = 1:length(target)
				name{k} = get_action_target_name(target{k}, type);
			end
			
		%--
		% error condition
		%--
		
		otherwise, error('Multiple target input must be a struct or cell array.');
			
	end
	
	return;

end

%------------------------------------------
% COMPUTE TARGET NAME
%------------------------------------------

%--
% compute target name based on type
%--

switch type
	
	% NOTE: we try to pack the parent log name in the event userdata
	
	case 'event', name = event_name(target);
		
	case 'log', name = log_name(target);
		
	case 'sound', name = sound_name(target);
		
	otherwise, error('Unrecognized action type.');
		
end
