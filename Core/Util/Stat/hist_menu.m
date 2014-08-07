function hist_menu(h,str,flag)

% hist_menu - histogram viewing tools menu
% ----------------------------------------
%
% hist_menu(h,str,flag)
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
			hist_menu(h,str{k}); 
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
		'Fit Model Options', ... 				
		'Linear', ... 		
		'Semi-Log Y', ... 			
		'Semi-Log X', ...		
		'Log-Log', ...
		'Grid', ...
		'Grid Options' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{6} = 'on';
	S{8} = 'on';
	S{12} = 'on';
	
	A = cell(1,n);
	
	tmp = menu_group(h,'hist_menu',L,S,A);
	data.browser.histogram = tmp;
	
	if (data.browser.hist.view)
		set(get_menu(tmp,'Histogram'),'check','on');
	end
	
	if (data.browser.grid.on)
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
	
	data.browser.histogram_options = ...
		menu_group(get_menu(h,'Histogram Options'),'hist_menu',L,S,A);	

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
	
	tmp = menu_group(get_menu(h,'Number of Bins'),'hist_menu',L,S,A);
	data.browser.number_of_bins = tmp;
	
	ix = find(data.browser.hist.bins == [10,100,32,64,128,256]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	else
		set(tmp(end),'check','on');
	end
	
	%--
	% Histogram Color
	%--
	
	tmp = ...
		menu_group(get_menu(data.browser.histogram_options,'Color'), ...
		'hist_menu',COLOR,SEP_COLOR);
	data.browser.histogram_color = tmp;
	
	ix = find(strcmp(data.browser.hist.color,COLOR));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Histogram Line Style
	%--
	
	tmp = ...
		menu_group(get_menu(data.browser.histogram_options,'Line Style'), ...
		'hist_menu',LINESTYLE,SEP_LINESTYLE);
	data.browser.histogram_linestyle = tmp;
	
	ix = find(strcmp(data.browser.hist.linestyle,LINESTYLE));
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
		menu_group(get_menu(data.browser.histogram_options,'Line Width'), ...
		'hist_menu',L,S,A);
	data.browser.histogram_linewidth = tmp;
	
	ix = find(data.browser.hist.linewidth == [1,2,3,4]);
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
		menu_group(get_menu(data.browser.histogram_options,'Patch'), ...
		'hist_menu',L,S,A);
	data.browser.histogram_patch = tmp;
	
	ix = find(data.browser.hist.patch == [-1, 0.25, 0.5, 0.75, 1]);
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
	
	data.browser.kernel_options = ...
		menu_group(get_menu(h,'Kernel Options'),'hist_menu',L,S,A);
	
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
	
	tmp = menu_group(get_menu(h,'Length'),'hist_menu',L,S,A);
	data.browser.kernel_length = tmp;
	
	ix = find(data.browser.kernel.length == [1/2,1/4,1/8,1/16,1/32]);
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
	
	tmp = menu_group(get_menu(h,'Kernel'),'hist_menu',L,S,A);
	data.browser.kernel_type = tmp;
	
	ix = find(strcmp(data.browser.kernel.type,L));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Kernel Color
	%--
	
	tmp = ...
		menu_group(get_menu(data.browser.kernel_options,'Color'), ...
		'hist_menu',COLOR,SEP_COLOR);
	data.browser.kernel_color = tmp;
	
	ix = find(strcmp(data.browser.kernel.color,COLOR));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Kernel Line Style
	%--
	
	tmp = ...
		menu_group(get_menu(data.browser.kernel_options,'Line Style'), ...
		'hist_menu',LINESTYLE,SEP_LINESTYLE);
	data.browser.kernel_linestyle = tmp;
	
	ix = find(strcmp(data.browser.kernel.linestyle,LINESTYLE));
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
		menu_group(get_menu(data.browser.kernel_options,'Line Width'), ...
		'hist_menu',L,S,A);
	data.browser.kernel_linewidth = tmp;
	
	ix = find(data.browser.kernel.linewidth == [1,2,3,4]);
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
		menu_group(get_menu(data.browser.kernel_options,'Patch'), ...
		'hist_menu',L,S,A);
	data.browser.kernel_patch = tmp;
	
	ix = find(data.browser.kernel.patch == [-1, 0.25, 0.5, 0.75, 1]);
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
	
	data.browser.fit_options = ...
		menu_group(get_menu(h,'Fit Model Options'),'hist_menu',L,S,A);

	%--
	% Fit Model
	%--
		
	tmp = ...
		menu_group(get_menu(data.browser.fit_options,'Model'), ...
		'hist_menu',PDF,SEP_PDF);
	data.browser.model = tmp;
	
	ix = find(strcmp(data.browser.fit.model,PDF));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
			
	%--
	% Fit Color
	%--
	
	tmp = ...
		menu_group(get_menu(data.browser.fit_options,'Color'), ...
		'hist_menu',COLOR,SEP_COLOR);
	data.browser.fit_color = tmp;
	
	ix = find(strcmp(data.browser.fit.color,COLOR));
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
	%--
	% Fit Line Style
	%--
	
	tmp = ...
		menu_group(get_menu(data.browser.fit_options,'Line Style'), ...
		'hist_menu',LINESTYLE,SEP_LINESTYLE);
	data.browser.fit_linestyle = tmp;
	
	ix = find(strcmp(data.browser.fit.linestyle,LINESTYLE));
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
		menu_group(get_menu(data.browser.fit_options,'Line Width'), ...
		'hist_menu',L,S,A);
	data.browser.fit_linewidth = tmp;
	
	ix = find(data.browser.fit.linewidth == [1,2,3,4]);
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
		menu_group(get_menu(data.browser.fit_options,'Patch'), ...
		'hist_menu',L,S,A);
	data.browser.fit_patch = tmp;
	
	ix = find(data.browser.fit.patch == [-1, 0.25, 0.5, 0.75, 1]);
	if (~isempty(ix))
		set(tmp(ix),'check','on');
	end
	
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
		menu_group(get_menu(data.browser.histogram,'Grid Options'), ...
		'hist_menu',L,S,A);
	data.browser.grid_options = tmp;
	
	if (data.browser.grid.x)
		set(tmp(2),'check','on');
	end
	if (data.browser.grid.y)
		set(tmp(3),'check','on');
	end
	
	%--
	% Grid Color
	%--

	tmp = ...
		menu_group(get_menu(data.browser.grid_options,'Color'), ...
		'hist_menu',COLOR,SEP_COLOR);
	data.browser.grid_color = tmp;
	
	ix = find(strcmp(data.browser.grid.color,COLOR));
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
	
	if (data.browser.kernel.view)
		hist_menu(h,'Kernel Display');
		set(get_menu(data.browser.histogram,'Kernel Estimate'),'check','on');
	end
	
%--
% Histogram
%--

case ('Histogram')
		
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	hist = data.browser.hist;
	
	%--
	% toggle variable
	%--
	
	data.browser.hist.view = ~hist.view;
	
	%--
	% update userdata and menu
	%--
	
	if (~hist.view)
		set(get_menu(data.browser.histogram,'Histogram'),'check','on');
	else
		set(get_menu(data.browser.histogram,'Histogram'),'check','off');
	end
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_menu(h,'Histogram Display');
	
%--
% Number of Bins
%--

case ({'10','100','32','64','128','256'})
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% udpate userdata and menu
	%--
	
	data.browser.hist.bins = eval(str);
	set(h,'userdata',data);
	
	set(data.browser.number_of_bins,'check','off');
	set(get_menu(data.browser.number_of_bins,str),'check','on');
	
	%--
	% update display
	%--
	
	hist_menu(h,'Histogram Display');
	hist_menu(h,'Kernel Display');

%--
% Other Number of Bins ...
%--

case ('Other Number of Bins ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update number of bins
	%--
	
	% setup input dialog
	
	ans = input_dialog( ...
		{'Number of Bins'}, ...
		'Other Number of Bins ...', ...
		[1,32], ...
		{num2str(data.browser.hist.bins)}, ...
		{'Number of equal sized bins in histogram'} ...
	);

	if (~isempty(ans))
		data.browser.hist.bins = eval(ans{1});
	else
		return;	
	end
	
	%--
	% update userdata and menu
	%--
	
	set(h,'userdata',data);	
	
	set(data.browser.number_of_bins,'check','off');
	set(data.browser.number_of_bins(end),'check','on');
	
	%--
	% update display
	%--
	
	hist_menu(h,'Histogram Display');
	hist_menu(h,'Kernel Display');
	
%--
% Histogram Display
%--

case ('Histogram Display')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(gcf,'userdata');
	
	X = data.browser.data;
	b = data.browser.bounds;
	Z = data.browser.mask;
	
	hist = data.browser.hist;
	
	%--
	% compute and display histogram
	%--
	
	if (hist.view)
		
		%--
		% compute histogram
		%--
		
		[hist.counts,hist.centers,hist.breaks] = ...
			hist_1d(X,hist.bins,b,Z);
		
		%--
		% non-scalar images
		%--
		
		if (iscell(hist.counts))
		
			% remove prevoiusly displayed histograms
			
			tmp = findobj(h,'tag','histogram');
			if (~isempty(tmp))
				delete(tmp);
			end
				
			for k = 1:length(hist.counts)
				
				%--
				% compute normalized histograms
				%--
				
				nh = hist.counts{k} / ((hist.centers{k}(2) - hist.centers{k}(1)) * sum(hist.counts{k}));
				
				%--
				% display histogram
				%--
				
				axes(data.browser.axes(k));
				hold on;
				
				tmp = plot(hist.centers{k},nh, ...
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
					
					px = [hist.centers{k}(1), hist.centers{k}, hist.centers{k}(end), hist.centers{k}(1)];
					py = [0, nh, 0, 0];
					
					tmp = patch(px,py,color_to_rgb(hist.color));
					
					set(tmp,'tag','histogram');
					set(tmp,'facealpha',hist.patch);
					set(tmp,'linestyle','none');
					
				end
				
			end
			
		%--
		% scalar image
		%--
		
		else
			
			%--
			% compute normalized and kernel smoothed histogram
			%--
			
			nh = hist.counts / ((hist.centers(2) - hist.centers(1)) * sum(hist.counts));
			
			%--
			% display normalized histogram
			%--
			
			tmp = findobj(h,'tag','histogram');
			if (~isempty(tmp))
				delete(tmp);
			end
			
			hold on;
			
			tmp = plot(hist.centers,nh, ...
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
				
				px = [hist.centers(1), hist.centers, hist.centers(end), hist.centers(1)];
				py = [0, nh, 0, 0];
				
				tmp = patch(px,py,color_to_rgb(hist.color));
				
				set(tmp,'tag','histogram');
				set(tmp,'facealpha',hist.patch);
				set(tmp,'linestyle','none');
				
			end
			
		end
		
	%--
	% delete displayed normalized histogram
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
	
	data.browser.hist = hist;
	set(h,'userdata',data);

%--
% Kernel Estimate
%--

case ('Kernel Estimate')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	hist = data.browser.hist;
	kernel = data.browser.kernel;
	
	%--
	% toggle variable
	%--
	
	data.browser.kernel.view = ~kernel.view;
	
	%--
	% update userdata and menu
	%--
	
	if (~kernel.view)
		set(get_menu(data.browser.histogram,'Kernel Estimate'),'check','on');
	else
		set(get_menu(data.browser.histogram,'Kernel Estimate'),'check','off');
	end
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_menu(h,'Kernel Display');

%--
% Kernel Display
%--

case ('Kernel Display')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(gcf,'userdata');
	
	hist = data.browser.hist;
	kernel = data.browser.kernel;
	
	%--
	% compute and display kernel smoothed histogram
	%--
	
	if (kernel.view)
		
		%--
		% compute kernel window
		%--
		
		n = round(kernel.length * hist.bins);
		
		ker = kernel_window(kernel.type,n);
		
		%--
		% non-scalar images
		%--
		
		if (iscell(hist.counts))
		
			% remove prevoiusly displayed kernel estimates
			
			tmp = findobj(h,'tag','kernel');
			if (~isempty(tmp))
				delete(tmp);
			end
				
			for k = 1:length(hist.counts)
				
				%--
				% compute normalized and kernel smoothed histograms
				%--
				
				kh = kernel_smooth(hist.counts{k},hist.centers{k},ker);
				
				%--
				% display kernel smoothed histogram
				%--
				
				axes(data.browser.axes(k));
				hold on;
								
				tmp = plot(hist.centers{k},kh, ...
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
					
					px = [hist.centers{k}(1), hist.centers{k}, hist.centers{k}(end), hist.centers{k}(1)];
					py = [0, kh, 0, 0];
					
					tmp = patch(px,py,color_to_rgb(kernel.color));
					
					set(tmp,'tag','kernel');
					set(tmp,'facealpha',kernel.patch);
					set(tmp,'linestyle','none');
					
				end
				
			end
			
		%--
		% scalar image
		%--
		
		else
			
			%--
			% compute normalized and kernel smoothed histogram
			%--

			kh = kernel_smooth(hist.counts,hist.centers,ker);
			
			% TEST TEST 
				
% 			tmp = gcf;
% 			
% 			peak_valley(kh);
% 				
% 			figure(tmp);
			
			%--
			% display kernel smoothed histogram
			%--
			
			tmp = findobj(h,'tag','kernel');
			if (~isempty(tmp))
				delete(tmp);
			end
			
			hold on;
			
			tmp = plot(hist.centers,kh, ...
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
				
				px = [hist.centers(1), hist.centers, hist.centers(end), hist.centers(1)];
				py = [0, kh, 0, 0];
				
				tmp = patch(px,py,color_to_rgb(kernel.color));
				
				set(tmp,'tag','kernel');
				set(tmp,'facealpha',kernel.patch);
				set(tmp,'linestyle','none');
				
			end
			
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
	% update kernel length
	%--
	
	data.browser.kernel.length = eval(strtok(str,' '));
	
	%--
	% update menu and userdata
	%--
	
	set(data.browser.kernel_length,'check','off');
	set(get_menu(data.browser.kernel_length,str),'check','on');
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_menu(h,'Kernel Display');

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
		{[data.browser.kernel.length, 0, 1]}, ...
		{'Length of kernel as fraction number of bins'} ...
	);

	if (~isempty(ans))
		data.browser.kernel.length = ans{1};
	else
		return;	
	end
	
	%--
	% update userdata and menu
	%--
	
	set(h,'userdata',data);	
	
	set(data.browser.kernel_length,'check','off');
	set(data.browser.kernel_length(end),'check','on');
	
	
	%--
	% update display
	%--
	
	hist_menu(h,'Kernel Display');

%--
% Kernel Type
%--

case ({'Binomial','Epanechnikov','Gauss','Tukey','Uniform'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update kernel length
	%--
	
	data.browser.kernel.type = str;
	
	%--
	% update menu and userdata
	%--
	
	set(data.browser.kernel_type,'check','off');
	set(get_menu(data.browser.kernel_type,str),'check','on');
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_menu(h,'Kernel Display');
	
%--
% Fit Model
%--

case ('Fit Model')
		
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	fit = data.browser.fit
	
	%--
	% toggle variable
	%--
	
	data.browser.fit.view = ~fit.view;
	
	%--
	% update userdata and menu
	%--
	
	if (~fit.view)
		set(get_menu(data.browser.histogram,'Fit Model'),'check','on');
	else
		set(get_menu(data.browser.histogram,'Fit Model'),'check','off');
	end
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	hist_menu(h,'Fit Display');
	
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
	
	fit = data.browser.fit;
	
	%--
	% set model and update userdata and menu
	%--
	
	data.browser.fit.model = str;
	set(h,'userdata',data);
	
	set(data.browser.model,'check','off');
	set(get_menu(data.browser.model,str),'check','on');
	
	%--
	% update display
	%--
	
	hist_menu(h,'Fit Display');
	
%--
% Fit Display
%--

case ('Fit Display')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(gcf,'userdata');
	
	X = data.browser.data;
	Z = data.browser.mask;
	
	hist = data.browser.hist
	fit = data.browser.fit
	
	ax = data.browser.axes;
	
	%--
	% get data indices if mask is not empty
	%--
	
	if (~isempty(Z))
		ix = find(Z);
	end
	
	%--
	% compute and display model fit to histogram
	%--
	
	if (fit.view)
					
		%--
		% non-scalar images
		%--
		
		if (iscell(hist.counts))
		
			% remove prevoiusly displayed model fit
			
			tmp = findobj(h,'tag','fit');
			if (~isempty(tmp))
				delete(tmp);
			end
				
			for k = 1:length(hist.counts)
				
				%--
				% select data using mask if needed and compute fit
				%--
				
				if (iscell(X))
					
					tmp = X{k};
					if (~isempty(Z))
						tmp = tmp(ix);
					end
					
					[p,fh] = hist_1d_fit(tmp,fit.model,hist.centers{k});
					fit.par{k} = p;
					
				else
					
					tmp = X(:,:,k);
					if (~isempty(Z))
						tmp = tmp(ix);
					end
					
					[p,fh] = hist_1d_fit(tmp,fit.model,hist.centers{k});
					fit.par{k} = p;
					
				end
				
				%--
				% display model fit histogram
				%--
				
				axes(ax(k));
				hold on;
								
				tmp = plot(hist.centers{k},fh, ...
					'linestyle',linestyle_to_str(fit.linestyle), ...
					'linewidth',fit.linewidth, ...
					'color',color_to_rgb(fit.color) ...
				);
				
				set(tmp,'tag','fit');
				
				%--
				% display patch model fit
				%--
				
				if (fit.patch > 0)
					
					hold on;
					
					px = [hist.centers{k}(1), hist.centers{k}, hist.centers{k}(end), hist.centers{k}(1)];
					py = [0, fh, 0, 0];
					
					tmp = patch(px,py,color_to_rgb(fit.color));
					
					set(tmp,'tag','fit');
					set(tmp,'facealpha',fit.patch);
					set(tmp,'linestyle','none');
					
				end
				
				%--
				% display parameter values in contextmenu
				%--
				
				% remove previous model information menus
				
				tmp = findobj(h,'type','uicontextmenu','tag',['context.' num2str(k)]);
				tmp = get_menu(tmp,'Model');
				
				delete(get(tmp,'children'));
				
				% get parameter names and types
		
				par = prob_to_par(fit.model);
				
				% create menu
				
				L{1} = [data.browser.fit.model];
				
				for k = 1:length(p)
					L{k + 1} = [ par{k} ': ' num2str(p(k))];
				end
				
				n = length(L);
				S = bin2str(zeros(1,n));
				S{2} = 'on';
							
				menu_group(tmp,'',L,S);
								
			end
			
		%--
		% scalar image
		%--
		
		else
			
			%--
			% get mask indices if mask is not empty
			%--
			
			if (~isempty(Z))
				ix = find(Z);
			end
			
			%--
			% select data using mask if needed and compute model fit
			%--
			
			tmp = X;
			if (~isempty(Z))
				tmp = tmp(ix);
			end
						
			[p,fh] = hist_1d_fit(tmp,fit.model,hist.centers);
			fit.par = p;
			
			%--
			% display kernel smoothed histogram
			%--
			
			tmp = findobj(h,'tag','fit');
			if (~isempty(tmp))
				delete(tmp);
			end
			
			hold on;
			
			tmp = plot(hist.centers,fh, ...
				'linestyle',linestyle_to_str(fit.linestyle), ...
				'linewidth',fit.linewidth, ...
				'color',color_to_rgb(fit.color) ...
			);
					
			set(tmp,'tag','fit');
			
			%--
			% display patch model fit
			%--
			
			if (fit.patch > 0)
				
				hold on;
				
				px = [hist.centers(1), hist.centers, hist.centers(end), hist.centers(1)];
				py = [0, fh, 0, 0];
				
				tmp = patch(px,py,color_to_rgb(fit.color));
				
				set(tmp,'tag','fit');
				set(tmp,'facealpha',fit.patch);
				set(tmp,'linestyle','none');
				
			end
			
			%--
			% display parameter values in contextmenu
			%--
			
			% remove previous model information menus
			
			tmp = findobj(h,'type','uicontextmenu','tag','context');
			tmp = get_menu(tmp,'Model');
			
			delete(get(tmp,'children'));
			
			% get parameter names and types
		
			par = prob_to_par(fit.model);
				
			% create menu
			
			L{1} = [data.browser.fit.model];
			
			for k = 1:length(p)
				L{k + 1} = [par{k} ': ' num2str(p(k))];
			end
			
			n = length(L);
			S = bin2str(zeros(1,n));
			S{2} = 'on';
						
			menu_group(tmp,'',L,S);
			
		end
		
	%--
	% delete displayed model fit
	%--
	
	else
					
		tmp = findobj(h,'tag','fit');
		if (~isempty(tmp))
			delete(tmp);
		end
	
	end
	
	%--
	% update fit userdata
	%--
	
	data.browser.fit = fit;
	
	set(h,'userdata',data);
	
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
		
		data.browser.hist.color = str;
		
		if (data.browser.hist.view)
			tmp = findobj(h,'type','line','tag','histogram');
			if (~isempty(tmp))
				set(tmp,'color',color_to_rgb(str));
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
		
		set(data.browser.histogram_color,'check','off');
		set(gcbo,'check','on');
		
	case ('Kernel Options')
		
		data.browser.kernel.color = str;
		
		if (data.browser.kernel.view)
			tmp = findobj(h,'type','line','tag','kernel');
			if (~isempty(tmp))
				set(tmp,'color',color_to_rgb(str));
			end
		end
		
		set(data.browser.kernel_color,'check','off');
		set(gcbo,'check','on');
		
	case ('Fit Options')
		
		data.browser.fit.color = str;
		
		if (data.browser.fit.view)
			tmp = findobj(h,'type','line','tag','fit');
			if (~isempty(tmp))
				set(tmp,'color',color_to_rgb(str));
			end
		end
		
		set(data.browser.fit_color,'check','off');
		set(gcbo,'check','on');
		
	case ('Grid Options')
		
		data.browser.grid.color = str;

		set(data.browser.axes,'xcolor',color_to_rgb(str));
		set(data.browser.axes,'ycolor',color_to_rgb(str));
		
		set(data.browser.grid_color,'check','off');
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
		
		data.browser.hist.linestyle = str;
		
		if (data.browser.hist.view)
			tmp = findobj(h,'type','line','tag','histogram');
			if (~isempty(tmp))
				set(tmp,'marker','none');
				set(tmp,'linestyle',linestyle_to_str(str));
			end
		end
		
		set(data.browser.histogram_linestyle,'check','off');
		set(gcbo,'check','on');
		
	case ('Kernel Options')
		
		data.browser.kernel.linestyle = str;
		
		if (data.browser.kernel.view)
			tmp = findobj(h,'type','line','tag','kernel');
			if (~isempty(tmp))
				set(tmp,'marker','none');
				set(tmp,'linestyle',linestyle_to_str(str));
			end
		end
		
		set(data.browser.kernel_linestyle,'check','off');
		set(gcbo,'check','on');
		
	case ('Fit Options')
		
		data.browser.fit.linestyle = str;
		
		if (data.browser.fit.view)
			tmp = findobj(h,'type','line','tag','fit');
			if (~isempty(tmp))
				set(tmp,'marker','none');
				set(tmp,'linestyle',linestyle_to_str(str));
			end
		end
		
		set(data.browser.fit_linestyle,'check','off');
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
		
		data.browser.hist.linewidth = eval(str);
		
		if (data.browser.hist.view)
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
		
		set(data.browser.histogram_linewidth,'check','off');
		set(gcbo,'check','on');
		
	case ('Kernel Options')
		
		data.browser.kernel.linewidth = eval(str);
		
		if (data.browser.kernel.view)
			tmp = findobj(h,'type','line','tag','kernel');
			if (~isempty(tmp))
				set(tmp,'linewidth',eval(str));
			end
		end
		
		set(data.browser.kernel_linewidth,'check','off');
		set(gcbo,'check','on');
		
	case ('Fit Options')
		
		data.browser.fit.linewidth = eval(str);
		
		if (data.browser.fit.view)
			tmp = findobj(h,'type','line','tag','fit');
			if (~isempty(tmp))
				set(tmp,'linewidth',eval(str));
			end
		end
		
		set(data.browser.fit_linewidth,'check','off');
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
		
		data.browser.hist.patch = alpha;
		
		if (data.browser.hist.view)
			tmp = findobj(h,'type','patch','tag','histogram');
			if (~isempty(tmp))
				if (alpha > 0)
					set(tmp,'facealpha',alpha);
				else
					delete(tmp);
				end
			else
				set(h,'userdata',data);
				hist_menu(h,'Histogram Display');
			end
		end
		
		set(data.browser.histogram_patch,'check','off');
		set(gcbo,'check','on');
		
	case ('Kernel Options')
		
		data.browser.kernel.patch = alpha;
		
		if (data.browser.kernel.view)
			tmp = findobj(h,'type','patch','tag','kernel');
			if (~isempty(tmp))
				if (alpha > 0)
					set(tmp,'facealpha',alpha);
				else
					delete(tmp);
				end
			else
				set(h,'userdata',data);
				hist_menu(h,'Kernel Display');
			end
		end
		
		set(data.browser.kernel_patch,'check','off');
		set(gcbo,'check','on');
		
	case ('Fit Options')
		
		data.browser.fit.patch = alpha;
		
		if (data.browser.fit.view)
			tmp = findobj(h,'type','patch','tag','fit');
			if (~isempty(tmp))
				if (alpha > 0)
					set(tmp,'facealpha',alpha);
				else
					delete(tmp);
				end
			else
				set(h,'userdata',data);
				hist_menu(h,'Fit Display');
			end
		end
		
		set(data.browser.fit_patch,'check','off');
		set(gcbo,'check','on');
		
	end
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
%--
% Axes Scaling
%--

case ({'Linear','Semi-Log Y','Semi-Log X','Log-Log'})
	
	%--
	% get axes handles from userdata
	%--
	
	data = get(h,'userdata');
	ax = data.browser.axes;
	
	%--
	% set axes scale
	%--
	
	switch (str)

	case ('Linear')
		set(ax,'XScale','lin');
		set(ax,'YScale','lin'); 
		
	case ('Semi-Log Y')
		set(ax,'XScale','lin');
		set(ax,'YScale','log'); 
		
	case ('Semi-Log X')
		set(ax,'XScale','log');
		set(ax,'YScale','lin'); 
		
	case ('Log-Log')
		set(ax,'XScale','log');
		set(ax,'YScale','log'); 
		
	end
	
	%--
	% update menu state
	%--
	
	set(data.browser.histogram(8:11),'check','off');
	set(get_menu(data.browser.histogram,str),'check','on');
	
%--
% Grid
%--

case ('Grid')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	grid = data.browser.grid;
	ax = data.browser.axes;
	
	%--
	% update grid state 
	%--
	
	data.browser.grid.on = ~grid.on;
	set(h,'userdata',data);
	
	%--
	% update menu and display
	%--
	
	if (~grid.on);

		set(get_menu(data.browser.histogram,'Grid'),'check','on');
		
		if (grid.x)
			set(ax,'xgrid','on');
		else
			set(ax,'xgrid','off');
		end
		if (grid.y)
			set(ax,'ygrid','on');
		else
			set(ax,'ygrid','off');
		end
		
	else
		
		set(get_menu(data.browser.histogram,'Grid'),'check','off');
		
		set(ax,'xgrid','off');
		set(ax,'ygrid','off');
		
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
	
	data.browser.grid.x = ~data.browser.grid.x;
	set(h,'userdata',data);
	
	if (data.browser.grid.x)
		set(get_menu(data.browser.grid_options,'X Grid'),'check','on');
	else
		set(get_menu(data.browser.grid_options,'X Grid'),'check','off');
	end
	
	%--
	% update display
	%--
	
	% this can be more efficient
	
	if (data.browser.grid.on)
		hist_menu(h,'Grid');
		hist_menu(h,'Grid');
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
	
	data.browser.grid.y = ~data.browser.grid.y;
	set(h,'userdata',data);
	
	if (data.browser.grid.y)
		set(get_menu(data.browser.grid_options,'Y Grid'),'check','on');
	else
		set(get_menu(data.browser.grid_options,'Y Grid'),'check','off');
	end
	
	%--
	% update display
	%--
	
	% this can be more efficient
	
	if (data.browser.grid.on)
		hist_menu(h,'Grid');
		hist_menu(h,'Grid');
	end

end

refresh(h);
	
