function hist_matrix_menu(h,str,flag)

% hist_matrix_menu - histogram viewing tools menu
% -----------------------------------------------
%
% hist_matrix_menu(h,str,flag)
%
% Input:
% ------
%  h - figure handle (def: gcf)
%  str - menu command string (def: 'Initialize')
%  flag - enable flag (def: '')

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
% $Date: 2003-02-18 17:43:20-05 $
% $Revision: 1.24 $
%--------------------------------

%--
% enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Hist'))
		set(get_menu(h,str),'enable',flag);
	end			
	return;			
end

%--
% set command string
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% perform command sequence
%--

if (iscell(str))
	for k = 1:length(str)
		try
			hist_matrix_menu(h,str{k}); 
		end
	end
	return;
end

%--
% set handle
%--

if (nargin < 1)
	h = gcf;
end

%--
% create parameter tables
%--

% color names

[COLOR,SEP_COLOR] = color_to_rgb;

% linestyle names

[LINESTYLE,SEP_LINESTYLE] = linestyle_to_str;

% distribution names

[PDF,SEP_PDF] = prob_to_fun;

% colormap names

[CMAP,SEP_CMAP] = colormap_to_fun;

%--
% main switch
%--

switch (str)

%--
% Initialize
%--

case ('Initialize')
	
	%--
	% check for existing menu
	%--
	
	if (get_menu(h,'Hist'))
		return;
	end

	%--
	% check for existing userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% Image
	%--
	
	L = { ...
		'Hist', ...
		'Histogram', ...
		'Histogram Options', ...
		'Kernel Estimate', ...		
		'Kernel Options', ...		
		'Fit Model', ...	
		'Fit Options', ... 				
		'Linear', ... 		
		'Semi-Log Y', ... 			
		'Semi-Log X', ...		
		'Log-Log', ...
		'Colormap', ...
		'Colormap Options', ...
		'Grid', ...
		'Grid Options' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{6} = 'on';
	S{8} = 'on';
	S{12} = 'on';
	S{14} = 'on';
	
	A = cell(1,n);
	
	tmp = menu_group(h,'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.histogram = tmp;
	
	if (data.hist_matrix_menu.hist.view)
		set(get_menu(tmp,'Histogram'),'check','on');
	end
	
	if (data.hist_matrix_menu.grid.on)
		set(get_menu(tmp,'Grid'),'check','on');
	end
	
	set(get_menu(tmp,'Linear'),'check','on');
	
	%--
	% Histogram Options
	%--
	
	L = { ...
		'Number of Bins', ...
		'Color', ...
		'Line Style', ...
		'Line Width', ...
		'Patch', ...
		'Edit All ...' ...
	};

	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';

	A = cell(1,n);
	
	data.hist_matrix_menu.histogram_options = ...
		menu_group(get_menu(h,'Histogram Options'),'hist_matrix_menu',L,S,A);	

	%--
	% X and Y
	%--
	
	L = {'X','Y'};
	n = length(L);
	S = bin2str(zeros(1,n));
	
	data.hist_matrix_menu.xy_bins = ...
		menu_group(get_menu(h,'Number of Bins'),'hist_matrix_menu',L,S);	
	
	%--
	% Number of Bins
	%--
	
	L = { ...
		'10', ...
		'100', ...	
		'32', ...
		'64', ...
		'128', ...	
		'256', ...		
		'Other Number of Bins ...' ...
	};
	
	n = length(L);

	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{end} = 'on'; 
					
	A = cell(1,n);
	
	tmp = menu_group(get_menu(data.hist_matrix_menu.xy_bins,'X'),'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.x_bins = tmp;
	
	ix = find(data.hist_matrix_menu.hist.bins(1) == [10,100,32,64,128,256]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	else
		set(tmp(end),'check','on');
	end
	
	tmp = menu_group(get_menu(data.hist_matrix_menu.xy_bins,'Y'),'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.y_bins = tmp;
	
	ix = find(data.hist_matrix_menu.hist.bins(2) == [10,100,32,64,128,256]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	else
		set(tmp(end),'check','on');
	end
	
	%--
	% Histogram Color
	%--
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.histogram_options,'Color'), ...
		'hist_matrix_menu',COLOR,SEP_COLOR);
	data.hist_matrix_menu.histogram_color = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.hist.color,COLOR));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Histogram Line Style
	%--
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.histogram_options,'Line Style'), ...
		'hist_matrix_menu',LINESTYLE,SEP_LINESTYLE);
	data.hist_matrix_menu.histogram_linestyle = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.hist.linestyle,LINESTYLE));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Histogram Line Width
	%--
	
	L = {'1','2','3','4'};
	
	n = length(L);
	S = bin2str(zeros(1,n));
	A = cell(1,n);
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.histogram_options,'Line Width'), ...
		'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.histogram_linewidth = tmp;
	
	ix = find(data.hist_matrix_menu.hist.linewidth == [1,2,3,4]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Histogram Patch
	%--
	
	L = { ...
		'No Patch', ...
		'1/4 Alpha', ...
		'1/2 Alpha', ...
		'3/4 Alpha', ...
		'Solid Patch' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.histogram_options,'Patch'), ...
		'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.histogram_patch = tmp;
	
	ix = find(data.hist_matrix_menu.hist.patch == [-1, 0.25, 0.5, 0.75, 1]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Kernel Options
	%--
	
	L = { ...
		'Kernel', ...	
		'Length', ...
		'Color', ...
		'Line Style', ...
		'Line Width', ...
		'Patch', ...
		'Edit All ...' ...
	};
	
	n = length(L);
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	data.hist_matrix_menu.kernel_options = ...
		menu_group(get_menu(h,'Kernel Options'),'hist_matrix_menu',L,S,A);
	
	%--
	% Kernel X and Y
	%--
	
	L = {'X','Y'};
	n = length(L);
	S = bin2str(zeros(1,n));
	
	data.hist_matrix_menu.xy_kernel = ...
		menu_group(get_menu(h,'Kernel'),'hist_matrix_menu',L,S);	
	
	%--
	% Kernel Length X and Y
	%--
	
	L = {'X','Y'};
	n = length(L);
	S = bin2str(zeros(1,n));
	
	data.hist_matrix_menu.xy_length = ...
		menu_group(get_menu(h,'Length'),'hist_matrix_menu',L,S);	
	
	%--
	% Kernel Length 
	%--
	
	L = { ...
		'1/2 Bins', ...
		'1/4 Bins', ...
		'1/8 Bins', ...
		'1/16 Bins', ...
		'Other Kernel Length ...' ...
	};

	n = length(L);
	S = bin2str(zeros(1,n));
	S{end} = 'on';
	
	A = cell(1,n);
	
	tmp = menu_group(get_menu(data.hist_matrix_menu.xy_length,'X'),'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.x_kernel_length = tmp;
	
	ix = find(data.hist_matrix_menu.kernel.x.length == [1/2,1/4,1/8,1/16,1/32]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	else
		set(tmp(end),'check','on');
	end
	
	tmp = menu_group(get_menu(data.hist_matrix_menu.xy_length,'Y'),'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.y_kernel_length = tmp;
	
	ix = find(data.hist_matrix_menu.kernel.y.length == [1/2,1/4,1/8,1/16,1/32]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	else
		set(tmp(end),'check','on');
	end
	
	%--
	% Kernel Type 
	%--
	
	L = { ...
		'Binomial', ...
		'Gauss', ...
		'Epanechnikov', ...
		'Tukey', ...
		'Uniform' ...
	};

	n = length(L);
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{5} = 'on';
	
	A = cell(1,n);
	
	tmp = menu_group(get_menu(data.hist_matrix_menu.xy_kernel,'X'),'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.x_kernel_type = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.kernel.x.type,L));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	tmp = menu_group(get_menu(data.hist_matrix_menu.xy_kernel,'Y'),'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.y_kernel_type = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.kernel.y.type,L));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Kernel Color
	%--
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.kernel_options,'Color'), ...
		'hist_matrix_menu',COLOR,SEP_COLOR);
	data.hist_matrix_menu.kernel_color = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.kernel.color,COLOR));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Kernel Line Style
	%--
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.kernel_options,'Line Style'), ...
		'hist_matrix_menu',LINESTYLE,SEP_LINESTYLE);
	data.hist_matrix_menu.kernel_linestyle = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.kernel.linestyle,LINESTYLE));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Kernel Line Width
	%--
	
	L = {'1','2','3','4'};
	
	n = length(L);
	S = bin2str(zeros(1,n));
	A = cell(1,n);
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.kernel_options,'Line Width'), ...
		'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.kernel_linewidth = tmp;
	
	ix = find(data.hist_matrix_menu.kernel.linewidth == [1,2,3,4]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Kernel Patch
	%--
	
	L = { ...
		'No Patch', ...
		'1/4 Alpha', ...
		'1/2 Alpha', ...
		'3/4 Alpha', ...
		'Solid Patch' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.kernel_options,'Patch'), ...
		'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.kernel_patch = tmp;
	
	ix = find(data.hist_matrix_menu.kernel.patch == [-1, 0.25, 0.5, 0.75, 1]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Fit Options
	%--
	
	L = { ...
		'Model', ...
		'Color', ...
		'Line Style', ...
		'Line Width', ...
		'Patch', ...
		'Edit All ...' ...
	};

	n = length(L);
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	data.hist_matrix_menu.fit_options = ...
		menu_group(get_menu(h,'Fit Options'),'hist_matrix_menu',L,S,A);

	%--
	% Fit Model Length X and Y
	%--
	
	L = {'X','Y'};
	n = length(L);
	S = bin2str(zeros(1,n));
	
	data.hist_matrix_menu.xy_model = ...
		menu_group(get_menu(h,'Model'),'hist_matrix_menu',L,S);	
	
	%--
	% Fit Model
	%--
		
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.xy_model,'X'), ...
		'hist_matrix_menu',PDF,SEP_PDF);
	data.hist_matrix_menu.x_model = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.fit.x.model,PDF));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.xy_model,'Y'), ...
		'hist_matrix_menu',PDF,SEP_PDF);
	data.hist_matrix_menu.y_model = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.fit.y.model,PDF));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
			
	%--
	% Fit Color
	%--
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.fit_options,'Color'), ...
		'hist_matrix_menu',COLOR,SEP_COLOR);
	data.hist_matrix_menu.fit_color = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.fit.color,COLOR));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Fit Line Style
	%--
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.fit_options,'Line Style'), ...
		'hist_matrix_menu',LINESTYLE,SEP_LINESTYLE);
	data.hist_matrix_menu.fit_linestyle = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.fit.linestyle,LINESTYLE));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Fit Line Width
	%--
	
	L = {'1','2','3','4'};
	
	n = length(L);
	S = bin2str(zeros(1,n));
	A = cell(1,n);
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.fit_options,'Line Width'), ...
		'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.fit_linewidth = tmp;
	
	ix = find(data.hist_matrix_menu.fit.linewidth == [1,2,3,4]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Fit Patch
	%--
	
	L = { ...
		'No Patch', ...
		'1/4 Alpha', ...
		'1/2 Alpha', ...
		'3/4 Alpha', ...
		'Solid Patch' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.fit_options,'Patch'), ...
		'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.fit_patch = tmp;
	
	ix = find(data.hist_matrix_menu.fit.patch == [-1, 0.25, 0.5, 0.75, 1]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end

	%--
	% Colormap
	%--
	
	tmp = ...
		menu_group(get_menu(h,'Colormap'),'hist_matrix_menu',CMAP,SEP_CMAP);
	data.hist_matrix_menu.colormap_menu = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.colormap,CMAP));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end	
	
	%--
	% Colormap Options
	%--
	
	L = { ...
		'Colorbar', ...
		'Brighten', ...
		'Darken', ...
		'Invert' ...
	};

	n = length(L);
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	
	A = cell(1,n);
	
	tmp = ...
		menu_group(get_menu(h,'Colormap Options'),'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.colormap_options = tmp;
	
	%--
	% Grid Options
	%--
	
	L = { ...
		'Color', ...
		'X Grid', ...
		'Y Grid' ...
	};

	n = length(L);
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	
	A = cell(1,n);
	
	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.histogram,'Grid Options'), ...
		'hist_matrix_menu',L,S,A);
	data.hist_matrix_menu.grid_options = tmp;
	
	if (data.hist_matrix_menu.grid.x)
		set(tmp(2),'check','on');
	end
	if (data.hist_matrix_menu.grid.y)
		set(tmp(3),'check','on');
	end
	
	%--
	% Grid Color
	%--

	tmp = ...
		menu_group(get_menu(data.hist_matrix_menu.grid_options,'Color'), ...
		'hist_matrix_menu',COLOR,SEP_COLOR);
	data.hist_matrix_menu.grid_color = tmp;
	
	ix = find(strcmp(data.hist_matrix_menu.grid.color,COLOR));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
		
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update menu and display state
	%--
	
	if (data.hist_matrix_menu.kernel.view)
% 		hist_matrix_menu(h,'Kernel Display');
% 		set(get_menu(data.hist_matrix_menu.histogram,'Kernel Estimate'),'check','on');
	end
	
%--
% Histogram
%--

case ('Histogram')
		
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	hist = data.hist_matrix_menu.hist;
	
	%--
	% toggle variable
	%--
	
	data.hist_matrix_menu.hist.view = ~hist.view;
	
	%--
	% update userdata and menu
	%--
	
	if (~hist.view)
		set(get_menu(data.hist_matrix_menu.histogram,'Histogram'),'check','on');
	else
		set(get_menu(data.hist_matrix_menu.histogram,'Histogram'),'check','off');
	end
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Histogram Display');
	
%--
% Number of Bins
%--

case ({'10','100','32','64','128','256'})
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% determine whether we are changing X or Y bins
	%--
	
	switch (get(get(gcbo,'parent'),'label'))
		
	case ('X')
		
		%--
		% udpate userdata and menu
		%--
		
		data.hist_matrix_menu.hist.bins(1) = eval(str);
		set(h,'userdata',data);
		
		set(data.hist_matrix_menu.x_bins,'check','off');
		set(get_menu(data.hist_matrix_menu.x_bins,str),'check','on');
		
	case ('Y')
		
		%--
		% udpate userdata and menu
		%--
		
		data.hist_matrix_menu.hist.bins(2) = eval(str);
		set(h,'userdata',data);
		
		set(data.hist_matrix_menu.y_bins,'check','off');
		set(get_menu(data.hist_matrix_menu.y_bins,str),'check','on');
		
	end
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Histogram Display');
	hist_matrix_menu(h,'Kernel Display');

%--
% Other Number of Bins ...
%--

case ('Other Number of Bins ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% determine whether we are changing X or Y bins
	%--
	
	switch (get(get(gcbo,'parent'),'label'))
		
	case ('X')
		
		%--
		% update number of bins
		%--
		
		% setup input dialog
		
		ans = input_dialog( ...
			{'Number of X Bins'}, ...
			'Other Number of Bins ...', ...
			[1,32], ...
			{num2str(data.hist_matrix_menu.hist.bins(1))}, ...
			{'Number of equal sized bins in X for histogram'} ...
		);
	
		if (~isempty(ans))
			data.hist_matrix_menu.hist.bins(1) = eval(ans{1});
		else
			return;	
		end
		
		%--
		% update userdata and menu
		%--
		
		set(h,'userdata',data);	
		
		set(data.hist_matrix_menu.x_bins,'check','off');
		set(data.hist_matrix_menu.x_bins(end),'check','on');
		
	case ('Y')
		
		%--
		% update number of bins
		%--
		
		% setup input dialog
		
		ans = input_dialog( ...
			{'Number of Y Bins'}, ...
			'Other Number of Bins ...', ...
			[1,32], ...
			{num2str(data.hist_matrix_menu.hist.bins(2))}, ...
			{'Number of equal sized bins in Y for histogram'} ...
		);
	
		if (~isempty(ans))
			data.hist_matrix_menu.hist.bins(2) = eval(ans{1});
		else
			return;	
		end
		
		%--
		% update userdata and menu
		%--
		
		set(h,'userdata',data);	
		
		set(data.hist_matrix_menu.y_bins,'check','off');
		set(data.hist_matrix_menu.y_bins(end),'check','on');
		
	end
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Histogram Display');
	hist_matrix_menu(h,'Kernel Display');
	
%--
% Histogram Display
%--

case ('Histogram Display')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(gcf,'userdata');
	
	X = data.hist_matrix_menu.data.X;
	Y = data.hist_matrix_menu.data.Y;

	b = data.hist_matrix_menu.bounds;
	Z = data.hist_matrix_menu.mask;
	
	hist = data.hist_matrix_menu.hist;
	
	ax = data.hist_matrix_menu.axes;
	
	%--
	% compute and display histogram
	%--
	
	if (hist.view)
		
		%--
		% compute histogram and marginals
		%--
		
		[H,hist.centers,hist.breaks] = ...
			hist_2d(X,Y,hist.bins,b,Z);
		
		hist.counts.xy = H;
		hist.counts.x = sum(H,1);
		hist.counts.y = sum(H,2)';
			
		%--
		% delete previously displayed histograms
		%--
				
		tmp = findobj(h,'tag','histogram');
		if (~isempty(tmp))
			delete(tmp);
		end
		
		%--
		% X marginal histogram
		%--
		
		%--
		% compute normalized histogram
		%--
		
		nh = hist.counts.x / ((hist.centers.x(2) - hist.centers.x(1)) * sum(hist.counts.x));
		
		%--
		% display histogram
		%--
		
		axes(ax.x);
		hold on;
		
		tmp = plot(hist.centers.x,nh, ...
			'linestyle',linestyle_to_str(hist.linestyle), ...
			'linewidth',hist.linewidth, ...
			'color',color_to_rgb(hist.color) ...
		);
				
		set(tmp,'tag','histogram');
		
		%--
		% display patch histogram
		%--
		
		if (hist.patch > 0)
			
			hold on;
			
			px = [hist.centers.x(1), hist.centers.x, hist.centers.x(end), hist.centers.x(1)];
			py = [0, nh, 0, 0];
			
			tmp = patch(px,py,color_to_rgb(hist.color));
			
			set(tmp,'tag','histogram');
			set(tmp,'facealpha',hist.patch);
			set(tmp,'linestyle','none');
			
		end
		
		%--
		% Y marginal histogram
		%--
		
		%--
		% compute normalized histogram
		%--
		
		nh = hist.counts.y / ((hist.centers.y(2) - hist.centers.y(1)) * sum(hist.counts.y));
		
		%--
		% display histogram
		%--
		
		axes(ax.y);
		hold on;
		
		tmp = plot(nh,hist.centers.y, ...
			'linestyle',linestyle_to_str(hist.linestyle), ...
			'linewidth',hist.linewidth, ...
			'color',color_to_rgb(hist.color) ...
		);
				
		set(tmp,'tag','histogram');
		
		%--
		% display patch histogram
		%--
		
		if (hist.patch > 0)
			
			hold on;
			
			px = [hist.centers.y(1), hist.centers.y, hist.centers.y(end), hist.centers.y(1)];
			py = [0, nh, 0, 0];
			
			tmp = patch(py,px,color_to_rgb(hist.color));
			
			set(tmp,'tag','histogram');
			set(tmp,'facealpha',hist.patch);
			set(tmp,'linestyle','none');
			
		end
		
		%--
		% XY joint histogram
		%--
		
		N = sum(H(:));
		w = (hist.centers.x(2) - hist.centers.x(1))*(hist.centers.y(2) - hist.centers.y(1));
		G = H / (w * N);
								
		% logarithmic scaling
		
		G = log10(G);			
		Z = isfinite(G);
		m = double(fast_min_max(G,Z));
		
		%--
		% update histogram image
		%--
			
		axes(ax.xy);
		
		axis([hist.breaks.x(1) hist.breaks.x(end) hist.breaks.y(1) hist.breaks.y(end)]);
		
		tmp = get(ax.x,'xtick');
		set(ax.xy,'xtick',tmp);
		
		tmp = get(ax.y,'ytick');
		set(ax.xy,'ytick',tmp);
		
		axes(ax.xy);
		
		tmp = get_image_handles(h);
		
		if (~isempty(tmp))
			set(tmp,'cdata',G);
			set(tmp,'xdata',hist.centers.x);
			set(tmp,'ydata',hist.centers.y);
			set(ax.xy,'clim',m);
		end
					
	%--
	% delete displayed histogram
	%--
	
	else
					
		tmp = findobj(h,'tag','histogram');
		if (~isempty(tmp))
			delete(tmp);
		end
	
	end
	
	%--
	% update userdata
	%--
	
	data.hist_matrix_menu.hist = hist;
	set(h,'userdata',data);

%--
% Kernel Estimate
%--

case ('Kernel Estimate')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	hist = data.hist_matrix_menu.hist;
	kernel = data.hist_matrix_menu.kernel;
	
	%--
	% toggle variable
	%--
	
	data.hist_matrix_menu.kernel.view = ~kernel.view;
	
	%--
	% update userdata and menu
	%--
	
	if (~kernel.view)
		set(get_menu(data.hist_matrix_menu.histogram,'Kernel Estimate'),'check','on');
	else
		set(get_menu(data.hist_matrix_menu.histogram,'Kernel Estimate'),'check','off');
	end
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Kernel Display');

%--
% Kernel Display
%--

case ('Kernel Display')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(gcf,'userdata');
	
	hist = data.hist_matrix_menu.hist;
	kernel = data.hist_matrix_menu.kernel;
	
	ax = data.hist_matrix_menu.axes;
	
	%--
	% compute and display kernel smoothed histogram
	%--
	
	if (kernel.view)
		
		%--
		% remove previously displayed kernel estimates
		%--
		
		tmp = findobj(h,'tag','kernel');
		if (~isempty(tmp))
			delete(tmp);
		end
		
		%--
		% X kernel estimate
		%--
		
		%--
		% compute kernel
		%--
		
		n = round(kernel.x.length * hist.bins(1));
		if (~mod(n,2))
			n = n - 1;
		end
		
		switch (kernel.x.type)
			
		case ('Binomial')
			ker = filt_binomial(n)';
			
		case ('Gauss')
			ker = linspace(-3,3,n);
			ker = exp(-ker.^2);
			ker = ker / sum(ker);
			
		case ('Epanechnikov')
			ker = linspace(-1,1,n);
			ker = (1 - ker.^2);
			ker = ker / sum(ker);
			
		case ('Tukey')
			ker = linspace(-1,1,n);
			ker = (1 - ker.^2).^2;
			ker = ker / sum(ker);
			
		case ('Uniform')
			ker = ones(1,n) / n;
			
		end
			
		%--
		% compute normalized and kernel smoothed histogram
		%--
		
		hx = hist.counts.x;
		
		nh = hx / ((hist.centers.x(2) - hist.centers.x(1)) * sum(hx));
		kh = conv2(nh,ker,'same');
		
		%--
		% display kernel smoothed histogram
		%--
		
		axes(ax.x);
		hold on;
		
		tmp = plot(hist.centers.x,kh, ...
			'linestyle',linestyle_to_str(kernel.linestyle), ...
			'linewidth',kernel.linewidth, ...
			'color',color_to_rgb(kernel.color) ...
		);
				
		set(tmp,'tag','kernel');
		
		%--
		% display patch kernel estimate
		%--
		
		if (kernel.patch > 0)
			
			hold on;
			
			px = [hist.centers.x(1), hist.centers.x, hist.centers.x(end), hist.centers.x(1)];
			py = [0, kh, 0, 0];
			
			tmp = patch(px,py,color_to_rgb(kernel.color));
			
			set(tmp,'tag','kernel');
			set(tmp,'facealpha',kernel.patch);
			set(tmp,'linestyle','none');
			
		end
		
		%--
		% Y kernel estimate
		%--
		
		%--
		% compute kernel
		%--
		
		n = round(kernel.y.length * hist.bins(2));
		if (~mod(n,2))
			n = n - 1;
		end
		
		switch (kernel.y.type)
			
		case ('Binomial')
			ker = filt_binomial(n)';
			
		case ('Gauss')
			ker = linspace(-3,3,n);
			ker = exp(-ker.^2);
			ker = ker / sum(ker);
			
		case ('Epanechnikov')
			ker = linspace(-1,1,n);
			ker = (1 - ker.^2);
			ker = ker / sum(ker);
			
		case ('Tukey')
			ker = linspace(-1,1,n);
			ker = (1 - ker.^2).^2;
			ker = ker / sum(ker);
			
		case ('Uniform')
			ker = ones(1,n) / n;
			
		end
			
		%--
		% compute normalized and kernel smoothed histogram
		%--
		
		hy = hist.counts.y;
		
		nh = hy / ((hist.centers.y(2) - hist.centers.y(1)) * sum(hy));
		kh = conv2(nh,ker,'same');
		
		%--
		% display kernel smoothed histogram
		%--
		
		axes(ax.y);
		hold on;
		
		tmp = plot(kh,hist.centers.y, ...
			'linestyle',linestyle_to_str(kernel.linestyle), ...
			'linewidth',kernel.linewidth, ...
			'color',color_to_rgb(kernel.color) ...
		);
				
		set(tmp,'tag','kernel');
		
		%--
		% display patch kernel estimate
		%--
		
		if (kernel.patch > 0)
			
			hold on;
			
			px = [hist.centers.y(1), hist.centers.y, hist.centers.y(end), hist.centers.y(1)];
			py = [0, kh, 0, 0];
			
			tmp = patch(py,px,color_to_rgb(kernel.color));
			
			set(tmp,'tag','kernel');
			set(tmp,'facealpha',kernel.patch);
			set(tmp,'linestyle','none');
			
		end
					
	%--
	% delete displayed kernel estimate
	%--
	
	else
					
		tmp = findobj(h,'tag','kernel');
		if (~isempty(tmp))
			delete(tmp);
		end
	
	end
	
%--
% Kernel Length
%--

case ({'1/2 Bins','1/4 Bins','1/8 Bins','1/16 Bins','1/32 Bins'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% determine whether we are modifying X or Y kernel length
	%--
	
	switch (get(get(gcbo,'parent'),'label'))
		
	case ('X')
		
		%--
		% update kernel length
		%--
		
		data.hist_matrix_menu.kernel.x.length = eval(strtok(str,' '));
		
		%--
		% update menu
		%--
		
		set(data.hist_matrix_menu.x_kernel_length,'check','off');
		set(get_menu(data.hist_matrix_menu.x_kernel_length,str),'check','on');
		
	case ('Y')
		
		%--
		% update kernel length
		%--
		
		data.hist_matrix_menu.kernel.y.length = eval(strtok(str,' '));
		
		%--
		% update menu
		%--
		
		set(data.hist_matrix_menu.y_kernel_length,'check','off');
		set(get_menu(data.hist_matrix_menu.y_kernel_length,str),'check','on');
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Kernel Display');

%--
% Other Kernel Length ...	
%--

case ('Other Kernel Length ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update kernel length
	%--
	
	% setup input dialog
	
	ans = input_dialog( ...
		{'Kernel Length'}, ...
		'Other Kernel Length ...', ...
		[1,32], ...
		{[data.hist_matrix_menu.kernel.length, 0, 1]}, ...
		{'Length of kernel as fraction number of bins'} ...
	);

	if (~isempty(ans))
		data.hist_matrix_menu.kernel.length = ans{1};
	else
		return;	
	end
	
	%--
	% update userdata and menu
	%--
	
	set(h,'userdata',data);	
	
	set(data.hist_matrix_menu.kernel_length,'check','off');
	set(data.hist_matrix_menu.kernel_length(end),'check','on');
	
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Kernel Display');

%--
% Kernel Type
%--

case ({'Binomial','Epanechnikov','Gauss','Tukey','Uniform'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% determine whether we are modifying X or Y kernel type
	%--
	
	switch (get(get(gcbo,'parent'),'label'))
		
	case ('X')
		
		%--
		% update kernel length
		%--
		
		data.hist_matrix_menu.kernel.x.type = str;
		
		%--
		% update menu 
		%--
		
		set(data.hist_matrix_menu.x_kernel_type,'check','off');
		set(get_menu(data.hist_matrix_menu.x_kernel_type,str),'check','on');
		
	case ('Y')
		
		%--
		% update kernel length
		%--
		
		data.hist_matrix_menu.kernel.y.type = str;
		
		%--
		% update menu
		%--
		
		set(data.hist_matrix_menu.y_kernel_type,'check','off');
		set(get_menu(data.hist_matrix_menu.y_kernel_type,str),'check','on');
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Kernel Display');
	
%--
% Fit Model
%--

case ('Fit Model')
		
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	fit = data.hist_matrix_menu.fit;
	
	%--
	% toggle variable
	%--
	
	data.hist_matrix_menu.fit.view = ~fit.view;
	
	%--
	% update userdata and menu
	%--
	
	if (~fit.view)
		set(get_menu(data.hist_matrix_menu.histogram,'Fit Model'),'check','on');
	else
		set(get_menu(data.hist_matrix_menu.histogram,'Fit Model'),'check','off');
	end
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Fit Display');
	
%--
% Fit Options
%--

%--
% Model
%--

case (PDF)
		
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	fit = data.hist_matrix_menu.fit;
	
	%--
	% determine whether we are modifying X or Y kernel type
	%--
	
	switch (get(get(gcbo,'parent'),'label'))
		
	case ('X')
		
		%--
		% set model and update userdata and menu
		%--
		
		data.hist_matrix_menu.fit.x.model = str;
		set(h,'userdata',data);
		
		set(data.hist_matrix_menu.x_model,'check','off');
		set(get_menu(data.hist_matrix_menu.x_model,str),'check','on');
		
	case ('Y')
		
		%--
		% set model and update userdata and menu
		%--
		
		data.hist_matrix_menu.fit.y.model = str;
		set(h,'userdata',data);
		
		set(data.hist_matrix_menu.y_model,'check','off');
		set(get_menu(data.hist_matrix_menu.y_model,str),'check','on');
		
	end
	
	%--
	% update display
	%--
	
	hist_matrix_menu(h,'Fit Display');
	
%--
% Fit Display
%--

case ('Fit Display')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(gcf,'userdata');
	
	X = data.hist_matrix_menu.data.X;
	Y = data.hist_matrix_menu.data.Y;
	
	hist = data.hist_matrix_menu.hist;
	fit = data.hist_matrix_menu.fit;
	
	ax = data.hist_matrix_menu.axes;
	
	%--
	% compute and display fit smoothed histogram
	%--
	
	if (fit.view)
		
		%--
		% remove previously displayed fit estimates
		%--
		
		tmp = findobj(h,'tag','fit');
		if (~isempty(tmp))
			delete(tmp);
		end
		
		%--
		% X fit estimate
		%--
		
		%--
		% compute fit
		%--
		
		[p,fh] = hist_1d_fit(X,fit.x.model,hist.centers.x);
				
		%--
		% display fit smoothed histogram
		%--
		
		axes(ax.x);
		hold on;
		
		tmp = plot(hist.centers.x,fh, ...
			'linestyle',linestyle_to_str(fit.linestyle), ...
			'linewidth',fit.linewidth, ...
			'color',color_to_rgb(fit.color) ...
		);
				
		set(tmp,'tag','fit');
		
		%--
		% display parameter values in contextmenu
		%--
		
		% remove previous model information menus
		
		tmp = findobj(h,'type','uicontextmenu','tag','context');
		tmp = get_menu(tmp,'X Model');
				
		delete(get(tmp,'children'));
		
		% get parameter names and types
		
		par = prob_to_par(fit.x.model);
		
		% create menu
		
		L{1} = [data.hist_matrix_menu.fit.x.model];
		
		for k = 1:length(p)
			L{k + 1} = [par{k} ': ' num2str(p(k))];
		end
		
		n = length(L);
		S = bin2str(zeros(1,n));
		S{2} = 'on';
							
		menu_group(tmp,'',L,S);
		
		%--
		% display patch fit estimate
		%--
		
		if (fit.patch > 0)
			
			hold on;
			
			px = [hist.centers.x(1), hist.centers.x, hist.centers.x(end), hist.centers.x(1)];
			py = [0, fh, 0, 0];
			
			tmp = patch(px,py,color_to_rgb(fit.color));
			
			set(tmp,'tag','fit');
			set(tmp,'facealpha',fit.patch);
			set(tmp,'linestyle','none');
			
		end
		
		%--
		% Y fit estimate
		%--
		
		%--
		% compute fit
		%--
			
		[p,fh] = hist_1d_fit(Y,fit.y.model,hist.centers.y);
			
		%--
		% display fit smoothed histogram
		%--

		axes(ax.y);
		hold on;
		
		tmp = plot(fh,hist.centers.y, ...
			'linestyle',linestyle_to_str(fit.linestyle), ...
			'linewidth',fit.linewidth, ...
			'color',color_to_rgb(fit.color) ...
		);
					
		set(tmp,'tag','fit');
			
		%--
		% display parameter values in contextmenu
		%--
		
		% remove previous model information menus
		
		tmp = findobj(h,'type','uicontextmenu','tag','context');
		tmp = get_menu(tmp,'Y Model');
		
		delete(get(tmp,'children'));
		
		% get parameter names and types
		
		par = prob_to_par(fit.y.model);
		
		% create menu
		
		L{1} = [data.hist_matrix_menu.fit.y.model];
		
		for k = 1:length(p)
			L{k + 1} = [par{k} ': ' num2str(p(k))];
		end
		
		n = length(L);
		S = bin2str(zeros(1,n));
		S{2} = 'on';
							
		menu_group(tmp,'',L,S);
		
		%--
		% display patch fit estimate
		%--
		
		if (fit.patch > 0)
			
			hold on;
			
			px = [hist.centers.y(1), hist.centers.y, hist.centers.y(end), hist.centers.y(1)];
			py = [0, fh, 0, 0];
			
			tmp = patch(py,px,color_to_rgb(fit.color));
			
			set(tmp,'tag','fit');
			set(tmp,'facealpha',fit.patch);
			set(tmp,'linestyle','none');
			
		end
					
	%--
	% delete displayed fit estimate and contextual menus
	%--
	
	else
					
		tmp = findobj(h,'tag','fit');
		if (~isempty(tmp))
			delete(tmp);
		end
		
		tmp = get_menu(h,'X Model')
		delete(get(tmp,'children'));
		
		tmp = get_menu(h,'Y Model')
		delete(get(tmp,'children'));
	
	end
	
%--
% Color
%--

case (COLOR)
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update color option for kernel or model and menu
	%--
	
	tmp = get(get(get(gcbo,'parent'),'parent'),'label');
	
	switch (tmp)
		
	case ('Histogram Options')
		
		% update variable
		
		data.hist_matrix_menu.hist.color = str;
		
		% update display
		
		if (data.hist_matrix_menu.hist.view)
			
			tmp = findobj(h,'type','line','tag','histogram');
			if (~isempty(tmp))
				set(tmp,'color',color_to_rgb(str));
			end
			tmp = findobj(h,'type','patch','tag','histogram');
			if (~isempty(tmp))
				set(tmp,'facecolor',color_to_rgb(str));
			end
			tmp = findobj(h,'type','line','tag','mean');
			if (~isempty(tmp))
				set(tmp,'color',color_to_rgb(str));
			end
			tmp = findobj(h,'type','line','tag','median');
			if (~isempty(tmp))
				set(tmp,'color',color_to_rgb(str));
			end
			
		end
		
		% update menu
		
		set(data.hist_matrix_menu.histogram_color,'check','off');
		set(gcbo,'check','on');
		
	case ('Kernel Options')
		
		% update variable
		
		data.hist_matrix_menu.kernel.color = str;
		
		% update display
		
		if (data.hist_matrix_menu.kernel.view)
			tmp = findobj(h,'type','line','tag','kernel');
			if (~isempty(tmp))
				set(tmp,'color',color_to_rgb(str));
			end
			tmp = findobj(h,'type','patch','tag','kernel');
			if (~isempty(tmp))
				set(tmp,'facecolor',color_to_rgb(str));
			end
		end
		
		% update menu
		
		set(data.hist_matrix_menu.kernel_color,'check','off');
		set(gcbo,'check','on');
		
	case ('Fit Options')
		
		% update variable
		
		data.hist_matrix_menu.fit.color = str;
		
		% update display
		
		if (data.hist_matrix_menu.fit.view)
			tmp = findobj(h,'type','line','tag','fit');
			if (~isempty(tmp))
				set(tmp,'color',color_to_rgb(str));
			end
			tmp = findobj(h,'type','patch','tag','fit');
			if (~isempty(tmp))
				set(tmp,'facecolor',color_to_rgb(str));
			end
		end
		
		% update menu
		
		set(data.hist_matrix_menu.fit_color,'check','off');
		set(gcbo,'check','on');
		
	case ('Grid Options')
		
		% update variable
		
		data.hist_matrix_menu.grid.color = str;

		% update display
		
		ax = data.hist_matrix_menu.axes;
		set(ax.x,'xcolor',color_to_rgb(str));
		set(ax.x,'ycolor',color_to_rgb(str));
		set(ax.xy,'xcolor',color_to_rgb(str));
		set(ax.xy,'ycolor',color_to_rgb(str));
		set(ax.y,'xcolor',color_to_rgb(str));
		set(ax.y,'ycolor',color_to_rgb(str));
		
		% update menu
		
		set(data.hist_matrix_menu.grid_color,'check','off');
		set(gcbo,'check','on');
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Linestyle
%--

case (LINESTYLE)
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update linestyle option for kernel or model and menu
	%--
	
	tmp = get(get(get(gcbo,'parent'),'parent'),'label');
	
	switch (tmp)
		
	case ('Histogram Options')
		
		data.hist_matrix_menu.hist.linestyle = str;
		
		if (data.hist_matrix_menu.hist.view)
			tmp = findobj(h,'type','line','tag','histogram');
			if (~isempty(tmp))
				set(tmp,'marker','none');
				set(tmp,'linestyle',linestyle_to_str(str));
			end
		end
		
		set(data.hist_matrix_menu.histogram_linestyle,'check','off');
		set(gcbo,'check','on');
		
	case ('Kernel Options')
		
		data.hist_matrix_menu.kernel.linestyle = str;
		
		if (data.hist_matrix_menu.kernel.view)
			tmp = findobj(h,'type','line','tag','kernel');
			if (~isempty(tmp))
				set(tmp,'marker','none');
				set(tmp,'linestyle',linestyle_to_str(str));
			end
		end
		
		set(data.hist_matrix_menu.kernel_linestyle,'check','off');
		set(gcbo,'check','on');
		
	case ('Fit Options')
		
		data.hist_matrix_menu.fit.linestyle = str;
		
		if (data.hist_matrix_menu.fit.view)
			tmp = findobj(h,'type','line','tag','fit');
			if (~isempty(tmp))
				set(tmp,'marker','none');
				set(tmp,'linestyle',linestyle_to_str(str));
			end
		end
		
		set(data.hist_matrix_menu.fit_linestyle,'check','off');
		set(gcbo,'check','on');
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Line Width
%--

case ({'1','2','3','4'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update linewidth option for kernel or model and menu
	%--
	
	tmp = get(get(get(gcbo,'parent'),'parent'),'label');
	
	switch (tmp)
		
	case ('Histogram Options')
		
		data.hist_matrix_menu.hist.linewidth = eval(str);
		
		if (data.hist_matrix_menu.hist.view)
			tmp = findobj(h,'type','line','tag','histogram');
			if (~isempty(tmp))
				set(tmp,'linewidth',eval(str));
			end
			tmp = findobj(h,'type','line','tag','mean');
			if (~isempty(tmp))
				set(tmp,'linewidth',eval(str));
			end
			tmp = findobj(h,'type','line','tag','median');
			if (~isempty(tmp))
				set(tmp,'linewidth',eval(str));
			end
		end
		
		set(data.hist_matrix_menu.histogram_linewidth,'check','off');
		set(gcbo,'check','on');
		
	case ('Kernel Options')
		
		data.hist_matrix_menu.kernel.linewidth = eval(str);
		
		if (data.hist_matrix_menu.kernel.view)
			tmp = findobj(h,'type','line','tag','kernel');
			if (~isempty(tmp))
				set(tmp,'linewidth',eval(str));
			end
		end
		
		set(data.hist_matrix_menu.kernel_linewidth,'check','off');
		set(gcbo,'check','on');
		
	case ('Fit Options')
		
		data.hist_matrix_menu.fit.linewidth = eval(str);
		
		if (data.hist_matrix_menu.fit.view)
			tmp = findobj(h,'type','line','tag','fit');
			if (~isempty(tmp))
				set(tmp,'linewidth',eval(str));
			end
		end
		
		set(data.hist_matrix_menu.fit_linewidth,'check','off');
		set(gcbo,'check','on');
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Patch (Alpha)
%--

case ({'No Patch','1/4 Alpha','1/2 Alpha','3/4 Alpha','Solid Patch'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% parse string to get alpha
	%--
	
	switch (str)
		
	case ('No Patch')
		alpha = -1;
		
	case ('Solid Patch')
		alpha = 1;
		
	otherwise
		alpha = eval(strtok(str,' '));
		
	end
	
	%--
	% update patch option for kernel or model and menu
	%--
	
	tmp = get(get(get(gcbo,'parent'),'parent'),'label');
	
	switch (tmp)
		
	case ('Histogram Options')
		
		data.hist_matrix_menu.hist.patch = alpha;
		
		if (data.hist_matrix_menu.hist.view)
			tmp = findobj(h,'type','patch','tag','histogram');
			if (~isempty(tmp))
				if (alpha > 0)
					set(tmp,'facealpha',alpha);
				else
					delete(tmp);
				end
			else
				set(h,'userdata',data);
				hist_matrix_menu(h,'Histogram Display');
			end
		end
		
		set(data.hist_matrix_menu.histogram_patch,'check','off');
		set(gcbo,'check','on');
		
	case ('Kernel Options')
		
		data.hist_matrix_menu.kernel.patch = alpha;
		
		if (data.hist_matrix_menu.kernel.view)
			tmp = findobj(h,'type','patch','tag','kernel');
			if (~isempty(tmp))
				if (alpha > 0)
					set(tmp,'facealpha',alpha);
				else
					delete(tmp);
				end
			else
				set(h,'userdata',data);
				hist_matrix_menu(h,'Kernel Display');
			end
		end
		
		set(data.hist_matrix_menu.kernel_patch,'check','off');
		set(gcbo,'check','on');
		
	case ('Fit Options')
		
		data.hist_matrix_menu.fit.patch = alpha;
		
		if (data.hist_matrix_menu.fit.view)
			tmp = findobj(h,'type','patch','tag','fit');
			if (~isempty(tmp))
				if (alpha > 0)
					set(tmp,'facealpha',alpha);
				else
					delete(tmp);
				end
			else
				set(h,'userdata',data);
				hist_matrix_menu(h,'Fit Display');
			end
		end
		
		set(data.hist_matrix_menu.fit_patch,'check','off');
		set(gcbo,'check','on');
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Colormap
%--

case (CMAP)
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update variable
	%--
	
	data.hist_matrix_menu.colormap = str;
	
	%--
	% update menu and userdata
	%--
	
	set(data.hist_matrix_menu.colormap_menu,'check','off');
	set(get_menu(data.hist_matrix_menu.colormap_menu,str),'check','on');
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--

	colormap(colormap_to_fun(str));
	
%--
% Colormap Options
%--

%--
% Colorbar
%--

case ('Colorbar')
	
	%--
	% get userdata
	%-- 
	
	data = get(h,'userdata');
	
	ax = data.hist_matrix_menu.axes;
	
	%--
	% toggle colorbar
	%--
	
	tmp = findobj(h,'type','axes','tag','Colorbar');
		
	if (~isempty(tmp))		
		delete(tmp);		
	else		
		axes(ax.xy);
		colorbar
	end
	
	%--
	% update axes positions
	%--
	
	p = get(ax.xy,'position');
	q = get(ax.x,'position');
	q(3) = p(3);
	set(ax.x,'position',q);
	
%--
% Brighten
%--

case ('Brighten')

	brighten(0.1);

%--
% Darken
%--

case ('Darken')

	brighten(-0.1);

%--
% Invert
%--

case ('Invert')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	colormap(flipud(get(h,'colormap')));
	
%--
% Axes Scaling
%--

case ({'Linear','Semi-Log Y','Semi-Log X','Log-Log'})
	
	%--
	% get axes handles from userdata
	%--
	
	data = get(h,'userdata');
	ax = data.hist_matrix_menu.axes;
	
	%--
	% set axes scale
	%--
	
	switch (str)

	case ('Linear')
		set(ax.x,'XScale','lin');
		set(ax.x,'YScale','lin'); 
		set(ax.y,'XScale','lin');
		set(ax.y,'YScale','lin'); 
		
	case ('Semi-Log Y')
		set(ax.x,'XScale','lin');
		set(ax.x,'YScale','log'); 
		set(ax.y,'XScale','log');
		set(ax.y,'YScale','lin'); 
		
	case ('Semi-Log X')
		set(ax.x,'XScale','log');
		set(ax.x,'YScale','lin'); 
		set(ax.y,'XScale','lin');
		set(ax.y,'YScale','log'); 
		
	case ('Log-Log')
		set(ax.x,'XScale','log');
		set(ax.x,'YScale','log'); 
		set(ax.y,'XScale','log');
		set(ax.y,'YScale','log'); 
		
	end
	
	%--
	% update menu state
	%--
	
	set(data.hist_matrix_menu.histogram(8:11),'check','off');
	set(get_menu(data.hist_matrix_menu.histogram,str),'check','on');
	
%--
% Grid
%--

case ('Grid')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	grid = data.hist_matrix_menu.grid;
	ax = data.hist_matrix_menu.axes;
	
	%--
	% update grid state 
	%--
	
	data.hist_matrix_menu.grid.on = ~grid.on;
	set(h,'userdata',data);
	
	%--
	% update menu and display
	%--
	
	if (~grid.on);

		set(get_menu(data.hist_matrix_menu.histogram,'Grid'),'check','on');
		
		if (grid.x)
			set(ax.x,'xgrid','on');
			set(ax.xy,'xgrid','on');
			set(ax.xy,'ygrid','on');
			set(ax.y,'ygrid','on');
		else
			set(ax.x,'xgrid','off');
			set(ax.xy,'xgrid','off');
			set(ax.xy,'ygrid','off');
			set(ax.y,'ygrid','off');
		end
		if (grid.y)
			set(ax.x,'ygrid','on');
			set(ax.y,'xgrid','on');
		else
			set(ax.x,'ygrid','off');
			set(ax.y,'xgrid','off');
		end
		
	else
		
		set(get_menu(data.hist_matrix_menu.histogram,'Grid'),'check','off');
		
		set(ax.x,'xgrid','off');
		set(ax.x,'ygrid','off');
		set(ax.xy,'xgrid','off');
		set(ax.xy,'ygrid','off');
		set(ax.y,'xgrid','off');
		set(ax.y,'ygrid','off');
		
	end
	
%--
% X Grid
%--

case ('X Grid')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% toggle grid state and update userdata and menu
	%--
	
	data.hist_matrix_menu.grid.x = ~data.hist_matrix_menu.grid.x;
	set(h,'userdata',data);
	
	if (data.hist_matrix_menu.grid.x)
		set(get_menu(data.hist_matrix_menu.grid_options,'X Grid'),'check','on');
	else
		set(get_menu(data.hist_matrix_menu.grid_options,'X Grid'),'check','off');
	end
	
	%--
	% update display
	%--
	
	% this can be more efficient
	
	if (data.hist_matrix_menu.grid.on)
		hist_matrix_menu(h,'Grid');
		hist_matrix_menu(h,'Grid');
	end
	
%--
% Y Grid
%--

case ('Y Grid')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% toggle grid state and update userdata and menu
	%--
	
	data.hist_matrix_menu.grid.y = ~data.hist_matrix_menu.grid.y;
	set(h,'userdata',data);
	
	if (data.hist_matrix_menu.grid.y)
		set(get_menu(data.hist_matrix_menu.grid_options,'Y Grid'),'check','on');
	else
		set(get_menu(data.hist_matrix_menu.grid_options,'Y Grid'),'check','off');
	end
	
	%--
	% update display
	%--
	
	% this can be more efficient
	
	if (data.hist_matrix_menu.grid.on)
		hist_matrix_menu(h,'Grid');
		hist_matrix_menu(h,'Grid');
	end

end
	
