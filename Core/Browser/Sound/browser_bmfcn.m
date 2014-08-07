function browser_bmfcn

% h = gco;
% 
% if (strcmp(get(h,'type'),'uicontrol'))
% 	if (strcmp(get(h,'style'),'slider'))
% 		p = get(gcf,'currentpoint')
% 		tmp = text(p(1),p(2),num2str(get(h,'value')));
% 		drawnow;
% % 		delete(tmp)
% 	end
% end

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
% get slider handle
%--

data = get(gcf,'userdata');

slider = data.browser.slider;

%--
% display slider value if we are changing the time
%--

if (gco == slider)
	
	t = sec_to_clock(get(slider,'value'));
	
	p = get(gcf,'currentpoint');
	
	tmp = text(p(1),p(2),t);
	
	drawnow;
	
end
