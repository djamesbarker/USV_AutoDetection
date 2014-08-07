function log_resizefcn(h)

% log_resizefcn - figure resize function for log browser
% ------------------------------------------------------
%
% log_resizefcn(h)
%
% Input:
% ------
%  h - handle to figure (def: gcf)

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--
% set handle or set resize function for figure
%--

if (~nargin)
	h = gcf;
else
	if (isempty(get(h,'resizefcn')))
		set(h,'resizefcn','log_resizefcn');
	end
end

%--
% get userdata
%--

data = get(h,'userdata');

%--
% get relevant handles
%--

ax = data.browser.axes;
[m,n] = size(ax);
ax = ax';

ax_slider = data.browser.slider;

ax_supp = findobj(h,'type','axes','tag','support');
ax_color = findobj(h,'type','axes','tag','Colorbar');

%--
% get figure size in pixel units
%--

units = get(h,'units');
if (~strcmp(units,'pixels'))
	set(h,'units','pixels');
end

pos = get(h,'position');

set(h,'units','pixels');

%--
% compute values needed for updating positions
%--

hh = 12/pos(4);
ww = 12/pos(3);
	
%--
% update positions based on presence of colorbar
%--

%--
% no colorbar
%--

if (isempty(ax_color))

	%--
	% compute new positions of event axes array
	%--
	
	p = axes_array;

	p.top = 6 * hh;
	p.bottom = 7 * hh;
	
	p.xspace = 1 * ww;
	p.yspace = 6 * hh;
	
	p.left = 4 * ww;
	p.right = 3 * ww;
	
	pos = axes_array(m,n,p);
	
	pos = pos';
	
	%--
	% update positions of event axes
	%--
	
	% check for reasonable positions
	
	for k = 1:(m * n)
		if (any(pos{k} <= 0))
			return;
		end
	end
	
	% update axes positions
	
	for k = 1:(m * n)
		set(ax(k),'position',pos{k});
	end
	
	%--
	% update position of support axes
	%--

	set(ax_supp,'position',[p.left, p.bottom, 1 - (p.left + p.right), 1 - (p.top + p.bottom)]);
	
	%--
	% update position of slider
	%--

	set(ax_slider,'position',[p.left, 2*hh, 1 - (p.left + p.right), 2*hh]);
	
%--
% colorbar present
%--

else

	%--
	% compute new positions of event axes array
	%--
	
	p = axes_array;

	p.top = 6 * hh;
	p.bottom = 7 * hh;
	
	p.xspace = 1 * ww;
	p.yspace = 6 * hh;
	
	p.left = 4 * ww;
	p.right = 8 * ww;
	
	pos = axes_array(m,n,p);
	
	pos = pos';
	
	%--
	% update positions of event axes
	%--
	
	% check for reasonable positions
	
	for k = 1:(m * n)
		if (any(pos{k} <= 0))
			return;
		end
	end
	
	% set axes positions
	
	for k = 1:(m * n)
% 		posk = [pos{k}(1), pos{k}(2), 1 - (p.left + 8*ww), pos{k}(4)];
		set(ax(k),'position',pos{k});
	end
	
	%--
	% update position of support axes and colorbar
	%--

	posk = [p.left, p.bottom, 1 - (p.left + 8*ww), 1 - (p.top + p.bottom)];
	set(ax_supp,'position',posk);

	posk = [1 - 7*ww, p.bottom, 3*ww, 1 - (p.top + p.bottom)];
	set(ax_color,'position',posk);

	%--
	% update position of slider
	%--

	posk = [p.left, 2*hh, 1 - (p.left + 8*ww), 2*hh];
	set(ax_slider,'position',posk);
	
end

%--
% refresh figure
%--

refresh(gcf);
