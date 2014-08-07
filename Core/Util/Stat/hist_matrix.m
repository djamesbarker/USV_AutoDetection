function hist_matrix(X,n,b,Z,var)

% hist_matrix - create histogram matrix
% -------------------------------------
%
% hist_matrix(X,n,b,Z,var)
% hist_matrix(X,n,b,Z,var)
%
% Input:
% ------
%  X - input data
%  n - number of bins (def: 128)
%  b - value bounds (def: range of values)
%  Z - computation mask (def: [])
%  name - names of variables

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
% $Date: 2003-09-16 01:32:06-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% get size and dimension of data
%--

[mX,nX] = size(X);

%--
% set names
%--

if (nargin < 5)
	for k = 1:nX
		var{k} = ['X(:,' int2str(k) ')'];
	end
else
	if (length(var) ~= nX)
		disp(' ');
		error('Number of names must match number of data columns.');
	end
end

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%--
% set bounds and compute relaxed bounds
%--

if ((nargin < 3) | isempty(b))
	for k = 1:nX
		b(k,:) = fast_min_max(X(:,k),Z);
	end
else
	[mb,nb] = size(b);
	if ((mb ~= nX) | (nb ~= 2))
		disp(' ');
		error('Number of bounds must match number of data columns.');
	end
end

bx = 0.1 * (b(:,2) - b(:,1));
bx = [b(:,1) - bx, b(:,2) + bx];

%--
% set number of bins
%--

if ((nargin < 3) | isempty(n))
	n = 128*ones(nX,1);
else
	[mn,nn] = size(n);
	if ((mn ~= nX) | (nn ~= 1))
		disp(' ');
		error('Number of bin lengths must match number of data columns.');
	end
end

%--
% create figure, axes array, and set labels
%--

f = fig;

p = axes_array;
p.xspace = 0.025;
p.yspace = 0.025;

[h,g] = axes_array(nX,nX,p,f);

for k = 1:nX
	
	axes(h(nX,k));
	xlabel(var{k});
	set(h(1:nX - 1,:),'xtick',[]);
	
	axes(h(k,1));
	ylabel(var{k});
	set(h(k,:),'ylim',bx(k,:));
	set(h(:,2:nX),'ytick',[]);
	
end

set(h,'nextplot','add');
set(h,'box','on');

%--
% compute histograms and display
%--

for k = 1:nX
	
	%--
	% compute normalized histogram
	%--
	
	[hk,ck,vk] = hist_1d(X(:,k),n(k),b(k,:),Z);
	hk = hk / ((ck(2) - ck(1)) * sum(hk));
	
	%--
	% display normalized histogram
	%--
	
	axes(h(k,k));
	plot(ck,hk);
	plot(X(:,k),(1.1 * max(hk)) * ones(mX,1),'r+')
	set(h(:,k),'xlim',bx(k,:));
	set(h(k,k),'ylim',[0, 1.2 * max(hk)]);
	
end

%--
% display scattergrams
%--

for k = 1:nX
	for j = k + 1:nX
		axes(h(k,j))
		plot(X(:,j),X(:,k),'r+');
		axes(h(j,k))
		plot(X(:,k),X(:,j),'r+');
	end
end

%--
% 
% for k = 1
% 	
% end

% %--
% % create Y marginal axes
% %--
% 
% left = p.left;
% bottom = p.bottom + p.marginal + p.space;
% width = p.marginal;
% height = 1 - (bottom + p.top);
% 
% ax.y = axes('position',[left,bottom,width,height]);
% set(ax.y,'tag','Y');
% 
% %--
% % create X marginal axes
% %--
% 
% left = p.left + p.marginal + p.space;
% bottom = p.bottom;
% width = 1 - (left + p.right);
% height = p.marginal;
% 
% ax.x = axes('position',[left,bottom,width,height]);
% set(ax.x,'tag','X');
% 
% %--
% % create XY joint histogram axes
% %--
% 
% left = p.left + p.marginal + p.space;
% bottom = p.bottom + p.marginal + p.space;
% width = 1 - (left + p.right);
% height = 1 - (bottom + p.top);
% 
% ax.xy = axes('position',[left,bottom,width,height]);
% set(ax.xy,'tag','XY');
% 
% %--
% % compute joint histogram
% %--
% 
% [H,c,v] = hist_2d(X,Y,n,b,Z);
% 
% %--
% % compute marginal histograms
% %--
% 
% hx = sum(H,1);
% hy = sum(H,2)';
% 
% %--
% % save histogram data in figure userdata
% %--
% 
% data = get(gcf,'userdata');
% 
% % displayed axes
% 
% data.hist2_menu.axes = ax;
% 
% % data for histogram computation
% 
% data.hist2_menu.data.X = X;
% data.hist2_menu.data.Y = Y;
% 
% data.hist2_menu.bounds = b;
% data.hist2_menu.mask = Z;
% 
% % histogram options
% 
% hist.bins = n;
% % hist.bins(1) = n(1);
% % hist.bins(2) = n(2);
% 
% hist.counts.xy = H;
% hist.counts.x = hx;
% hist.counts.y = hy;
% 
% hist.centers = c;
% % hist.centers.x = c.x;
% % hist.centers.y = c.y;
% 
% hist.breaks = v;
% % hist.breaks.x = v.x;
% % hist.breaks.y = v.y;
% 
% hist.view = 1;
% hist.color = 'Gray';
% hist.linestyle = 'Solid';
% hist.linewidth = 1;
% hist.patch = -1; % 0.25;
% 
% data.hist2_menu.hist = hist;
% 	
% % kernel options
% 
% kernel.view = 1;
% 
% kernel.x.length = 1/8;
% kernel.x.type = 'Tukey';
% kernel.y.length = 1/8;
% kernel.y.type = 'Tukey';
% 
% kernel.color = 'Dark Gray';
% kernel.linestyle = 'Dash';
% kernel.linewidth = 2;
% kernel.patch = -1; % 0.25;
% 
% data.hist2_menu.kernel = kernel;
% 
% % fit options
% 
% fit.view = 0;
% 
% fit.x.model = 'Generalized Gaussian';
% fit.y.model = 'Generalized Gaussian';
% 
% fit.color = 'Red';
% fit.linestyle = 'Solid';
% fit.linewidth = 2;
% fit.patch = -1; % 0.25;
% 
% data.hist2_menu.fit = fit;
% 
% % colormap
% 
% data.hist2_menu.colormap = 'Bone';
% 
% % grid options
% 
% grid.on = 0;
% grid.color = 'Dark Gray';
% grid.x = 1;
% grid.y = 1;
% 
% data.hist2_menu.grid = grid;
% 
% set(gcf,'userdata',data);
% 
% %--
% % display X marginal histogram
% %--
% 
% %--
% % normalize and scale histogram counts
% %--
% 
% nhx = hx / ((c.x(2) - c.x(1)) * sum(hx));
% 			
% %--
% % display normalized histogram and tighten axes
% %--
% 
% % ax = findobj(gcf,'type','axes','tag','X');
% axes(ax.x);
% 
% tmp = plot(c.x,nhx, ...
% 	'color',color_to_rgb(hist.color), ...
% 	'linestyle',linestyle_to_str(hist.linestyle), ...
% 	'linewidth',hist.linewidth ...
% );
% 
% set(tmp,'tag','histogram');
% 
% tmp = axis;
% axis([v.x(1) v.x(end) tmp(3:4)]);
% % axis([b(1,:) tmp(3:4)]);
% 
% hold on;
% 
% %--
% % display patch histogram
% %--
% 
% if (hist.patch > 0)
% 	
% 	hold on;
% 	
% 	px = [c.x(1), c.x, c.x(end), c.x(1)];
% 	py = [0, nhx, 0, 0];
% 	
% 	tmp = patch(px,py,color_to_rgb(hist.color));
% 	
% 	set(tmp,'tag','histogram');
% 	set(tmp,'facealpha',hist.patch);
% 	set(tmp,'linestyle','none');
% 	
% end
% 
% %--
% % annotate plot
% %--
% 
% xlabel_edit(N{1});
% 
% %--
% % compute summmaries
% %--
% 	
% summary.range = fast_min_max(X);
% 
% summary.mean = mean(X(:));
% summary.variance = var(X(:));
% summary.skewness = skewness(X(:));
% summary.kurtosis = kurtosis(X(:));
% 
% summary.median = fast_median(X);
% summary.mad = fast_mad(X);
% summary.quart25 = fast_rank(X,0.25);
% summary.quart75 = fast_rank(X,0.75);
% summary.iqr = summary.quart75 - summary.quart25;
% 
% data.hist2_menu.summary = summary;
% 
% %--
% % display mean and median summaries
% %--
% 
% hold on;
% 
% x = summary.mean;
% tmp = axis;
% 	
% tmp = plot([x,x],tmp(3:4), ...
% 	'color',color_to_rgb(hist.color), ...
% 	'linestyle',linestyle_to_str('Dash'), ...
% 	'linewidth',hist.linewidth ...
% );
% 
% set(tmp,'tag','mean');
% 
% x = summary.median;
% tmp = axis;
% 
% tmp = plot([x,x],tmp(3:4), ...
% 	'color',color_to_rgb(hist.color), ...
% 	'linestyle',linestyle_to_str('Solid'), ...
% 	'linewidth',hist.linewidth ...
% );
% 
% set(tmp,'tag','median');
% 
% %--
% % put summary information in contextual menu
% %--
% 
% tmp = uicontextmenu;
% set(tmp,'tag','context');
% 
% set(ax.x,'uicontextmenu',tmp);
% 
% L = { ...
% 	'X Data', ...
% 	'X Model' ...
% };
% 
% n = length(L);
% S = bin2str(zeros(1,n));
% 
% tmp = menu_group(tmp,'',L,S);
% 
% L = { ...
% 	['N: ' num2str(prod(size(X)))], ...
% 	['Min: ' mat2str(summary.range(1),3)], ...
% 	['Max: ' num2str(summary.range(2),3)], ...
% 	['Mean: ' num2str(summary.mean,3)], ...
% 	['Deviation: ' num2str(sqrt(summary.variance),3)], ...
% 	['Skewness: ' num2str(summary.skewness,3)], ...
% 	['Kurtosis: ' num2str(summary.kurtosis,3)], ...
% 	['Median: ' num2str(summary.median,3)], ...
% 	['MAD: ' num2str(summary.mad,3)], ...
% 	['Lower Quartile: ' num2str(summary.quart25,3) ' (-' num2str(summary.median - summary.quart25) ')'], ...
% 	['Upper Quartile: ' num2str(summary.quart75,3) ' (+' num2str(summary.quart75 - summary.median) ')'], ...
% 	['IQR: ' num2str(summary.iqr,3)] ...
% };
% 
% n = length(L);
% 
% S = bin2str(zeros(1,n));
% S{2} = 'on';
% S{4} = 'on';
% S{8} = 'on';
% 	
% menu_group(get_menu(tmp,'X Data'),'',L,S);
% 
% %--
% % display Y marginal histogram
% %--
% 
% %--
% % normalize and scale histogram counts
% %--
% 
% nhy = hy / ((c.y(2) - c.y(1)) * sum(hy));
% 			
% %--
% % display normalized histogram and tighten axes
% %--
% 
% % ax = findobj(gcf,'type','axes','tag','Y');
% axes(ax.y);
% 
% tmp = plot(nhy,c.y, ...
% 	'color',color_to_rgb(hist.color), ...
% 	'linestyle',linestyle_to_str(hist.linestyle), ...
% 	'linewidth',hist.linewidth ...
% );
% 
% set(tmp,'tag','histogram');
% set(ax.y,'xaxislocation','top');
% 
% tmp = axis;
% % axis([tmp(1:2) v.y(1) v.y(end)]);
% % axis([tmp(1:2) b(2,:)]);
% 
% hold on;
% 
% %--
% % display patch histogram
% %--
% 
% if (hist.patch > 0)
% 	
% 	hold on;
% 	
% 	px = [c.y(1), c.y, c.y(end), c.y(1)];
% 	py = [0, nhy, 0, 0];
% 	
% 	tmp = patch(py,px,color_to_rgb(hist.color));
% 	
% 	set(tmp,'tag','histogram');
% 	set(tmp,'facealpha',hist.patch);
% 	set(tmp,'linestyle','none');
% 	
% end
% 
% %--
% % annotate plot
% %--
% 
% ylabel_edit(N{2});
% 
% %--
% % compute summmaries
% %--
% 	
% summary.range = fast_min_max(Y);
% 
% summary.mean = mean(Y(:));
% summary.variance = var(Y(:));
% summary.skewness = skewness(Y(:));
% summary.kurtosis = kurtosis(Y(:));
% 
% summary.median = fast_median(Y);
% summary.mad = fast_mad(Y);
% summary.quart25 = fast_rank(X,0.25);
% summary.quart75 = fast_rank(X,0.75);
% summary.iqr = summary.quart75 - summary.quart25;
% 
% data.hist2_menu.summary = summary;
% 
% %--
% % display mean and median summaries
% %--
% 
% hold on;
% 
% x = summary.mean;
% tmp = axis;
% 	
% tmp = plot(tmp(1:2),[x,x], ...
% 	'color',color_to_rgb(hist.color), ...
% 	'linestyle',linestyle_to_str('Dash'), ...
% 	'linewidth',hist.linewidth ...
% );
% 
% set(tmp,'tag','mean');
% 
% x = summary.median;
% tmp = axis;
% 
% tmp = plot(tmp(1:2),[x,x], ...
% 	'color',color_to_rgb(hist.color), ...
% 	'linestyle',linestyle_to_str('Solid'), ...
% 	'linewidth',hist.linewidth ...
% );
% 
% set(tmp,'tag','median');
% 
% %--
% % put summary information in contextual menu
% %--
% 
% tmp = uicontextmenu;
% set(tmp,'tag','context');
% 
% set(ax.y,'uicontextmenu',tmp);
% 
% L = { ...
% 	'Y Data', ...
% 	'Y Model' ...
% };
% 
% n = length(L);
% S = bin2str(zeros(1,n));
% 
% tmp = menu_group(tmp,'',L,S);
% 
% L = { ...
% 	['N: ' num2str(prod(size(X)))], ...
% 	['Min: ' mat2str(summary.range(1),3)], ...
% 	['Max: ' num2str(summary.range(2),3)], ...
% 	['Mean: ' num2str(summary.mean,3)], ...
% 	['Deviation: ' num2str(sqrt(summary.variance),3)], ...
% 	['Skewness: ' num2str(summary.skewness,3)], ...
% 	['Kurtosis: ' num2str(summary.kurtosis,3)], ...
% 	['Median: ' num2str(summary.median,3)], ...
% 	['MAD: ' num2str(summary.mad,3)], ...
% 	['Lower Quartile: ' num2str(summary.quart25,3) ' (-' num2str(summary.median - summary.quart25) ')'], ...
% 	['Upper Quartile: ' num2str(summary.quart75,3) ' (+' num2str(summary.quart75 - summary.median) ')'], ...
% 	['IQR: ' num2str(summary.iqr,3)] ...
% };
% 
% n = length(L);
% 
% S = bin2str(zeros(1,n));
% S{2} = 'on';
% S{4} = 'on';
% S{8} = 'on';
% 	
% menu_group(get_menu(tmp,'Y Data'),'',L,S);
% 
% %--
% % display XY joint histogram
% %--
% 
% %--
% % normalize and scale histogram
% %--
% 
% N = sum(H(:));
% w = (c.x(2) - c.x(1))*(c.y(2) - c.y(1));
% G = H / (w * N);
% 						
% % logarithmic scaling
% 
% G = log10(G);			
% Z = isfinite(G);
% m = double(fast_min_max(G,Z));
% 
% %--
% % display histogram as image
% %--
% 	
% % ax = findobj(gcf,'type','axes','tag','XY');
% axes(ax.xy);
% 
% % image(G,'CDataMapping','scaled','XData',b(1,:),'YData',b(2,:));
% image(G,'CDataMapping','scaled','XData',v.x,'YData',v.y);
% set(gca,'Clim',m);
% axis('xy');
% 
% set(ax.xy,'xticklabel',[]);
% set(ax.xy,'yticklabel',[]);
% 
% axis([v.x(1) v.x(end) v.y(1) v.y(end)]);
% % axis([b(1,:),b(2,:)]);
% 
% tmp = get(ax.x,'xtick');
% set(ax.xy,'xtick',tmp);
% 
% tmp = get(ax.y,'ytick');
% set(ax.xy,'ytick',tmp);
% 	
% % set colormap
% 
% colormap(flipud(bone));
% 
% %--
% % set up histogram viewing menu and make keystrokes available
% %--
% 
% hist2_menu(gcf);
% hist2_kpfun(gcf);
% 
% % try to make refreshing more convenient
% 
% set(gcf,'windowbuttondownfcn','refresh;');
