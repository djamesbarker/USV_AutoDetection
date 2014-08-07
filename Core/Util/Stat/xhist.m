function h = xhist(X,n,b,Z)

% xhist - histogram explorer
% --------------------------
%
% h = xhist(X,n,b,Z)
%
% Input:
% ------
%  X - input data
%  n - number of bins (def: 128)
%  b - bounds for values (def: min and max of X)
%  Z - computation mask (def: [])
%
% Output:
% -------
%  h - handle of parent figure

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
% $Date: 2003-03-07 00:14:48-05 $
% $Revision: 1.2 $
%--------------------------------

%-----------------------------------------------------
% HANDLE INPUT
%-----------------------------------------------------

%--
% set mask
%--

if (nargin < 4)
	Z = [];
end

%--
% get dimensions of input data
%--

[r,c,nd] = size(X);

%--
% compute bounds if needed
%--

if ((nargin < 3) | isempty(b))
		
	if (nd > 1)
		for k = 1:size(X,3)
			b{k} = fast_min_max(X(:,:,k),Z);
		end	
	else
		b = fast_min_max(X,Z);		
	end
	
end

%--
% set number of bins if needed
%--

if ((nargin < 2) | isempty(n))
	n = 128;
end

%-----------------------------------------------------
% COMPUTE HISTOGRAM(S)
%-----------------------------------------------------

[H,c,v] = hist_1d(X,n,b,Z);

%-----------------------------------------------------
% DISPLAY HISTOGRAM(S)
%-----------------------------------------------------

%--
% create figure
%--

h = figure;

set(0,'currentfigure',h);

set(h, ...
	'backingstore','on', ...
	'doublebuffer','on', ...
	'numbertitle','off', ...
	'visible','off' ...
);

%--
% create browser structure
%--

browser = xhist_create( ...
	'data',X, ...
	'bounds',b, ...
	'mask',Z ...
);

browser.hist.bins = n;
browser.hist.counts = H;
browser.hist.centers = c;
browser.hist.breaks = v;

%--
% display histograms
%--

if (nd == 1)
	
	%--
	% put histogram computation output into cell array
	%--
	
	% histogram
	
	tmp = H;
	clear H;
	H{1} = tmp;
	
	% centers
	
	tmp = c;
	clear c;
	c{1} = tmp;
	
	% breaks
	
	tmp = v;
	clear v;
	v{1} = tmp;

end

for k = 1:nd
	
	%---------------------------------------------
	% create axes
	%---------------------------------------------
	
	%--
	% create axes
	%--
	
	ax = subplot(nd,1,k);
	axes(ax);
	
	%--
	% store axes in browser structure
	%--
	
	browser.axes(k) = ax;
		
	%---------------------------------------------
	% display normalized histogram
	%---------------------------------------------
			
	%--
	% compute normalized histogram counts
	%--
	
	nH = H{k} / ((c{k}(2) - c{k}(1)) * sum(H{k}));
	
	%--
	% plot histogram
	%--
	
	tmp = plot(c{k},nH, ...
		'color',color_to_rgb(browser.hist.color), ...
		'linestyle',linestyle_to_str(browser.hist.linestyle), ...
		'linewidth',browser.hist.linewidth ...
	);

	set(tmp,'tag','histogram');
	
	browser.lines.hist(k) = tmp;
		
	%--
	% tighten axis
	%--
	
	tmp = axis;
	axis([v{k}(1) v{k}(end) tmp(3:4)]);
	
	%---------------------------------------------
	% compute data summmaries
	%---------------------------------------------
	
	%--
	% select data and convert to double
	%--
	
	if (~isempty(Z))
		ix = find(Z);
		tmp = X(:,:,k);
		tmp = X(ix);
	else
		tmp = X(:,:,k);
	end
	
	tmp = double(tmp);
	
	%--
	% number of data points
	%--
	
	if (~isempty(Z))
		summary.count = sum(Z(:));
	else
		summary.count = prod(size(X(:,:,k)));
	end
	
	%--
	% range (mex)
	%--
	
	summary.range = fast_min_max(tmp);
	
	%--
	% moments (matlab)
	%--
	
	summary.mean = mean(tmp(:));
	
	summary.variance = var(tmp(:));
	
	summary.skewness = skewness(tmp(:));
	
	summary.kurtosis = kurtosis(tmp(:));
	
	%--
	% order statistics (mex)
	%--
	
	summary.median = fast_median(tmp);
	
	summary.mad = fast_mad(tmp);
	
	summary.quart25 = fast_rank(tmp,0.25);
	
	summary.quart75 = fast_rank(tmp,0.75);
	
	summary.iqr = summary.quart75 - summary.quart25;
	
	%--
	% store summaries in browser structure
	%--
	
	browser.summary = summary;
	
	%---------------------------------------------
	% display data summmaries
	%---------------------------------------------
	
	hold on;
	
	%--
	% display mean
	%--
	
	x = summary.mean;
	tmp = axis;
		
	tmp = plot([x,x],tmp(3:4), ...
		'color',color_to_rgb('Red'), ...
		'linestyle','--', ...
		'linewidth',1 ...
	);
	
	set(tmp,'tag','mean');
	
	%--
	% display median
	%--
	
	x = summary.median;
	tmp = axis;
	
	tmp = plot([x,x],tmp(3:4), ...
		'color',color_to_rgb('Green'), ...
		'linestyle','-', ...
		'linewidth',1 ...
	);
	
	set(tmp,'tag','median');
	
	%--
	% put summary information in contextual menu
	%--
	
	tmp = uicontextmenu;
	
	set(tmp,'tag',['context.' num2str(k)]);
	
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

%--
% attach browser structure to figure
%--

data = get(h,'userdata');

data.browser = browser;

set(h,'userdata',data);

%--
% attach menus
%--

xhist_hist_menu(h);

%--
% attach key press function
%--

xhist_kpfun(h);

