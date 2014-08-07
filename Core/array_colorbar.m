function t = array_colorbar(par)

% array_colorbar - toggle colorbar for axes array
% -----------------------------------------------
%
% array_colorbar(par)
%
% Input:
% ------
%  par - handle to axes array parent figure
%
% Output:
% -------
%  t - handle to colorbar axes

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
% $Revision: 2099 $
% $Date: 2005-11-10 00:52:35 -0500 (Thu, 10 Nov 2005) $
%--------------------------------

% FIXME: there is a problem setting the colorbar axes color

%--
% set axes array parent figure
%--

if (nargin < 1)
	par = gcf;
end

% db_disp(get(par,'tag'));

if (isempty(par))
	return;
end

%--
% set axes handles
%--
	
	%--
	% get array, support, and colorbar axes handles
	%--
	
	h = findobj(par,'type','axes');
	g = findobj(h,'type','axes','tag','support');
	t = findobj(h,'type','axes','tag','Colorbar');
	
	%--
	% warn if figure does not contain axes array
	%--
	
	if (isempty(g))
		
		disp(' ');
		warning(['Current figure ''' get(par,'name') ''' does not contain axes array.']);
		return;
		
	end
		
	%--
	% delete support and colorbar handles from axes handle list, leaving only array axes
	%--
	
	ix = find(h == g);
	h(ix) = [];
	
	if (~isempty(t))
		ix = find(h == t);
		h(ix) = [];
	end
	
%--
% get support axes userdata
%--

data = get(g,'userdata');

%--
% create colorbar
%--

if (isempty(t))
	
	%--
	% create colorbar for support axes
	%--
	
	axes(g); 
	
	t = colorbar;	
% 	t = colorbar_thin;
	
% 	set(get(t,'title'),'string','dB');
	
	%--
	% update position of array axes
	%--

	m = data.row;
	n = data.col;
	p = data.pos;
	
	spos = get(g,'position');
	p.left = spos(1);
	p.right = 1 - (spos(1) + spos(3));
	
	pos = axes_array(m,n,p);
			
	for k = 1:length(h)
		ix = get(h(k),'userdata');
		if (~isempty(ix))
			set(h(k),'position',pos{ix(1),ix(2)});
		end
	end
	
	axes(h(1));
	
	%--
	% update position of slider
	%--
	
	tmp = findobj(par,'type','uicontrol','style','slider');
	
	if (~isempty(tmp))
		pk = get(tmp,'position');
		pk(3) = spos(3);
		set(tmp,'position',pk);
	end
	
	%--
	% update support axes userdata
	%--
	
	data.colorbar = t;
	set(g,'userdata',data);
	
	%--
	% make colorbar and children invisible to clicks
	%--
	
	set(findall(t),'hittest','off');
 	
%--
% delete colorbar
%--

else
	
	%--
	% delete support axes colorbar
	%--
	
	delete(data.colorbar);
	
	%--
	% update position of array axes
	%--

	m = data.row;
	n = data.col;
	p = data.pos;
	
	spos = get(g,'position');
	p.left = spos(1);
	p.right = 1 - (spos(1) + spos(3));
	
	pos = axes_array(m,n,p);
			
	for k = 1:length(h)
		ix = get(h(k),'userdata');
		if (~isempty(ix))
			set(h(k),'position',pos{ix(1),ix(2)});
		end
	end
	
	axes(h(1));
	
	%--
	% update position of slider
	%--
	
	% TODO: remove this code ...
	
	tmp = findobj(par,'type','uicontrol','style','slider');
	
	if (~isempty(tmp))
		pk = get(tmp,'position');
		pk(3) = spos(3);
		set(tmp,'position',pk);
	end
	
	%--
	% update support axes userdata
	%--
	
	data.colorbar = [];
	set(g,'userdata',data);
	
	%--
	% return empty handle
	%--
	
	t = [];
	
end
