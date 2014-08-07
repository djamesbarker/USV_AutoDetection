function xhist_display(h,mode,data)

% xhist_display - produce histogram explorer display
% -----------------------------------------------
%
% xhist_display(h,mode,data)
%
% Input:
% ------
%  h - parent figure
%  mode - display update mode 'histogram' or 'data'
%  data - density explorer state structure

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
% $Date: 2003-09-16 01:32:07-04 $
%--------------------------------

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

%--
% get figure userdata if needed
%--

if ((nargin < 3) | isempty(data))
	data = get(h,'userdata');
end

%--
% set default update mode
%--

if ((nargin < 2) | isempty(mode))
	mode = 'histogram';
end

%-----------------------------------------------------
% COMPUTE HISTOGRAM
%-----------------------------------------------------

[h,c,v] = hist_1d( ...
	data.browser.data, ...
	data.browser.bins, ...
	data.browser.bounds, ...
	data.browser.mask ...
);

data.browser.counts = h;
data.browser.centers = c;
data.browser.breaks = v;

%-----------------------------------------------------
% HISTOGRAM DISPLAY UPDATE
%-----------------------------------------------------

if (strcmp(mode,'histogram'))

	%--
	% get number of data dimensions from number of axes
	%--
	
	nd = length(data.browser.axes);
	
	%--
	% scalar image
	%--
	
	if (nd == 1)

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
	
	data.hist_menu.summary = summary;
	
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
		['Lower Quartile: ' num2str(summary.quart25,3)], ...
		['Upper Quartile: ' num2str(summary.quart75,3)], ...
		['IQR: ' num2str(summary.iqr,3)] ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{4} = 'on';
	S{8} = 'on';
		
	menu_group(get_menu(tmp,'Data'),'',L,S);

end

%-----------------------------------------------------
% DATA UPDATE
%-----------------------------------------------------

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
	
	data.hist_menu.summary = summary;
	
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
		
		data.hist_menu.summary(k) = summary;
		
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
