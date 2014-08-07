function out = mouse_over(h,str,type)

% mouse_over - add mouse over event to figure
% -------------------------------------------
%
% out = mouse_over(h,str,type)
%
% Input:
% ------
%  h - parent figure
%  fun - function to execute on mouseover event
%  type - types of objects to observe
%
% Output:
% -------
%  out - function dependent output

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% set types to observe
%--

if ((nargin < 3) | isempty(type))
	type = { ...
		'patch', ...
		'text', ...
		'image', ...
		'axes', ...
		'uicontrol', ...
		'figure' ...
	};
end

%--
% set command string
%--

if ((nargin < 2) | isempty(str))
	str = 'Initialize';
end

%--
% set parent figure
%--

if ((nargin < 1) | isempty(h))
	h = gcf;
end

%--
% compute depending on command string
%--

switch (str)
	
	%--
	% attach pointer motion to function
	%--
	
	case ('Initialize')
		
		% check for presence of other callback
		
		set(h,'WindowButtonMotionFcn',['mouse_over(' num2str(h) ',''Hover'');']);
		
	%--
	% report object we are hovering over
	%--
	
	case ('Hover')
		
		for k = 1:length(type)
				
			obj = over_obj(h,type{k});
			
			if (~isempty(obj))
				disp([get(obj,'type') ' - ' get(obj,'tag')])
% 				break;
			end
			
		end
			
		disp(' ');

end
