function scatter_matrix_bdfun(obj, eventdata)

% scatter_matrix_bdfun
% --------------------
%
% function to enable selection within a scatter matrix

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
% $Revision: 5535 $
% $Date: 2006-07-03 14:00:31 -0400 (Mon, 03 Jul 2006) $
%--------------------------------

%---------------------------------------------------------
% INITIALIZE
%---------------------------------------------------------

%--
% get parent figure
%--

par = ancestor(obj, 'figure');

%--
% get axes array data from support axes
%--

support = findobj(par,'type','axes','tag','support');

data = get(support,'userdata');

%---------------------------------------------------------
% DELETE PREVIOUS SELECTION
%---------------------------------------------------------

%--
% delete selection box and grid lines
%--

delete(findobj(par,'tag','SCATTER_SELECTION'));

%--
% erase selection modifications
%--

set(findobj(par,'tag','SCATTER_DATA_POINT'),'edgecolor',[0 0 1]);

%---------------------------------------------------------
% PERFORM SELECTION
%---------------------------------------------------------	

%--
% get selection points and compute anchor and offset representation
%--

p1 = get(obj,'CurrentPoint'); r = rbbox; p2 = get(obj,'CurrentPoint');	

p1 = p1(1, 1:2);	p2 = p2(1, 1:2);
		
p0 = max(p1, p2); p1 = min(p1, p2); p2 = p0; dp = p2 - p1;

%--
% return for small selections
%--

% NOTE: this should be the point selection behavior, then consider double click

TOL = 0.001;

if (dp(1) < TOL) || (dp(2) < TOL)
	return;
end

%--
% enforce axes limits
%--

xl = get(obj,'xlim');

if (p1(1) < xl(1))
	p1(1) = xl(1); dp(1) = p2(1) - p1(1);
end

if (p2(1) > xl(2))
	p2(1) = xl(2); dp(1) = p2(1) - p1(1);
end

yl = get(obj,'ylim');

if (p1(2) < yl(1))
	p1(2) = yl(1); dp(2) = p2(2) - p1(2);
end

if (p2(2) > yl(2))
	p2(2) = yl(2); dp(2) = p2(2) - p1(2);
end

%---------------------------------------------------------
% DISPLAY SELECTION
%---------------------------------------------------------

%--
% get selection display properties
%--

color.line = [1, 0, 0];

color.patch = color.line;

color.grid = 0.5 * ones(1,3);

linestyle = '-';

linewidth = 0.5;

alpha = 0;

%--
% set renderer
%--

if ~alpha
	set(par, 'renderer', 'painters');
else
	set(par, 'renderer', 'opengl');
end

%--
% compute polygon vertex representation of selection
%--

x = [p1(1), p1(1) + dp(1), p1(1) + dp(1), p1(1), p1(1)];

y = [p1(2), p1(2), p1(2) + dp(2), p1(2) + dp(2), p1(2)];

%--
% draw selection in selection axes
%--

g = [];

g(end + 1) = line(x, y, ...
	'parent', obj, ...
	'LineStyle',linestyle, ...
	'Color',color.line, ...
	'LineWidth',linewidth, ...
	'EraseMode','normal', ...
	'UserData',1 ...
);

if alpha
	g(end + 1) = patch(...
		'parent', obj, ...
		'xdata',x, ...
		'ydata',y, ...
		'EdgeColor','none', ...
		'FaceColor',color.patch, ...
		'FaceAlpha',alpha, ...
		'UserData', 2 ...
	);
else
	g(end + 1) = patch(...
		'parent', obj, ...
		'xdata',x, ...
		'ydata',y, ...
		'EdgeColor','none', ...
		'FaceColor','none', ...
		'UserData', 2 ...
	);
end

%--
% compute grid line data
%--

yl = [yl(1), y(1), nan, y(3), yl(2)]; 

xl = [xl(1), x(1), nan, x(2), xl(2)];

%--
% draw grid on selection axes
%--

g(end + 1) = line(x(1) * ones(1,5), yl, ...
	'UserData',3 ...
);

g(end + 1) = line(x(2) * ones(1,5), yl, ...
	'UserData',4 ...
);

g(end + 1) = line(xl, y(1) * ones(1,5), ...
	'UserData',5 ...
);

g(end + 1) = line(xl, y(3) * ones(1,5), ...
	'UserData',6 ...
);

set(g(end - 3:end), ...
	'parent', obj, ...
	'linestyle', ':', ...
	'Color', color.grid, ...
	'Linewidth', 0.5, ...
	'hittest', 'off' ...
);

%--
% draw grid on related axes
%--

[i,j] = find(data.child == obj);

%--
% get row related axes
%--

hr = data.child(i,:); ix = find(hr == obj); hr(ix) = [];

for k = 1:length(hr)
	
	%--
	% check and set axes
	%--
	
	if strcmp(get(hr(k), 'visible'), 'off')
		continue;
	end
	
	axes(hr(k));
	
	%--
	% compute polygon vertex representation of row related selections
	%--
	
	xl = get(hr(k),'xlim');
	
	x = [xl(1), xl(2), xl(2), xl(1), xl(1)];
	
	y = [p1(2), p1(2), p1(2) + dp(2), p1(2) + dp(2), p1(2)];
	
	%--
	% draw line
	%--
	
	g(end + 1) = line(x, y, ...
		'LineStyle',':', ...
		'Color',[0 0 0], ...
		'LineWidth',0.5, ...
		'EraseMode','normal', ...
		'hittest','off', ...
		'UserData',7 ...
	);
	
	%--
	% draw patch
	%--
	
	if alpha
		g(end + 1) = patch(...
			'parent', obj, ...
			'xdata',x, ...
			'ydata',y, ...
			'EdgeColor','none', ...
			'FaceColor',color.patch, ...
			'FaceAlpha',alpha, ...
			'hittest','off', ...
			'UserData',8 ...
		);
	else
		g(end + 1) = patch(...
			'parent', obj, ...
			'xdata',x, ...
			'ydata',y, ...
			'EdgeColor','none', ...
			'FaceColor','none', ...
			'hittest','off', ...
			'UserData',8 ...
		);
	end
	
end

%--
% get column related axes
%--

hr = data.child(:,j); ix = find(hr == obj); hr(ix) = [];

for k = 1:length(hr)
	
	%--
	% check and set axes
	%--
	
	if (strcmp(get(hr(k),'visible'),'off'))
		continue;
	end
	
	axes(hr(k));
	
	%--
	% compute polygon vertex representation of column related selections
	%--
	
	x = [p1(1), p1(1) + dp(1), p1(1) + dp(1), p1(1), p1(1)];
	
	yl = get(hr(k),'ylim');
	
	y = [yl(1), yl(1), yl(2), yl(2), yl(1)];
	
	%--
	% draw line
	%--
	
	tmp = line( ...
		'xdata',x, ...
		'ydata',y, ... 
		'LineStyle',':', ...
		'Color',[0 0 0], ...
		'LineWidth',0.5, ...
		'EraseMode','normal', ...
		'hittest','off', ...
		'UserData',9 ...
	);
	
	g = [g tmp];
	
	%--
	% draw patch
	%--
	
	if (alpha > 0)
		tmp = patch( ...
			'xdata',x, ...
			'ydata',y, ...
			'EdgeColor','none', ...
			'FaceColor',color.patch, ...
			'FaceAlpha',alpha, ...
			'hittest','off', ...
			'UserData',10 ...
		);
	else
		tmp = patch( ...
			'xdata',x, ...
			'ydata',y, ...
			'EdgeColor','none', ...
			'FaceColor','none', ...
			'hittest','off', ...
			'UserData',10 ...
		);
	end
	
	g = [g tmp];
	
end

%---------------------------------------------------------
% create control points for editing
%---------------------------------------------------------

axes(obj);

cx = (p1(1) + p2(1)) / 2;
cy = (p1(2) + p2(2)) / 2;

ctrl = [ ...
	p2(1), cy; ...
	p2; ...
	cx, p2(2); ...
	p1(1), p2(2); ...
	p1(1), cy; ...
	p1; ...
	cx, p1(2); ...
	p2(1), p1(2); ...
	cx, cy ...
];

for k = 1:9
	
	tmp = line( ...
		'xdata',ctrl(k,1), ...
		'ydata',ctrl(k,2), ...
		'marker','s', ...
		'color', color.line, ...
		'linewidth', 0.5, ...
		'markersize',4, ... % 'markersize',5, ...
		'ButtonDownFcn',['scatter_selection_edit(''start'',' int2str(k) ')'], ...
		'UserData', 10 + k ...
	);

	g = [g tmp];
	
end

% change center control point marker

set(tmp,'marker','+');

%---------------------------------------------------------
% tag selection display objects
%---------------------------------------------------------

set(g,'tag','SCATTER_SELECTION');

%---------------------------------------------------------
% HIGHLIGHT SELECTED POINTS
%---------------------------------------------------------

data = get(par,'userdata');

X = data.scatter_matrix.X;

name = data.scatter_matrix.name;

id = data.scatter_matrix.id;

%--
% select on x axis variable
%--

Y = X(:,j);

xl = [p1(1),p1(1) + dp(1)];

ix = find((Y >= xl(1)) & (Y <= xl(2)));

%--
% select on y axis variable
%--

Y = X(ix,i);

yl = [p1(2),p1(2) + dp(2)];

ix2 = find((Y >= yl(1)) & (Y <= yl(2)));

%--
% dereference last indices and get ids
%--

ix = ix(ix2);

id = id(ix);

%--
% color the patches with those ids
%--

tmp = findobj(par,'tag','SCATTER_DATA_POINT');

for k = 1:3
	try
		for k = 1:tmp
			if (any(id == get(tmp(k),'userdata')))
				set(tmp(k),'edgecolor',[0 1 0]);
			end
		end
	catch
		disp('some error ...');
	end
end




%---------------------------------------------------
% SELECTION_GRID
%---------------------------------------------------

function selection_grid(sel, ax, type)

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% set display options
%--

opt.color.line = 0.25 * ones(1,3);

%----------------------------
% UPDATE GRIDS
%----------------------------

%--
% build grid line tags
%--

tag1 = ['SEL_GRID_', upper(type), '1']; tag2 = ['SEL_GRID_', upper(type), '2'];

%--
% clear grid when there is no selection
%--

if isempty(sel)	
	delete(findobj(ax, 'tag', tag1)); delete(findobj(ax, 'tag', tag2)); return
end

%--
% get line data from selection
%--

switch type

	case 'x', x1 = sel.anchor(1) * ones(1,2); x2 = x1 + sel.offset(1);

	case 'y', y1 = sel.anchor(2) * ones(1,2); y2 = y1 + sel.offset(2);

end
	
%--
% update grid display
%--

for k = 1:length(ax)
	
	%--
	% skip invisible axes
	%--
	
	if strcmp(get(ax(k), 'visible'), 'off')
		continue;
	end
	
	%--
	% get line data from axes
	%--
	
	switch type
		
		case 'x', ylim = get(ax(k), 'ylim'); y1 = ylim; y2 = ylim;
			
		case 'y', xlim = get(ax(k), 'xlim'); x1 = xlim; x2 = xlim;
			
	end
	
	%--
	% update start grid
	%--
	
	handle = findobj(ax(k), 'tag', tag1); 
	
	if isempty(handle)
		line(x1, y1, ...
			'parent', ax(k), ...
			'tag', tag1, ...
			'LineStyle', ':', ...
			'Color', opt.color.line, ...
			'LineWidth', 0.5, ...
			'EraseMode', 'normal', ...
			'hittest', 'off' ...
		);
	else
		set(handle, 'xdata', x1, 'ydata', y1);
	end

	%--
	% update stop grid
	%--
	
	handle = findobj(ax(k), 'tag', tag2);
	
	if isempty(handle)
		line(x2, y2, ...
			'parent', ax(k), ...
			'LineStyle', ':', ...
			'Color', opt.color.line, ...
			'LineWidth', 0.5, ...
			'EraseMode', 'normal', ...
			'hittest', 'off' ...
		);
	else
		set(handle, 'xdata', x2, 'ydata', y2);
	end
	
end


%---------------------------------------------------
% SELECTION_CONTROL
%---------------------------------------------------

function selection_control(sel, ax, opt)

%----------------------------
% COMPUTE LINE DATA
%----------------------------

p1 = sel.anchor; p2 = sel.anchor + sel.offset;

c = (p1 + p2) / 2;
	
ctrl = [ ...
	p2(1), c(2); ...
	p2; ...
	c(1), p2(2); ...
	p1(1), p2(2); ...
	p1(1), c(2); ...
	p1; ...
	c(1), p1(2); ...
	p2(1), p1(2); ...
	c(1), c(2) ...
];

%----------------------------
% CREATE CONTROL POINTS
%----------------------------
	
for k = 1:9
	
	tmp = line( ...
		'parent', ax, ...
		'xdata', ctrl(k,1), ...
		'ydata', ctrl(k,2), ...
		'marker', 's', ...
		'color', color.line, ...
		'linewidth', 0.5, ...
		'markersize', 4, ...
		'ButtonDownFcn', ['scatter_selection_edit(''start'',' int2str(k) ')'], ...
		'UserData', 10 + k ...
	);

	g = [g tmp];
	
end
	
	
	
	
	
