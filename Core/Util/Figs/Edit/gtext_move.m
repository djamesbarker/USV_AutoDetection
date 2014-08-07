function h = gtext_move(s,str,id)

% gtext_move - create movable gtext
% ---------------------------------
% 
% h = gtext_move(s)
%
% Input:
% ------
%  s - gtext string
%
% Output:
% -------
%  h - handle of text

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
% $Revision: 1.0 $
% $Date: 2003-09-16 01:30:51-04 $
%--------------------------------

%--
% set str
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% main switch
%--

switch (str)

	case ('Initialize')
	
		h = gtext(s);
		
		id = round((10^4)*rand(1));
		set(h,'UserData',id);
		
		set(h,'ButtonDownFcn',['gtext_move([],''Move'',' num2str(id) ')']);
		
	case ('Move')
	
		[x,y] = ginput(1);
		
		h = findobj(get(gca,'Children'),'UserData',id);
		
		set(h,'Position',[x,y]);
		set(h,'Editing','on');

end


