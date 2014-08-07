function browser_wbfun(obj,eventdata,type)

% browser_wbdfun - browser window button function
% -----------------------------------------------
%
%  browser_wbfun(obj,eventdata,state)
%
% Input:
% ------
%  obj - callback object handle
%  eventdata - system provided event data
%  type - type of button callback ('down','motion, or 'up')

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
% check current object
%--

tmp = gco;

switch (type)
	
	%--
	% button down callback
	%--
	
	case ('down')
		
		%--
		% set motion callback
		%--
		
		set(obj,'windowbuttonmotionfcn',{@browser_wbfun,'motion'});
		
		
	%--
	% motion callback
	%--
	
	case ('motion')
		
		%--
		% compute depending on current object tag
		%--
				
% 		tag = get(tmp,'tag'); 
% 		
% 		if (~isempty(tag))
% 			
% 			switch (tag)
% 
% 				%--
% 				% scrolling display
% 				%--
% 
% 				case ('BROWSER_TIME_SLIDER')
% 
% 					browser_view_menu(get(tmp,'parent'),'Scrollbar');
% 
% 					drawnow; % is this required ???
% 
% 			end
% 			
% 		end
		
	%--
	% button up callback
	%--
		
	case ('up')
		
		%--
		% empty motion callback
		%--
		
		set(obj,'windowbuttonmotionfcn',[]);
		
end


disp(['|||' upper(type) '|||' get(tmp,'tag')]);
