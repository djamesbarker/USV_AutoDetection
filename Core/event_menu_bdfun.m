function event_menu_bdfun(obj, eventdata, mode, h, m, ix)

% event_menu_bdfun - create event menu upon request
% -------------------------------------------------
%
% event_menu_bdfun(obj, eventdata, 'sound', h, m, ix)
%
% event_menu_bdfun(obj, eventdata, 'log', h, m, ix)
%
% Input:
% ------
%  obj - callback object
%  eventdata - not used at the moment
%  h - parent browser handle
%  m - log index in sound browser
%  ix - event index in log

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

%------------------------------------------------------------------
% DISPLAY SELECTION AND ADD MENU IF NEEDED
%------------------------------------------------------------------

switch mode
	
	%------------------------------------------------------------------
	% SOUND BROWSER
	%------------------------------------------------------------------
	
	case 'sound'
		
		%--
		% execute button down function for event display
		%--
		
		% NOTE: the last argument asks for event palette update
		
		event_bdfun(h, m, ix);
		
		%--
		% create contextual menu if needed
		%--
			
		% NOTE: 'gbco' is 'obj' since we are using a function handle callback
		
		if isempty(get(obj, 'uicontextmenu'))
						
			%--
			% create contextual menu, tag, and attach to current event display
			%--
			
			c = uicontextmenu('parent', h);
			
			set(c, ...
				'tag', [int2str(m) '.' int2str(ix)] ...
			);
			
			set(obj, 'uicontextmenu', c);
			
			%--
			% create event menu
			%--
			
			% NOTE: the empty command defaults to 'Initialize'
			
			event_menu(c, '', h, m, ix);
			
		end
		
		%--
		% play on double click
		%--
		
		double_click_play(obj, []);
		
	%------------------------------------------------------------------
	% LOG BROWSER
	%------------------------------------------------------------------
	
	% TODO: this code may be broken now that the signature has changed
	
	case 'log'
				
		%--
		% execute button down function for event display
		%--
		
		event_bdfun;
		
		%--
		% create contextual menu if needed
		%--
		
		if isempty(get(obj,'uicontextmenu'))
		
			%--
			% create contextual menu, tag, and attach to current event display
			%--
			
			c = uicontextmenu;
			
			set(c, ...
				'tag',[int2str(m) '.' int2str(ix)] ...
			);
		
			set(obj,'uicontextmenu',c);
			
			%--
			% create event menu
			%--
			
			event_menu(c,'','',m,ix);
			
		end
		
end


%-------------------------------------------------------------
% DOUBLE_CLICK_PLAY
%-------------------------------------------------------------

function double_click_play(obj, eventdata)

% double_click_play - play selection on double click
% --------------------------------------------------

if double_click(obj)
	browser_sound_menu(gcbf, 'Play Event');
end

