function hist_view(X,n,b,Z)

% hist_view - create histogram view of data
% -----------------------------------------
%
% hist_view(X,n,b,Z)
%
% Input:
% ------
%  X - input image, image stack, or handle to parent figure
%  n - number of bins (def: 128)
%  b - bounds for values (def: min and max of X)
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
% $Date: 2003-10-08 22:51:15-04 $
% $Revision: 1.1 $
%--------------------------------

%--
% image or handle
%--

[X,N,tag,flag] = handle_input(X,inputname(1));

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%--
% compute bounds if needed
%--

if ((nargin < 3) | isempty(b))

	switch (tag)
	
	%--
	% scalar image
	%--
	
	case ({'IMAGE_GRAY','IMAGE_GRAY_U8'})		
		b = fast_min_max(X,Z);
		
	%--
	% multiple plane image
	%--
	
	case ({'IMAGE_RGB','IMAGE_RGB_U8','IMAGE_NDIM','IMAGE_NDIM_U8'})
		for k = 1:size(X,3)
			b{k} = fast_min_max(X(:,:,k),Z);
		end
		
	%--
	% image stack
	%--
	
	% only scalar image stacks are handled correctly
	
	case ('IMAGE_STACK')
		for k = 1:length(X)
			b{k} = fast_min_max(X{k},Z);
		end
		
	end

end

%--
% set number of bins
%--

if ((nargin < 2) | isempty(n))
	n = 128;
end

%--
% compute histogram
%--

[h,c,v] = hist_1d(X,n,b,Z);

%--
% save histogram data in figure userdata
%--

data = get(gcf,'userdata');

% data for histogram computation

data.browser.data = X;
data.browser.bounds = b;
data.browser.mask = Z;

% histogram options

hist.bins = n;

hist.counts = h; 
hist.centers = c;
hist.breaks = v;

hist.view = 1;
hist.color = 'Gray';
hist.linestyle = 'Circle';
hist.linewidth = 1;
hist.patch = -1; % 0.25;

data.browser.hist = hist;
	
% kernel options

kernel.view = 1;
kernel.length = 1/8;
kernel.type = 'Tukey';
kernel.color = 'Dark Gray';
kernel.linestyle = 'Solid';
kernel.linewidth = 1;
kernel.patch = -1; % 0.25;

data.browser.kernel = kernel;

% fit options

fit.view = 0;
fit.model = 'Generalized Gaussian';
fit.color = 'Red';
fit.linestyle = 'Solid';
fit.linewidth = 1;
fit.patch = -1; % 0.25;

data.browser.fit = fit;

% grid options

grid.on = 0;
grid.color = 'Dark Gray';
grid.x = 1;
grid.y = 1;

data.browser.grid = grid;

%--
% display histograms in current figure
%--

switch (tag)
	
%--
% scalar image
%--

case ({'IMAGE_GRAY','IMAGE_GRAY_U8'})
	
	%--
	% normalize and scale histogram counts
	%--

	nh = h / ((c(2) - c(1)) * sum(h));
				
	%--
	% display normalized histogram and tighten axes
	%--
	
	ax = axes;
	
	tmp = plot(c,nh, ...
		'color',color_to_rgb(hist.color), ...
		'linestyle',linestyle_to_str(hist.linestyle), ...
		'linewidth',hist.linewidth ...
	);
	
	set(tmp,'tag','histogram');
	
	tmp = axis;
	axis([v(1) v(end) tmp(3:4)]);
	
	%--
	% display patch histogram
	%--
	
	if (hist.patch > 0)
		
		hold on;
		
		px = [c(1), c, c(end), c(1)];
		py = [0, nh, 0, 0];
		
		tmp = patch(px,py,color_to_rgb(hist.color));
		
		set(tmp,'tag','histogram');
		set(tmp,'facealpha',hist.patch);
		set(tmp,'linestyle','none');
		
	end
	
	%--
	% annotate plot
	%--
	
	if (~isempty(N))
		title_edit(['Normalized Histogram of ' N]);
	else
		title_edit('Normalized Histogram');
	end
	
	%--
	% compute summmaries, these are computed only once
	%--
	
	% select data and convert to double
	
	if (~isempty(Z))
		ix = find(Z);
		tmp = X(ix);
	else
		tmp = X(:);
	end
	
	tmp = double(tmp);
	
	if (~isempty(Z))
		summary.count = sum(Z(:));
	else
		summary.count = prod(size(X));
	end
	
	summary.range = fast_min_max(tmp);
	
	summary.mean = mean(tmp(:));
	summary.variance = var(tmp(:));
	summary.skewness = skewness(tmp(:));
	summary.kurtosis = kurtosis(tmp(:));
	
	summary.median = fast_median(tmp);
	summary.mad = fast_mad(tmp);
	summary.quart25 = fast_rank(tmp,0.25);
	summary.quart75 = fast_rank(tmp,0.75);
	summary.iqr = summary.quart75 - summary.quart25;
	
	data.browser.summary = summary;
	
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
	
	set(ax,'uicontextmenu',tmp);
	
	L = { ...
		'Data', ...
		'Model' ...
	};
	
	n = length(L);
	S = bin2str(zeros(1,n));
	
	tmp = menu_group(tmp,'',L,S);
	
	L = { ...
		['N: ' num2str(summary.count)], ...
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
		
	menu_group(get_menu(tmp,'Data'),'',L,S);
	
%--
% multiple plane image
%--

case ({'IMAGE_RGB','IMAGE_RGB_U8','IMAGE_NDIM','IMAGE_NDIM_U8'})
	
	for k = 1:length(h)
	
		%--
		% normalize and scale histogram counts
		%--

		nh{k} = h{k} / ((c{k}(2) - c{k}(1)) * sum(h{k}));
		
		%--
		% create subplot
		%--
		
		ax(k) = subplot(length(h),1,k);
		
		%--
		% display normalized histogram with tight axes
		%--
		
		tmp = plot(c{k},nh{k}, ...
			'color',color_to_rgb(hist.color), ...
			'linestyle',linestyle_to_str(hist.linestyle), ...
			'linewidth',hist.linewidth ...
		);
	
		set(tmp,'tag','histogram');
		
		tmp = axis;
		axis([v{k}(1) v{k}(end) tmp(3:4)]);	
		
		%--
		% display patch histogram
		%--
		
		if (hist.patch > 0)
			
			hold on;
			
			px = [c{k}(1), c{k}, c{k}(end), c{k}(1)];
			py = [0, nh{k}, 0, 0];
			
			tmp = patch(px,py,color_to_rgb(hist.color));
			
			set(tmp,'tag','histogram');
			set(tmp,'facealpha',hist.patch);
			set(tmp,'linestyle','none');
			
		end
		
		%--
		% annotate plots
		%--
		
		if (~isempty(N))
			if (k == 1)
				title_edit(['Normalized Histograms of ' N]);
			end
			ylabel_edit([N ' \pb{:,:' num2str(k) '}']);
		else
			if (k == 1)
				title_edit('Normalized Histograms');
			end
			ylabel_edit(['Plane ' num2str(k)]);
		end
		
	end

	%--
	% compute summmaries, these are computed only once
	%--
		
	for k = 1:length(h)
		
		% select data and convert to double
		
		if (~isempty(Z))
			ix = find(Z);
			tmp = X(:,:,k);
			tmp = tmp(ix);
		else 
			tmp = X(:,:,k);
			tmp = tmp(:);
		end
		
		tmp = double(tmp);
		
		summary.range = fast_min_max(tmp);
		
		summary.mean = mean(tmp);
		summary.variance = var(tmp);
		summary.skewness = skewness(tmp);
		summary.kurtosis = kurtosis(tmp);
		
		summary.median = fast_median(tmp);
		summary.mad = fast_mad(tmp);
		summary.quart25 = fast_rank(tmp,0.25);
		summary.quart75 = fast_rank(tmp,0.75);
		summary.iqr = summary.quart75 - summary.quart25;
		
		data.browser.summary(k) = summary;
		
		%--
		% put summary information in contextual menu
		%--
		
		tmp = uicontextmenu;
		set(tmp,'tag',['context.' num2str(k)]);
		
		set(ax(k),'uicontextmenu',tmp);
		
		L = { ...
			'Data', ...
			'Model' ...
		};
	
		n = length(L);
		S = bin2str(zeros(1,n));
		
		tmp = menu_group(tmp,'',L,S);
		
		L = { ...
			['N: ' num2str(prod(size(X(:,:,k))))], ...
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
			
		menu_group(get_menu(tmp,'Data'),'',L,S);
		
		%--
		% display mean and median summaries
		%--
		
		axes(ax(k));
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
		
	end
	
%--
% image stack
%--

% only scalar image stacks are handled correctly

case ('IMAGE_STACK')
	
	for k = 1:length(h)
	
		%--
		% normalize and scale histogram counts
		%--

		nh{k} = h{k} / ((c{k}(2) - c{k}(1)) * sum(h{k}));
		
		%--
		% create subplot
		%--
		
		ax(k) = subplot(length(h),1,k);
		
		%--
		% display normalized histogram with tight axes
		%--
		
		tmp = plot(c{k},nh{k}, ...
			'color',color_to_rgb(hist.color), ...
			'linestyle',linestyle_to_str(hist.linestyle), ...
			'linewidth',hist.linewidth ...
		);
	
		set(tmp,'tag','histogram');
		
		tmp = axis;
		axis([v{k}(1) v{k}(end) tmp(3:4)]);	
		
		%--
		% display patch histogram
		%--
		
		if (hist.patch > 0)
			
			hold on;
			
			px = [c{k}(1), c{k}, c{k}(end), c{k}(1)];
			py = [0, nh{k}, 0, 0];
			
			tmp = patch(px,py,color_to_rgb(hist.color));
			
			set(tmp,'tag','histogram');
			set(tmp,'facealpha',hist.patch);
			set(tmp,'linestyle','none');
			
		end
		
		%--
		% annotate plots
		%--
		
		if (~isempty(N))
			if (k == 1)
				title_edit(['Normalized Histograms of ' N]);
			end
			ylabel_edit([N ' \cb{' num2str(k) '}']);
		else
			if (k == 1)
				title_edit('Normalized Histograms');
			end
			ylabel_edit(['Frame ' num2str(k)]);
		end
		
	end

	%--
	% compute summmaries, these are computed only once
	%--
		
	for k = 1:length(h)
		
		summary.range = fast_min_max(X{k});
		
		tmp = X{k};
		tmp = tmp(:);
		
		summary.mean = mean(tmp);
		summary.variance = var(tmp);
		summary.skewness = skewness(tmp);
		summary.kurtosis = kurtosis(tmp);
		
		summary.median = fast_median(X{k});
		summary.mad = fast_mad(X{k});
		summary.quart25 = fast_rank(X{k},0.25);
		summary.quart75 = fast_rank(X{k},0.75);
		summary.iqr = summary.quart75 - summary.quart25;
		
		data.browser.summary(k) = summary;
		
		%--
		% put summary information in contextual menu
		%--
		
		tmp = uicontextmenu;
		set(tmp,'tag',['context.' num2str(k)]);
		
		set(ax(k),'uicontextmenu',tmp);
		
		L = { ...
			'Data', ...
			'Model' ...
		};
	
		n = length(L);
		S = bin2str(zeros(1,n));
		
		tmp = menu_group(tmp,'',L,S);
		
		L = { ...
			['N: ' num2str(prod(size(X{k})))], ...
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
			
		menu_group(get_menu(tmp,'Data'),'',L,S);
		
		%--
		% display mean and median summaries
		%--
		
		axes(ax(k));
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
		
	end
	
end

%--
% add axes to userdata
%--

data.browser.axes = ax;

%--
% save userdata
%--

set(gcf,'userdata',data);

%--
% setup histogram menu and make keystrokes available
%--

hist_menu(gcf);
hist_kpfun(gcf);

c = gcf;

%--
% make refreshing more convenient
%--

set(gcf,'windowbuttondownfcn','refresh;');

%--
% create button bar for models
%--

% fig;
% 
% L = { ...
% 	'Fit Model',''; ...
% 	'Gaussian','Generalized Gaussian'; ...
% 	'Log-Gaussian','Exponential'; ...
% 	'Gamma','Rayleigh' ...
% };
% 
% button_group(gcf,'hist_menu','Model To Fit',L,[],[],c);

% data.browser.children = gcf;
% 
% set(c,'userdata',data);
% 
% hist_view_bdfun(c);
% 

