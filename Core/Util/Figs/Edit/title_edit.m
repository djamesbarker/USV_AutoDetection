function h = title_edit(s,str)

% title_edit - create editable title
% ----------------------------------
% 
% h = title_edit(s)
% s = title_edit(h)
%
% Input:
% ------
%  s - title string
%  h - handle to parent axes (def: gca)
%
% Output:
% -------
%  h - handle of title
%  s - title string

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
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%-------------------------------------------------
% HANDLE VARIABLE INPUT
%-------------------------------------------------

%--
% get title string
%--

if (nargin < 1)
	
	%--
	% get title handle and make editable
	%--
	
	h = get(gca,'Title');	
	
	set(h, ...
		'buttondownfcn','title_edit([],''Edit'');', ...
		'erasemode','normal' ...
	);

	%--
	% output title string and return
	%--
	
	h = get(h,'String');
	
	return;
	
end	

%--
% create editable title or get specific title string
%--

if (nargin < 2)

	%--
	% set command string to initialize
	%--
	
	if (isstr(s))
	
		str = 'Initialize';
		
	%--
	% get specific title string
	%--
	
	elseif (ishandle(s))
	
		%--
		% get title handle and make editable
		%--
		
		h = get(s,'Title');
		
		set(h, ...
			'buttondownfcn','title_edit([],''Edit'');', ...
			'erasemode','normal' ...
		);

		%--
		% output title string and return
		%--
		
		h = get(h,'String');
		
		return;
		
	end
		
end

%-------------------------------------------------
% MAIN SWITCH
%-------------------------------------------------

switch (str)

	%--
	% Initialize
	%--
	
	case ('Initialize')

		%--
		% create editable title
		%--
		
		h = title(s);
		
		set(h, ...
			'buttondownfcn','title_edit([],''Edit'');', ...
			'erasemode','normal' ...
		);
		
		%--
		% set visible color
		%--
		
		if (all(get(gcf,'Color') == [0, 0, 0]))
			set(get(gca,'Title'),'Color',[1, 1, 1]);
			drawnow;
		end
		
	case ('Edit')
	
		%--
		% set editing on
		%--
		
		h = get(gca,'Title');
		
		set(h, ...
			'Color',[0, 0, 0], ...
			'Editing','on' ...
		);
	
		waitfor(h,'Editing');
		
		%--
		% set visible color
		%--
		
		if (all(get(gcf,'Color') == [0, 0, 0]))
			set(get(gca,'Title'),'Color',[1, 1, 1]);
			drawnow;
		end
		
end



