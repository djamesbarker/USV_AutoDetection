function input_slider_edit(str,opt,g)

% input_slider_edit - handle interaction of slider and edit box
% -------------------------------------------------------------
%
% input_slider_edit(str,opt)
%
% Input:
% ------
%  str - style string indicating current objectedit 
%  opt - slider type option
%  g - handle to relevant control

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
% set handle
%--

% NOTE: this approach to getting the control handle does not always work

if ((nargin < 3) | isempty(g))
	g = gcbo;
end

%--
% set default option
%--

if (nargin < 2)
	opt = 0;
end

%--
% behave according to str
%--

switch (str)
	
%--
% edit box to slider effect
%--

case ('edit')
	
	%--
	% get value from edit box
	%--
	
	switch (opt)

	case (0)
		v = str2num(get(g,'string'));
		
	case (1)
		v = clock_to_sec(get(g,'string'));
		
	case (2)
		v = round(str2num(get(g,'string')));
			
	end
	
	tag = get(g,'tag');
	
	% for improper values reset string to slider value
	
	if (isempty(v))
		
		h = findobj(gcf,'type','uicontrol','style','slider','tag',tag);
		v = get(h,'value');
		
		switch (opt)
			
		case (0)
			set(g,'string',num2str(v));
			
		case (1)
			set(g,'string',sec_to_clock(v));
			
		case (2)
			set(g,'string',int2str(round(v)));

		end
		
		return;
		
	end
	
	%--
	% get corresponding slider
	%--
	
	h = findobj(gcf,'type','uicontrol','style','slider','tag',tag);
	
	if (~isempty(h))
		
		%--
		% enforce parameter limits stored in slider properties
		%--
		
		m = get(h,'min');
		M = get(h,'max');
		
		if (v > M)
			
			v = M;
			
			switch (opt)
			
			case (0)
				set(g,'string',num2str(v));
				
			case (1)
				set(g,'string',sec_to_clock(v));
				
			case(2)
				set(g,'string',int2str(round(v)));
				
			end
			
		elseif (v < m)
			
			v = m;
			
			switch (opt)
			
			case (0)
				set(g,'string',num2str(v));
				
			case (1)
				set(g,'string',sec_to_clock(v));
				
			case(2)
				set(g,'string',int2str(round(v)));
				
			end
			
		end
		
		%--
		% set slider values
		%--
		
		set(h,'value',v);
		
		switch (opt)
			
		case (1)
			set(g,'string',sec_to_clock(v));
			
		case (2)
			set(g,'string',num2str(round(v)));
			
		end
		
	end
		
	return;
	
%--
% slider to edit box effect
%--

case ('slider')
	
	%--
	% get value from slider 
	%--
	
	v = get(g,'value');
	
	if (opt == 2)
		v = round(v);
		set(g,'value',v);
	end
	
	tag = get(g,'tag');
	
	%--
	% get corresponding edit box
	%--
	
	h = findobj(gcf,'type','uicontrol','style','edit','tag',tag);
			
	%--
	% set edit box value values
	%--
	
	if (abs(v) > eps)

		switch (opt)
			
		case (0)
			set(h,'string',num2str(v));
			
		case (1)
			set(h,'string',sec_to_clock(v));
			
		case (2)
			set(h,'string',int2str(round(v)));

		end
		
	else
		
		if (opt == 1)
			set(h,'string',sec_to_clock(0));
		else
			set(h,'string','0');
		end
		
		set(g,'value',0);
		
	end
	
	return;
	
	
end
