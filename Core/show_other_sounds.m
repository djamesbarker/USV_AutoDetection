function value = show_other_sounds(value)

% show_other_sounds - set visibility mode of other sounds
% -------------------------------------------------------
% 
% state = show_other_sounds
%
% show_other_sounds(1) - show other sounds
%
% show_other_sounds(0) - hide other sounds

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

%--
% return value
%--

if (nargin < 1)
	
	value = get_env('show_other_sounds');
	
	% NOTE: handle empty value here in case 'startup' fails to set it
	
	if (~isempty(value))
		return;
	else
		value = 1;
	end
	
end

%--
% update value
%--

% NOTE: this allows command syntax

if (ischar(value))
	value = eval(value);
end

if (value)
	set_env('show_other_sounds',1);
else
	set_env('show_other_sounds',0);
end
