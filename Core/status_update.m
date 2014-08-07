function g = status_update(h,t,varargin)

% status_update - update status bar display
% -----------------------------------------
%
% [g,value] = status_update(h,t,'property',value,...)
%
% Input:
% ------
%  h - parent figure
%  t - update target ('left','right', or empty)
%  field - property to update
%  value - value of property
%
% Output:
% -------
%  g - handles of objects updated

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
% $Revision: 891 $
% $Date: 2005-04-01 19:48:42 -0500 (Fri, 01 Apr 2005) $
%--------------------------------

% NOTE: this can be generalized to handle status specific targets. status
% bars are uniformly tagged and may contain a collection of display
% objects, think of text and waitbars. the layout of displays on status
% bars is open

%--
% set default output
%--

g = [];

%--
% get status bar axes
%--

% TODO: use better tagging for status bars

ax = findobj(h,'tag','Status');

% return if figure has no status bar, there is no warning for this event

if (isempty(ax))
	return;
end

%--
% get field value pairs
%--

[field,value] = get_field_value(varargin);

% return if there is nothing to update

if (isempty(field))
	return;
end

%--
% get text handles
%--

left = findobj(ax,'tag','Status_Text_Left');

right = findobj(ax,'tag','Status_Text_Right'); 

%--
% update properties
%--

for k = 1:length(field)
	
	%--
	% property update switch
	%--
	
	switch (field{k})
		
		%--
		% status bar background
		%--
		
		case ('backgroundcolor')
			
			switch (t)
				
				% axes background color
				
				case ('')
					
					g = ax;
					set(g,'color',value{k});
					
				% text background color
				
				case ('left')
					
					g = left;
					set(g,'backgroundcolor',value{k});
					
				case ('right')
					
					g = right;
					set(g,'backgroundcolor',value{k});
					
			end
			
		%--
		% status bar text color
		%--
		
		case ('color')
			
			switch (t)
				
				% all text color
				
				case ('')
					
					g = [left,right];
					set(g,'color',value{k});
					
				% message specific text color
				
				case ('left')
					
					g = left;
					set(g,'color',value{k});
					
				case ('right')
					
					g = right;
					set(g,'color',value{k});
					
			end

		%--
		% message update
		%--
		
		case ('message')
		
			switch (t)
				
				case ('left')
					
					g = left;
					set(g,'string',value{k});
					
				case ('right')
					
					g = right;
					set(g,'string',value{k});
					
					% text is repositioned by the resize function
					
					browser_resizefcn(h);
					
			end
			
	end
	
end
