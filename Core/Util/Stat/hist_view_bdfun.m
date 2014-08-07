function hist_view_bdfun(h,str)

% hist_view_bdfun - button down function for histogram view
% ---------------------------------------------------------
%
% hist_view_bdfun(h,str)
%
% Input:
% ------
%  h - figure handle
%  str - command string

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
% set command string
%--

if ((nargin < 2) | isempty(str))
	str = 'Initialize'; 
end

%--
% set figure handle
%--

if ((nargin < 1) | isempty(h))
	h = gcf;
end

%--
% main switch
%--

switch (str)
	
	%--
	% Initialize
	%--
	
	case ('Initialize')
		set(h,'windowbuttondownfcn','hist_view_bdfun(gcf,''action'')');
	
	%--
	% Action
	%--
	
	case ('Action')
		
		%--
		% get userdata
		%--
		
		data = get(h,'userdata');
		
		%--
		% get children and bring them to front
		%--
		
		ch = data.hist_menu.children;
		
		for k = 1:length(ch)
			figure(ch(k));
		end
		
% 		figure(h);
		
end
