function g = hist_1d_view(h,c,v,N)

% hist_1d_view - display 1d histograms
% ------------------------------------
% 
% g = hist_1d_view(h,c,v,N)
% 
% Input:
% ------
%  h - bin counts
%  c - bin centers
%  v - bin breaks
%  N - variable names
%
% Output:
% -------
%  g - handles to axes

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
% set names
%--

if (nargin < 4)
	N = [];
else
	if (iscell(h) & isstr(N))
		for k = 1:length(h)
			tmp{k} = [N '{' num2str(k) '}'];
		end
		N = tmp;
	end
end

%--
% image stack or color image histogram
%--

if (iscell(h))
	
	%--
	% set display options
	%--
	
	% RGB display
	
	if (length(h) == 3)

			opt(1).line = '-';
			opt(1).mark = 'o';
			opt(1).grid = 1;
			opt(1).color = color_to_rgb('Red');
			
			opt(2).line = '-';
			opt(2).mark = 'o';
			opt(2).grid = 1;
			opt(2).color = color_to_rgb('Green');
			
			opt(3).line = '-';
			opt(3).mark = 'o';
			opt(3).grid = 1;
			opt(3).color = color_to_rgb('Blue');
		
	% generic display
	
	else
		
		for k = 1:length(h)
			opt(k).line = '-';
			opt(k).mark = 'o';
			opt(k).grid = 1;
			opt(k).color = color_to_rgb('Green');
		end
		
	end
	
	%--
	% plots
	%--
	
	m = length(h);
	
	for k = 1:m
	
		%--
		% normalize if needed and scale histogram
		%--
		
		s = sum(h{k}(:));
		w = c{k}(2) - c{k}(1);
		
		if (s ~= 1)
			h{k} = h{k} / (w * s);
		else
			h{k} = h{k} / w;
		end
		
		%--
		% create subplot
		%--
		
		g(k) = subplot(m,1,k);
		
		%--
		% display normalized histogram with tight axes
		%--
		
		plot(c{k},h{k},opt(k).line,'color',opt(k).color);
		
		if (length(c{k}) < 33)
			hold on;
			plot(c{k},h{k},opt(k).mark,'color',opt(k).color);
		end
		
		ax = axis;
		axis([v{k}(1) v{k}(end) ax(3:4)]);
		
		%--
		% display grid
		%--
		
		if (opt(k).grid)
			grid on;
		end
		
		%--
		% add scaling axes
		%--
		
		axes_scale_bdfun(gca,'y');
		
		%--
		% annotate individual axes
		%--
		
		ylabel_edit(N{k});
		
	end
	
	%--
	% annotate group
	%--
		
	% title
	
	axes(g(1));
	title_edit('Normalized Histograms')
	
	% sample size if available
	
	if (s ~= 1)
		axes(g(m));
		xlabel_edit(['N = ' num2str(s)]);
	end	
	
%--
% grayscale image
%--

else

	%--
	% set display options
	%--
	
	opt.line = '-';
	opt.mark = 'o';
	opt.grid = 1;
	opt.color = color_to_rgb('Green');
	
	%--
	% plots
	%--
	
	%--
	% normalize if needed and scale histogram
	%--
	
	s = sum(h(:));
	w = c(2) - c(1);
	
	if (s ~= 1)
		h = h / (w * s);
	else
		h = h / w;
	end
				
	%--
	% display normalized histogram with tight axes
	%--
	
	plot(c,h,opt.line,'color',opt.color);
	
	if (length(c) < 33)
		hold on;
		plot(c,h,opt.mark,'color',opt.color);
	end
	
	ax = axis;
	axis([v(1) v(end) ax(3:4)]);
	
	%--
	% display grid
	%--
	
	if (opt.grid)
		grid on;
	end
	
	%--
	% add scaling axes
	%--
	
	axes_scale_bdfun(gca,'y');
	
	%--
	% annotate
	%--
	
	if (~isempty(N))
		title_edit(['Normalized Histogram of ' N]);
		if (s ~= 1)
			xlabel_edit(['N = ' num2str(s)]);
		end
	else
		title_edit('Normalized Histogram');
		if (s ~= 1)
			xlabel_edit(['N = ' num2str(s)]);
		end
	end
	
end

%--
% 1D HISTOGRAM DISPLAY
%--

% %--
% % display
% %--
% 
% t = opt.pdf + opt.cdf;
% 	
% switch (t)
% 
% 	%--
% 	% histogram or cumulative display
% 	%--
% 	
% 	case (1)
% 	
% 		if (opt.pdf)
% 
% 			% normalize and scale histogram
% 		
% 			N = sum(h);
% 			w = c(2) - c(1);
% 			g = h / (w * N);
% 						
% 			% normalized histogram
% 			
% 			plot(c,g,opt.line);
% 			
% 			if (length(c) < 100)
% 				hold on;
% 				plot(c,g,opt.mark);
% 			end
% 							
% 			ax = axis;
% 			axis([v(1) v(end) ax(3:4)]);
% 			
% 			grid on;
% 			
% 			axes_scale_bdfun(gca,'y');
% 			
% 			if (~isempty(inputN(1)))
% 				title_edit(['Histogram of ' inputN(1)]);
% 			else
% 				title_edit('Histogram');
% 			end
% 			
% 		else
% 		
% 			% normalize and scale histogram and compute cumulative
% 	
% 			N = sum(h);
% 			w = c(2) - c(1);
% 			g = h / (w * N);
% 												
% 			t = cumsum(g);
% 			t = t / t(end);
% 			
% 			% cumulative distribution
% 			
% 			plot(c,t,opt.line);
% 			
% 			if (length(c) < 100)
% 				hold on;
% 				plot(c,t,opt.mark);
% 			end
% 						
% 			ax = axis;
% 			axis([v(1) v(end) ax(3:4)]);
% 			
% 			grid on;
% 			
% 			axes_scale_bdfun(gca,'y');
% 			
% 			if (~isempty(inputN(1)))
% 				title_edit(['Cumulative Distribution of ' inputN(1)]);
% 				xlabel_edit(inputN(1));
% 			else
% 				title_edit('Cumulative Distribution');
% 				xlabel_edit('X');
% 			end
% 		
% 		end
% 	
% 	%--
% 	% normalized histogram and cumulative distribution
% 	%--
% 	
% 	case (2)
% 	
% 		
% 		% normalize and scale histogram
% 	
% 		N = sum(h);
% 		w = c(2) - c(1);
% 		g = h / (w * N);
% 					
% 		% normalized histogram
% 		
% 		subplot(2,1,1)
% 
% 		plot(c,g,opt.line);
% 		
% 		if (length(c) < 100)
% 			hold on;
% 			plot(c,g,opt.mark);
% 		end
% 					
% 		ax = axis;
% 		axis([v(1) v(end) ax(3:4)]);
% 		
% 		grid on;
% 		
% 		axes_scale_bdfun(gca,'y');
% 		
% 		if (~isempty(inputN(1)))
% 			title_edit(['Histogram of ' inputN(1)]);
% 		else
% 			title_edit('Histogram');
% 		end
% 
% 		% cumulative distribution
% 		
% 		subplot(2,1,2);
% 		
% 		% compute cumulative distribution
% 		
% 		t = cumsum(g);
% 		t = t / t(end);
% 		
% 		plot(c,t,opt.line);
% 		
% 		if (length(c) < 100)
% 			hold on;
% 			plot(c,t,opt.mark);
% 		end
% 								
% 		ax = axis;
% 		axis([v(1) v(end) ax(3:4)]);
% 		
% 		grid on;
% 		
% 		axes_scale_bdfun(gca,'y');
% 		
% 		if (~isempty(inputN(1)))
% 			title_edit(['Cumulative Distribution of ' inputN(1)]);
% 			xlabel_edit(inputN(1));
% 		else
% 			title_edit('Cumulative Distribution');
% 			xlabel_edit('X');
% 		end
% 		
% end
	



