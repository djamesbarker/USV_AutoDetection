function hist2_view(X,Y,n,b,Z)

% hist2_view - create 2 dimensional histogram view of data
% --------------------------------------------------------
%
% hist2_view(X,Y,n,b,Z)
% hist2_view(X,p,n,b,Z)
%
% Input:
% ------
%  X, Y - input data
%  p - planes or frames to use
%  n - number of bins (def: 128)
%  b - value bounds (def: range of values)
%  Z - computation mask (def: [])

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
% $Date: 2003-09-16 01:32:04-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% set mask
%--

if (nargin < 5)
	Z = [];
end

%--
% get planes or frames and names for these if possible
%--

if (ndims(X) == 3)
	
	p = Y;
	Y = X(:,:,p(2));
	X = X(:,:,p(1));
	flag = 1;
	
	if (~isempty(inputname(1)))
		N{1} = [inputname(1) '(:,:,' num2str(p(1)) ')'];
		N{2} = [inputname(1) '(:,:,' num2str(p(2)) ')'];
	else
		N{1} = 'X';
		N{2} = 'Y';
	end
	
elseif (iscell(X))
	
	p = Y;
	Y = X{p(2)};
	X = X{p(1)};
	
	if (~isempty(inputname(1)))
		N{1} = [inputname(1) '{' num2str(p(1)) '}'];
		N{2} = [inputname(1) '{' num2str(p(2)) '}'];
	else
		N{1} = 'X';
		N{2} = 'Y';
	end
	
else
	
	flag = 0;
	
	if (~isempty(inputname(1)))
		N{1} = inputname(1);
	else
		N{1} = 'X';
	end
	if (~isempty(inputname(2)))
		N{2} = inputname(2);
	else
		N{2} = 'Y';
	end
	
end

%--
% set bounds
%--

if ((nargin < 4) | isempty(b))
	b = [fast_min_max(X); fast_min_max(Y)];	
elseif (all(size(b) == [1,2]))
	b = [b; b];
end
	
%--
% set number of bins
%--

if ((nargin < 3) | isempty(n))
	n = [128,128];
elseif (length(n) == 1)
	n = [n,n];
end

%--
% set axes position parameters
%--

p.left = 0.075;
p.right = 0.075;

p.top = 0.075;
p.bottom = 0.075;

p.marginal = 0.3;
p.space = 0.025;

%--
% create Y marginal axes
%--

left = p.left;
bottom = p.bottom + p.marginal + p.space;
width = p.marginal;
height = 1 - (bottom + p.top);

ax.y = axes('position',[left,bottom,width,height]);
set(ax.y,'tag','Y');

%--
% create X marginal axes
%--

left = p.left + p.marginal + p.space;
bottom = p.bottom;
width = 1 - (left + p.right);
height = p.marginal;

ax.x = axes('position',[left,bottom,width,height]);
set(ax.x,'tag','X');

%--
% create XY joint histogram axes
%--

left = p.left + p.marginal + p.space;
bottom = p.bottom + p.marginal + p.space;
width = 1 - (left + p.right);
height = 1 - (bottom + p.top);

ax.xy = axes('position',[left,bottom,width,height]);
set(ax.xy,'tag','XY');

%--
% compute joint histogram
%--

[H,c,v] = hist_2d(X,Y,n,b,Z);

%--
% compute marginal histograms
%--

hx = sum(H,1);
hy = sum(H,2)';

%--
% save histogram data in figure userdata
%--

data = get(gcf,'userdata');

% displayed axes

data.hist2_menu.axes = ax;

% data for histogram computation

data.hist2_menu.data.X = X;
data.hist2_menu.data.Y = Y;

data.hist2_menu.bounds = b;
data.hist2_menu.mask = Z;

% histogram options

hist.bins = n;
% hist.bins(1) = n(1);
% hist.bins(2) = n(2);

hist.counts.xy = H;
hist.counts.x = hx;
hist.counts.y = hy;

hist.centers = c;
% hist.centers.x = c.x;
% hist.centers.y = c.y;

hist.breaks = v;
% hist.breaks.x = v.x;
% hist.breaks.y = v.y;

hist.view = 1;
hist.color = 'Gray';
hist.linestyle = 'Solid';
hist.linewidth = 1;
hist.patch = -1; % 0.25;

data.hist2_menu.hist = hist;
	
% kernel options

kernel.view = 1;

kernel.x.length = 1/8;
kernel.x.type = 'Tukey';
kernel.y.length = 1/8;
kernel.y.type = 'Tukey';

kernel.color = 'Dark Gray';
kernel.linestyle = 'Dash';
kernel.linewidth = 2;
kernel.patch = -1; % 0.25;

data.hist2_menu.kernel = kernel;

% fit options

fit.view = 0;

fit.x.model = 'Generalized Gaussian';
fit.y.model = 'Generalized Gaussian';

fit.color = 'Red';
fit.linestyle = 'Solid';
fit.linewidth = 2;
fit.patch = -1; % 0.25;

data.hist2_menu.fit = fit;

% colormap

data.hist2_menu.colormap = 'Bone';

% grid options

grid.on = 0;
grid.color = 'Dark Gray';
grid.x = 1;
grid.y = 1;

data.hist2_menu.grid = grid;

set(gcf,'userdata',data);

%--
% display X marginal histogram
%--

%--
% normalize and scale histogram counts
%--

nhx = hx / ((c.x(2) - c.x(1)) * sum(hx));
			
%--
% display normalized histogram and tighten axes
%--

% ax = findobj(gcf,'type','axes','tag','X');
axes(ax.x);

tmp = plot(c.x,nhx, ...
	'color',color_to_rgb(hist.color), ...
	'linestyle',linestyle_to_str(hist.linestyle), ...
	'linewidth',hist.linewidth ...
);

set(tmp,'tag','histogram');

tmp = axis;
axis([v.x(1) v.x(end) tmp(3:4)]);
% axis([b(1,:) tmp(3:4)]);

hold on;

%--
% display patch histogram
%--

if (hist.patch > 0)
	
	hold on;
	
	px = [c.x(1), c.x, c.x(end), c.x(1)];
	py = [0, nhx, 0, 0];
	
	tmp = patch(px,py,color_to_rgb(hist.color));
	
	set(tmp,'tag','histogram');
	set(tmp,'facealpha',hist.patch);
	set(tmp,'linestyle','none');
	
end

%--
% annotate plot
%--

xlabel_edit(N{1});

%--
% compute summmaries
%--
	
summary.range = fast_min_max(X);

summary.mean = mean(X(:));
summary.variance = var(X(:));
summary.skewness = skewness(X(:));
summary.kurtosis = kurtosis(X(:));

summary.median = fast_median(X);
summary.mad = fast_mad(X);
summary.quart25 = fast_rank(X,0.25);
summary.quart75 = fast_rank(X,0.75);
summary.iqr = summary.quart75 - summary.quart25;

data.hist2_menu.summary = summary;

%--
% display mean and median summaries
%--

hold on;

x = summary.mean;
tmp = axis;
	
tmp = plot([x,x],tmp(3:4), ...
	'color',color_to_rgb(hist.color), ...
	'linestyle',linestyle_to_str('Dash'), ...
	'linewidth',hist.linewidth ...
);

set(tmp,'tag','mean');

x = summary.median;
tmp = axis;

tmp = plot([x,x],tmp(3:4), ...
	'color',color_to_rgb(hist.color), ...
	'linestyle',linestyle_to_str('Solid'), ...
	'linewidth',hist.linewidth ...
);

set(tmp,'tag','median');

%--
% put summary information in contextual menu
%--

tmp = uicontextmenu;
set(tmp,'tag','context');

set(ax.x,'uicontextmenu',tmp);

L = { ...
	'X Data', ...
	'X Model' ...
};

n = length(L);
S = bin2str(zeros(1,n));

tmp = menu_group(tmp,'',L,S);

L = { ...
	['N: ' num2str(prod(size(X)))], ...
	['Min: ' mat2str(summary.range(1),3)], ...
	['Max: ' num2str(summary.range(2),3)], ...
	['Mean: ' num2str(summary.mean,3)], ...
	['Deviation: ' num2str(sqrt(summary.variance),3)], ...
	['Skewness: ' num2str(summary.skewness,3)], ...
	['Kurtosis: ' num2str(summary.kurtosis,3)], ...
	['Median: ' num2str(summary.median,3)], ...
	['MAD: ' num2str(summary.mad,3)], ...
	['Lower Quartile: ' num2str(summary.quart25,3) ' (-' num2str(summary.median - summary.quart25) ')'], ...
	['Upper Quartile: ' num2str(summary.quart75,3) ' (+' num2str(summary.quart75 - summary.median) ')'], ...
	['IQR: ' num2str(summary.iqr,3)] ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{2} = 'on';
S{4} = 'on';
S{8} = 'on';
	
menu_group(get_menu(tmp,'X Data'),'',L,S);

%--
% display Y marginal histogram
%--

%--
% normalize and scale histogram counts
%--

nhy = hy / ((c.y(2) - c.y(1)) * sum(hy));
			
%--
% display normalized histogram and tighten axes
%--

% ax = findobj(gcf,'type','axes','tag','Y');
axes(ax.y);

tmp = plot(nhy,c.y, ...
	'color',color_to_rgb(hist.color), ...
	'linestyle',linestyle_to_str(hist.linestyle), ...
	'linewidth',hist.linewidth ...
);

set(tmp,'tag','histogram');
set(ax.y,'xaxislocation','top');

tmp = axis;
% axis([tmp(1:2) v.y(1) v.y(end)]);
% axis([tmp(1:2) b(2,:)]);

hold on;

%--
% display patch histogram
%--

if (hist.patch > 0)
	
	hold on;
	
	px = [c.y(1), c.y, c.y(end), c.y(1)];
	py = [0, nhy, 0, 0];
	
	tmp = patch(py,px,color_to_rgb(hist.color));
	
	set(tmp,'tag','histogram');
	set(tmp,'facealpha',hist.patch);
	set(tmp,'linestyle','none');
	
end

%--
% annotate plot
%--

ylabel_edit(N{2});

%--
% compute summmaries
%--
	
summary.range = fast_min_max(Y);

summary.mean = mean(Y(:));
summary.variance = var(Y(:));
summary.skewness = skewness(Y(:));
summary.kurtosis = kurtosis(Y(:));

summary.median = fast_median(Y);
summary.mad = fast_mad(Y);
summary.quart25 = fast_rank(X,0.25);
summary.quart75 = fast_rank(X,0.75);
summary.iqr = summary.quart75 - summary.quart25;

data.hist2_menu.summary = summary;

%--
% display mean and median summaries
%--

hold on;

x = summary.mean;
tmp = axis;
	
tmp = plot(tmp(1:2),[x,x], ...
	'color',color_to_rgb(hist.color), ...
	'linestyle',linestyle_to_str('Dash'), ...
	'linewidth',hist.linewidth ...
);

set(tmp,'tag','mean');

x = summary.median;
tmp = axis;

tmp = plot(tmp(1:2),[x,x], ...
	'color',color_to_rgb(hist.color), ...
	'linestyle',linestyle_to_str('Solid'), ...
	'linewidth',hist.linewidth ...
);

set(tmp,'tag','median');

%--
% put summary information in contextual menu
%--

tmp = uicontextmenu;
set(tmp,'tag','context');

set(ax.y,'uicontextmenu',tmp);

L = { ...
	'Y Data', ...
	'Y Model' ...
};

n = length(L);
S = bin2str(zeros(1,n));

tmp = menu_group(tmp,'',L,S);

L = { ...
	['N: ' num2str(prod(size(X)))], ...
	['Min: ' mat2str(summary.range(1),3)], ...
	['Max: ' num2str(summary.range(2),3)], ...
	['Mean: ' num2str(summary.mean,3)], ...
	['Deviation: ' num2str(sqrt(summary.variance),3)], ...
	['Skewness: ' num2str(summary.skewness,3)], ...
	['Kurtosis: ' num2str(summary.kurtosis,3)], ...
	['Median: ' num2str(summary.median,3)], ...
	['MAD: ' num2str(summary.mad,3)], ...
	['Lower Quartile: ' num2str(summary.quart25,3) ' (-' num2str(summary.median - summary.quart25) ')'], ...
	['Upper Quartile: ' num2str(summary.quart75,3) ' (+' num2str(summary.quart75 - summary.median) ')'], ...
	['IQR: ' num2str(summary.iqr,3)] ...
};

n = length(L);

S = bin2str(zeros(1,n));
S{2} = 'on';
S{4} = 'on';
S{8} = 'on';
	
menu_group(get_menu(tmp,'Y Data'),'',L,S);

%--
% display XY joint histogram
%--

%--
% normalize and scale histogram
%--

N = sum(H(:));
w = (c.x(2) - c.x(1))*(c.y(2) - c.y(1));
G = H / (w * N);
						
% logarithmic scaling

G = log10(G);			
Z = isfinite(G);
m = double(fast_min_max(G,Z));

%--
% display histogram as image
%--
	
% ax = findobj(gcf,'type','axes','tag','XY');
axes(ax.xy);

% image(G,'CDataMapping','scaled','XData',b(1,:),'YData',b(2,:));
image(G,'CDataMapping','scaled','XData',v.x,'YData',v.y);
set(gca,'Clim',m);
axis('xy');

set(ax.xy,'xticklabel',[]);
set(ax.xy,'yticklabel',[]);

axis([v.x(1) v.x(end) v.y(1) v.y(end)]);
% axis([b(1,:),b(2,:)]);

tmp = get(ax.x,'xtick');
set(ax.xy,'xtick',tmp);

tmp = get(ax.y,'ytick');
set(ax.xy,'ytick',tmp);
	
% set colormap

colormap(flipud(bone));

%--
% set up histogram viewing menu and make keystrokes available
%--

hist2_menu(gcf);
hist2_kpfun(gcf);

% try to make refreshing more convenient

set(gcf,'windowbuttondownfcn','refresh;');

% % add quartile contours
% 
% 	hold on;
% 	
% [v,q] = hist_2d_level(H);
% 
% 	[c,h] = contour(c.x,c.y,median_filter(H/N,se_ball(3)),v);
% set(h,'EdgeColor',ones(1,3),'LineStyle','--');
% 												
% %--
% % label axes
% %--
% 	
% % planes of multiple-plane image
% 
% if (flag)
% 
% 	if (~isempty(inputname(1)))
% 		N1 = [inputname(1) '(:,:,' num2str(p(1)) ')'];
% 		N2 = [inputname(1) '(:,:,' num2str(p(2)) ')'];
% 		T = ['Joint Histogram of ' N1 ' and ' N2];
% 		title_edit(T);
% 		xlabel_edit(N1);
% 		ylabel_edit(N2);
% 	else
% 		N1 = ['[inputname(1)](:,:,' num2str(p(1)) ')'];
% 		N2 = ['[inputname(1)](:,:,' num2str(p(2)) ')'];
% 		T = ['Joint Histogram of ' N1 ' and ' N2];
% 		title_edit(T);
% 		xlabel_edit(N1);
% 		ylabel_edit(N2);
% 	end
% 	
% % separate images
% 
% else
% 	
% 	if (~isempty(inputname(1)))
% 		xlabel_edit(inputname(1));
% 		N1 = inputname(1);
% 	else
% 		xlabel_edit('[inputname(1)]');
% 		N1 = '[inputname(1)]';
% 	end
% 	
% 	if (~isempty(inputname(2)))
% 		ylabel_edit(inputname(2));
% 		N2 = inputname(2);
% 	else
% 		ylabel_edit('[inputname(2)]');
% 		N2 = '[inputname(2)]';
% 	end
% 
% 	T = ['Joint Histogram of ' N1 ' and ' N2];
% 	title_edit(T);
% 	
% end

% titled colorbar

% 			colorbar;
% 			
% 		%--
% 		% histogram and marginals
% 		%--
% 		
% 		case (2)
% 		
% 			%--
% 			% normalize and scale histogram
% 			%--
% 			
% 			N = sum(H(:));
% 			w = (c.x(2) - c.x(1))*(c.y(2) - c.y(1));
% 			G = H / (w * N);
% 						
% 			% compute marginals and product distribution
% 			
% 			wx = (c.x(2) - c.x(1));
% 			Gx = sum(H,1) / (wx * N);
% 						
% 			wy = (c.y(2) - c.y(1));
% 			Gy = sum(H,2) / (wy * N);
% 						
% 			Gxy = Gy*Gx;
% 						
% 			% logarithmic scaling
% 			
% 			G = log10(G);
% 			Z = isfinite(G);
% 			m = double(fast_min_max(G,Z));
% 			
% 			Gxy = log10(Gxy);
% 			Zxy = isfinite(Gxy);
% 			mxy = double(fast_min_max(Gxy,Zxy));
% 			
% 			%--
% 			% JOINT HISTOGRAM
% 			%--
% 			
% 			%--
% 			% display according to data type
% 			%--
% 			
% 			subplot(2,2,2);
% 			
% 			if (isa(X,'double'))
% 	
% 				% display image
% 				
% 				image(G,'CDataMapping','scaled','XData',b(1,:),'YData',b(2,:));
% 				set(gca,'Clim',m);
% 				axis('xy');
% 				
% 				% set aspect ratio
% 				
% % 				r = (b.x(2) - b.x(1)) / (b.y(2) - b.y(1));
% % 				r = min(r,1/r);
% % 				
% % 				if (r > 0.33)
% % 					axis('image');
% % 				end
% 				
% 				% add identity
% 							
% 			elseif (isa(X,'uint8'))
% 				
% 				% display image
% 				
% 				image(G,'CDataMapping','scaled','XData',[0 255],'YData',[0 255]);
% 				set(gca,'Clim',m);
% 				axis('xy');
% 				
% 				% set aspect ratio
% 				
% 				axis('image');
% 									
% 				% add identity
% 				
% 				hold on;
% 				plot([0,255],[0,255],'w:');
% 								
% 			end
% 			
% 			% set colormap
% 			
% 			colormap(hot);
% 			
% 			% add quartile contours
% 			
% 		  	hold on;
% 		 	
% 			[V,q] = hist_2d_level(H);
% 			
% 		 	[tmp,h] = contour(c.x,c.y,median_filter(H/N,se_ball(3)),V);
% 			set(h,'EdgeColor',ones(1,3),'LineStyle','--');
% 															
% 			%--
% 			% label axes
% 			%--
% 				
% 			% planes of multiple-plane image
% 			
% 			if (flag)
% 				
% 				if (~isempty(inputname(1)))
% 					N1 = [inputname(1) '(:,:,' num2str(p(1)) ')'];
% 					N2 = [inputname(1) '(:,:,' num2str(p(2)) ')'];
% 					T = ['Joint Histogram of ' N1 ' and ' N2];
% 					title_edit(T);
% 					xlabel_edit(N1);
% 					ylabel_edit(N2);
% 				else
% 					N1 = ['[inputname(1)](:,:,' num2str(p(1)) ')'];
% 					N2 = ['[inputname(1)](:,:,' num2str(p(2)) ')'];
% 					T = ['Joint Histogram of ' N1 ' and ' N2];
% 					title_edit(T);
% 					xlabel_edit(N1);
% 					ylabel_edit(N2);
% 				end
% 			
% 			% separate images
% 			
% 			else
% 				
% 				if (~isempty(inputname(1)))
% 					xlabel_edit(inputname(1));
% 					N1 = inputname(1);
% 				else
% 					xlabel_edit('[inputname(1)]');
% 					N1 = '[inputname(1)]';
% 				end
% 				
% 				if (~isempty(inputname(2)))
% 					ylabel_edit(inputname(2));
% 					N2 = inputname(2);
% 				else
% 					ylabel_edit('[inputname(2)]');
% 					N2 = '[inputname(2)]';
% 				end
% 
% 				T = ['Joint Histogram of ' N1 ' and ' N2];
% 				title_edit(T);
% 				
% 			end
% 		
% 			% titled colorbar
% 			
% % 			colorbar;
% 			
% 			%--
% 			% MARGINALS
% 			%--
% 			
% 			% normalized histogram
% 			
% 			subplot(2,2,4);
% 			
% 			plot(c.x,Gx,'k-');
% 			if (length(c.x) < 100)
% 				hold on;
% 				plot(c.x,Gx,'ko');
% 			end
% 			
% 			ax = axis;
% 			axis([v.x(1) v.x(end) ax(3:4)]);
% 			
% 			grid on;
% 			
% 			axes_scale_bdfun(gca,'y');
% 			
% 			%--
% 			% label axes
% 			%--
% 			
% 			% planes of multiple-plane image
% 			
% 			if (flag) 
% 			
% 				if (~isempty(inputname(1)))
% 					N1 = [inputname(1) '(:,:,' num2str(p(1)) ')'];
% 					xlabel_edit(['Histogram of ' N1]);
% 				else
% 					N1 = ['[inputname(1)](:,:,' num2str(p(1)) ')'];
% 					xlabel_edit(['Histogram of ' N1]);
% 				end
% 				
% 			% separate images
% 			
% 			else
% 			
% 				if (~isempty(inputname(1)))
% 					xlabel_edit(['Histogram of ' inputname(1)]);
% 				else
% 					xlabel_edit('Histogram of [inputname(1)]');
% 				end
% 			
% 			end
% 			
% 			% normalized histogram
% 			
% 			subplot(2,2,1);
% 			
% 			plot(Gy,c.y,'k-');
% 			if (length(c.y) < 100)
% 				hold on;
% 				plot(Gy,c.y,'ko');
% 			end
% 			
% 			ax = axis;
% 			axis([ax(1:2) v.y(1) v.y(end)]);
% 			set(gca,'XDir','reverse');
% 	% 		set(gca,'YAxisLocation','right');
% 			
% 			grid on;
% 			
% 			axes_scale_bdfun(gca,'x');
% 			
% 			%--
% 			% label axes
% 			%--
% 			
% 			% planes of multiple-plane image
% 			
% 			if (flag) 
% 			
% 				if (~isempty(inputname(1)))
% 					N2 = [inputname(1) '(:,:,' num2str(p(2)) ')'];
% 					ylabel_edit(['Histogram of ' N2]);
% 				else
% 					N2 = ['[inputname(1)](:,:,' num2str(p(2)) ')'];
% 					ylabel_edit(['Histogram of ' N2]);
% 				end
% 				
% 			% separate images
% 			
% 			else
% 			
% 				if (~isempty(inputname(2)))
% 					ylabel_edit(['Histogram of ' inputname(2)]);
% 				else
% 					ylabel_edit('Histogram of [inputname(2)]');
% 				end
% 			
% 			end
% 			
% 			% PRODUCT HISTOGRAM
% 				
% 			%--
% 			% display according to data type
% 			%--
% 			
% 			subplot(2,2,3);
% 			
% 			if (isa(X,'double'))
% 	
% 				% display image
% 				
% 				image(Gxy,'CDataMapping','scaled','XData',b(1,:),'YData',b(2,:));
% 				set(gca,'Clim',mxy);
% 				axis('xy');
% 				
% 				% set aspect ratio
% 				
% % 				r = (b.x(2) - b.x(1)) / (b.y(2) - b.y(1));
% % 				r = min(r,1/r);
% % 				
% % 				if (r > 0.33)
% % 					axis('image');
% % 				end
% 				
% 				% add identity
% 							
% 			elseif (isa(X,'uint8'))
% 				
% 				% display image
% 				
% 				image(Gxy,'CDataMapping','scaled','XData',[0 255],'YData',[0 255]);
% 				set(gca,'Clim',m);
% 				axis('xy');
% 				
% 				% set aspect ratio
% 				
% 				axis('image');
% 									
% 				% add identity
% 				
% 				hold on;
% 	
% 				plot([0,255],[0,255],'w:');
% 								
% 			end
% 			
% 			% set colormap
% 			
% 			colormap(hot);
% 			
% 			% add quartile contours
% 			
% % 		  	hold on;
% % 		 	
% % 			[V,q] = hist_2d_level(Gxy);
% % 			
% % 		 	[tmp,h] = contour(c.x,c.y,median_filter(Gxy/N,se_ball(3)),V);
% % 			set(h,'EdgeColor',ones(1,3),'LineStyle','--');
% 															
% 			%--
% 			% label axes
% 			%--
% 				
% 			if (flag)
% 			
% 				if (~isempty(inputname(1)))
% 					title_edit('Product Distribution');
% 					xlabel_edit([inputname(1) '(:,:,' num2str(p(1)) ')']);
% 					ylabel_edit([inputname(1) '(:,:,' num2str(p(2)) ')']);
% 				else
% 					title_edit('Product Distribution');
% 					xlabel_edit(['[inputname(1)](:,:,' num2str(p(1)) ')']);
% 					ylabel_edit(['[inputname(1)](:,:,' num2str(p(2)) ')']);
% 				end
% 				
% 				if (~isempty(inputname(1)))
% 					N1 = [inputname(1) '(:,:,' num2str(p(1)) ')'];
% 					N2 = [inputname(1) '(:,:,' num2str(p(2)) ')'];
% 					T = ['Product Histogram of ' N1 ' and ' N2];
% 					title_edit(T);
% 					xlabel_edit(N1);
% 					ylabel_edit(N2);
% 				else
% 					N1 = ['[inputname(1)](:,:,' num2str(p(1)) ')'];
% 					N2 = ['[inputname(1)](:,:,' num2str(p(2)) ')'];
% 					T = ['Product Histogram of ' N1 ' and ' N2];
% 					title_edit(T);
% 					xlabel_edit(N1);
% 					ylabel_edit(N2);
% 				end
% 				
% 			% separate images
% 			
% 			else
% 				
% 				if (~isempty(inputname(1)))
% 					xlabel_edit(inputname(1));
% 					N1 = inputname(1);
% 				else
% 					xlabel_edit('[inputname(1)]');
% 					N1 = '[inputname(1)]';
% 				end
% 				
% 				if (~isempty(inputname(2)))
% 					ylabel_edit(inputname(2));
% 					N2 = inputname(2);
% 				else
% 					ylabel_edit('[inputname(2)]');
% 					N2 = '[inputname(2)]';
% 				end
% 
% 				T = ['Product Histogram of ' N1 ' and ' N2];
% 				title_edit(T);
% 				
% 			end
% 		
% 			% titled colorbar
% 			
% % 			colorbar;
% 
% 			I = hist_mutual(H)
% 		
% 	end
% 	
% end
% 
% 
% % 				% add identity
% % 				
% % 				hold on;
% % 				
% % 				m = min(b.x(1),b.y(1));
% % 				M = max(b.x(2),b.y(2));
% % 				
% % 				plot([m; M],[m; M],'w:');
% 
% % 			% titled colorbar
% % 						
% % 			ax = gca;
% % 			
% % 			colorbar;
% % 			
% % 			axes(get(findobj(gcf,'tag','TMW_COLORBAR'),'parent'));
% % 			title('Log 10');
% % 			
% % 			axes(ax);
% 


% %--
% % setup histogram menu
% %--
% 
% hist2_menu(gcf);
% 
