function out = trellis_layout(m,n,opt,flag)

% trellis_layout - layout array of axes for trellis display
% ---------------------------------------------------------
%
%  opt = trellis_layout
%
%  pos = trellis_layout(m,n,opt,1)
%
%    h = trellis_layout(m,n,opt)
%
% Input:
% ------
%  m,n - number of rows and columns
%  opt - trellis layout options
%
% Output:
% -------
%  opt - trellis layout options
%  pos - positions for axes layout
%  h - handles to created axes

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
% $Date: 2004-02-09 10:52:10-05 $
%--------------------------------

%--
% set flag
%--

if ((nargin < 4) | isempty(flag))
	flag = 0;
end

%-------------------------------------------
% set options
%-------------------------------------------

if ((nargin < 3) | isempty(opt))
	
	%-------------------------------------------
	% set position options
	%-------------------------------------------
	
	%--
	% fraction of panel used for headings (key for resize function)
	%--
	
	pos.cond_two = 0.1;
	
	pos.cond_one = 0.1;
	
	opt.pos = pos;
	
	%--
	% fraction of figure used for margins (also used in resize function)
	%--
	
	margin.top = 0.05;
	
	margin.right = 0.075;
	
	margin.bottom = 0.075;
	
	margin.left = 0.075;
	
	margin.col = 0.0;
	
	margin.row = 0.0;
	
	opt.margin = margin;
	
	%-------------------------------------------
	% set color options
	%-------------------------------------------
	
	color.cond_two = [0.7 0.7 1];
	
	color.cond_one = [0.7 1 0.7];
	
	color.text = [0 0 0];
	
	opt.color = color;
	
	%-------------------------------------------
	% output options
	%-------------------------------------------
	
	if (nargin < 1)
		out = opt;
		return;
	end
	
end

%-------------------------------------------
% compute axes positions and create axes
%-------------------------------------------

%--
% compute raw panel width and height
%--

panel_w = (1 - (opt.margin.left + opt.margin.right + ((n - 1) * opt.margin.col))) / n;

panel_h = (1 - (opt.margin.bottom + opt.margin.top + ((m - 1) * opt.margin.row))) / m;

%--
% update panel height and compute heading heights
%--

cond_one_h  = opt.pos.cond_one * panel_h;

cond_two_h = opt.pos.cond_one * panel_h;

panel_hf = panel_h;

panel_h = (1 - (opt.pos.cond_one + opt.pos.cond_two)) * panel_h;

%-------------------------------------------
% compute axes positions
%-------------------------------------------

% positions are expressed as [left, bottom, width, height]

k = 1;

for i = 1:m
	
	for j = 1:n
		
		%-------------------------------------------
		% compute axes positions
		%-------------------------------------------
		
		tmp1 = opt.margin.left + ((j - 1) * (panel_w + opt.margin.col));
		
		tmp2 = opt.margin.bottom + ((i - 1) * (panel_hf + opt.margin.row));
		
		panel{k} = [ ...
			tmp1, ...
			tmp2, ...
			panel_w, ...
			panel_h ...
		];
		
		cond_two{k} = [ ...
			tmp1, ...
			tmp2 + panel_h + cond_one_h, ...
			panel_w, ...
			cond_two_h ...
		];
		
		cond_one{k} = [ ...
			tmp1, ...
			tmp2 + panel_h, ...
			panel_w, ...
			cond_one_h ...
		];
		
		k = k + 1;
		
	end 
	
end 
		
%--
% output positions if flag
%--

if (flag)
	
	pos.panel = panel;
	pos.cond_one = cond_one;
	pos.cond_two = cond_two;
	
	out = pos;
	
	return;
	
end

%-------------------------------------------
% create trellis figure
%-------------------------------------------

% this figure may be created in other ways

f = fig;

%-------------------------------------------
% create trellis objects
%-------------------------------------------

k = 1;

for i = 1:m
	
	for j = 1:n
		
		%-------------------------------------------
		% panel axes
		%-------------------------------------------
		
		% the properties setting code can be simplified
		
		%--
		% create axes
		%--
		
		ax = axes('position',panel{k});
		
		h.panel(k) = ax;
		
		%--
		% set common properties
		%--
		
		set(ax, ...
			'tag',int2str(k), ...
			'box','on', ... 
			'tickdir','out' ...
		);

		%-------------------------------------------
		% condition one heading axes
		%-------------------------------------------
			
		%--
		% create axes
		%--
	
		ax = axes('position',cond_one{k});
		
		h.cond_one(k) = ax;
		
		%--
		% set common properties
		%--
		
		set(ax, ...
			'box','on', ...
			'layer','top', ...
			'xtick',[], ...
			'ytick',[] ...
		);
	
		% this works for screen display, but not for printing
		
% 		'color',opt.color.cond_one, ...
			
		%--
		% create title, strip label, and position or slice patch
		%--
		
		axes(ax);
		
		hold on;
		
		xlim = get(ax,'xlim');
		ylim = get(ax,'ylim');
			
		% strip label patch
		
		tmp = rectangle('position',[0, 0, 1, 1]);
		
		set(tmp, ...
			'tag',['STRIP1' int2str(k)], ...
			'edgecolor','none', ...
			'facecolor',(2 * opt.color.cond_one + 1) / 3 ...
		);
	
		% position or slice patch
		
		tmp = rectangle('position',[(j - 1)/n, 0, 1/n, 1]);
		
		set(tmp, ...
			'tag',['PATCH1' int2str(k)], ...
			'edgecolor','none', ...
			'facecolor',0.8 * opt.color.cond_one ...
		);
							
		tmp = text(0.5,0.5,['CO1 ' int2str(k)]);
		
		set(tmp, ...
			'tag',['TITLE1 ' int2str(k)], ...
			'clipping','on', ...
			'horizontalalignment','center', ...
			'verticalalignment','middle' ...
		);
	
% 		'fontweight','demi', ...
			
		set(ax, ...
			'xlim',xlim, ...
			'ylim',ylim ...
		);
		
		%-------------------------------------------
		% row heading axes
		%-------------------------------------------
		
		%--
		% create axes
		%--
		
		ax = axes('position',cond_two{k});
		
		h.cond_two(k) = ax;
		
		%--
		% set common properties
		%--
		
		set(ax, ...
			'box','on', ...
			'layer','top', ...
			'xtick',[], ...
			'ytick',[] ...
		);
	
		% this works for screen display, but not for printing
		
% 		'color',opt.color.cond_two, ...
			
		%--
		% create title, strip label, and position or slice patch
		%--
		
		axes(ax);
		
		hold on;
		
		xlim = get(ax,'xlim');
		ylim = get(ax,'ylim');
		
		% strip label patch
		
		tmp = rectangle('position',[0, 0, 1, 1]);
		
		set(tmp, ...
			'tag',['STRIP2 ' int2str(k)], ...
			'edgecolor','none', ...
			'facecolor',(2 * opt.color.cond_two + 1) / 3 ...
		);
	
		% position or slice patch
	
		tmp = rectangle('position',[(i - 1)/m, 0, 1/m, 1]);
		
		set(tmp, ...
			'tag',['PATCH2 ' int2str(k)], ...
			'edgecolor','none', ...
			'facecolor',0.8 * opt.color.cond_two ...
		);
	
		tmp = text(0.5,0.5,['CO2 ' int2str(k)]);
		
		set(tmp, ...
			'tag',['TITLE2 ' int2str(k)], ...
			'clipping','on', ...
			'horizontalalignment','center', ...
			'verticalalignment','middle' ...
		);
	
% 		'fontweight','demi', ...
	
		set(ax, ...
			'xlim',xlim, ...
			'ylim',ylim ...
		);
		
		k = k + 1;
		
	end
	
end

%--
% output axes handles
%--

out = h;

%-------------------------------------------
% update axes properties
%-------------------------------------------

%--
% reshape handles for convenience
%--

tmp_panel = reshape(h.panel(:),n,m)';

tmp_cond_two = reshape(h.cond_two(:),n,m)';

%--
% set internal axes properties
%--

set(tmp_panel(2:(end - 1),2:(end - 1)), ...
	'xticklabel',[], ...
	'yticklabel',[] ...
);

%--
% first (bottom) and last (top) row update
%--

for k = 1:n
	
	if (mod(k,2))
		set(tmp_panel(m,k), ...
			'xaxislocation','top', ...
			'xticklabel',[] ...
		);
	else
		set(tmp_panel([1,m],k),'xticklabel',[]);
		set(tmp_cond_two(m,k), ...
			'xaxislocation','top', ...
			'tickdir','out', ...
			'xtickmode','auto' ...
		);
	end

	if ((k > 1) & (k < n))
		set(tmp_panel([1,m],k),'yticklabel',[]);
	end
	
end

%--
% first (left) and last (right) column update
%--

for k = 1:m
	
	if (mod(k,2))
		set(tmp_panel(k,n), ...
			'yaxislocation','right', ...
			'yticklabel',[] ...
		);
	else
		set(tmp_panel(k,1),'yticklabel',[]);
		set(tmp_panel(k,n), ...
			'yaxislocation','right' ...
		);
	end
	
	if ((k > 1) & (k < m))
		set(tmp_panel(k,[1,n]),'xticklabel',[]);
	end

end

%--
% display panel order
%--

% test code

tmp = h.panel;

% tmp = h.panel';
% tmp = tmp(:);

for k = 1:length(tmp)
	axes(tmp(k));
	set(text(0.5,0.5,int2str(k)), ...
		'fontsize',16, ...
		'clipping','on', ...
		'horizontalalignment','center', ...
		'verticalalignment','middle', ...
		'color',[1 0 0] ...
	);
end

%--
% set figure userdata
%--

data = get(f,'userdata');

data.trellis.m = m;

data.trellis.n = n;

data.trellis.opt = opt;

data.trellis.handles = h;

set(f,'userdata',data);

%--
% set figure resize functions
%--

set(f,'resizefcn',@trellis_resize);


%------------------------------------------------------------
% TRELLIS_RESIZE
%------------------------------------------------------------

function trellis_resize(obj,eventdata)

% trellis_resize - resize function for trellis figures
% ----------------------------------------------------
%
% trellis_resize(obj,eventdata)
%
% Input:
% ------
%  obj - callback object
%  eventdata - not currently used

%--
% get trellis axes handles
%--

% also store the options as part of the trellis data

trellis = get_field(get(obj,'userdata'),'trellis');

ax = trellis.handles;

opt = trellis.opt;

m = trellis.m;

n = trellis.n; 

%--
% get figure size
%--

% positions are expressed as [left, bottom, width, height]

tmp = get(obj,'position');

w = tmp(3);
h = tmp(4);

%--
% compute desired size for margins
%--

% get 56 horizontal and vertical pixels in normalized coordinates 

mw = 56 / w;

mh = 56 / h;

%--
% get and set trellis options
%--

% opt = trellis_layout;

opt.margin.top = mh;

opt.margin.right = mw;

opt.margin.bottom = mh;

opt.margin.left = mw;

%--
% compute desired size for headings
%--

% get 16 vertical pixels in normalized coordinates

hh = 24 / (h * ((1 - (2 * mh)) / m));

opt.pos.cond_one = hh;

opt.pos.cond_two = hh;

%--
% recompute axes positions
%--

pos = trellis_layout(m,n,opt,1);

%--
% check panel extent
%--

% this is not the most elegant solution

tmp = pos.panel(:);

for k = 1:length(tmp)
	if (any(tmp{k} < 0))
		return;
	end
end

%--
% update positions
%--

for k = 1:(m * n)
			
	set(ax.panel(k),'position',pos.panel{k});
	set(ax.cond_one(k),'position',pos.cond_one{k});
	set(ax.cond_two(k),'position',pos.cond_two{k});
				
end
