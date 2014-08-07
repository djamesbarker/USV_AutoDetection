function browser_movefcn(h,str)

% browser_movefcn - mouse motion function
% ---------------------------------------

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
% create persistent variables
%--

persistent DISPLAY_AXES;
persistent MOVING_TEXT;

%--
% set command string
%--

if (nargin < 2)
	str = 'initialize';
end

%--
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% main switch
%--

switch (str)

	%--
	% initialize figure properties for mouse motion display
	%--
	
	case ('initialize')
		
		%--
		% set button down and up callbacks
		%--
		
		set(h, ...
			'windowbuttondownfcn','browser_movefcn(gcf,''start'')', ...
			'windowbuttonupfcn','browser_movefcn(gcf,''stop'')' ...
		);
		
	%--
	% start motion
	%--
	
	case ('start')
		
		%--
		% set mouse motion callback
		%--
		
		set(h,'windowbuttonmotionfcn','browser_movefcn(gcf,''move'')');
		
		%--
		% create text
		%--
		
		pos = get(gca,'currentpoint');
		pos  = pos(1,1:2);
		
		MOVING_TEXT = text(pos(1),pos(2),mat2str(pos,4));
		
		set(MOVING_TEXT, ...
			'tag','moving_text', ...
			'erasemode','xor' ...
		);
		
	%--
	% mouse movement
	%--
	
	case ('move')
		
% 		delete(MOVING_TEXT);
% 		
% 		pos = get(gca,'currentpoint');
% 		pos  = pos(1,1:2);
% 		
% 		MOVING_TEXT = text(pos(1),pos(2),mat2str(pos,4));
% 		
% 		set(MOVING_TEXT, ...
% 			'tag','moving_text', ...
% 			'erasemode','normal' ...
% 		);
% 		
% 		drawnow;
		
		%--
		% update position and text
		%--
		
		pos = get(gca,'currentpoint');
		pos  = pos(1,1:2);
		
		set(MOVING_TEXT, ...
			'position',[pos 0], ...
			'string',mat2str(pos,4) ...
		);
	
		drawnow;
		
	%--
	% stop display of text
	%--
	
	case ('stop')

		%--
		% delete text
		%--
		
		delete(MOVING_TEXT);
		findobj(h,'tag','moving_text');
		
		%--
		% reset mouse motion callback
		%--
		
		set(h,'windowbuttonmotionfcn','');
		
end
