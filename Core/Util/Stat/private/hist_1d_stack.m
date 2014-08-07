function [h,c,v] = hist_1d_stack(X,n,b,Z,opt)

% hist_1d_stack - 1 dimensional histogram for stacks
% --------------------------------------------------
%
% [h,c,v] = hist_1d_stack(X,n,b,Z,opt)
%
% Input:
% ------
%  X - input stack
%  n - number of bins 
%  b - cell array of bounds for values 
%  Z - computation mask
%  opt - histogram display options
%
% Output:
% -------
%  h - cell array of bin counts
%  c - cell array of bin centers
%  v - cell array of bin breaks

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

%--
% compute frame histograms
%--

nf = length(X);

%--
% compute histogram using mex file
%--

for k = 1:nf
	if (isa(X{1},'double'))
		[h{k},c{k},v{k}] = hist_1d_double(X{k},n,b{k},uint8(Z));
	elseif (isa(X{1},'uint8'))
		[h{k},c{k},v{k}] = hist_1d_uint8(X{k},n,b{k},uint8(Z));
	end
end

%--
% display frame histograms
%--

t = opt.pdf + opt.cdf;
	
switch (t)

	%--
	% histogram or cumulative
	%--
	
	case (1)
		
		switch (opt.disp)
		
			%--
			% subplot display
			%--
			
			case ('sub')
						
				%--
				% histogram display
				%--
				
				if (opt.pdf)
				
					for k = 1:nf
					
						% normalize and scale histogram
					
						N = sum(h{k});
						w = c{k}(2) - c{k}(1);
						g = h{k} / (w * N);
						
						% normalized histogram
						
						subplot(nf,1,k);
						
						plot(c{k},g,opt.line);
						
						if (length(c{k}) < 100)
							hold on;
							plot(c{k},g,opt.mark);
						end
													
						ax = axis;
						axis([v{k}(1) v{k}(end) ax(3:4)]);
						
						% grid on;
						
						axes_scale_bdfun(gca,'y');
						
						% annotate
						
						if (k == 1)
						
							if (~isempty(inputname(1)))
								title_edit(['Normalized Histogram of ' inputname(1)]);
								ylabel_edit(['k = ' num2str(k)]);
							else
								title_edit('Normalized Histogram');
								ylabel_edit(['k = ' num2str(k)]);
							end
							
						elseif (k == nf)
						
							if (~isempty(inputname(1)))
								xlabel_edit(inputname(1));
								ylabel_edit(['k = ' num2str(k)]);
							else
								xlabel_edit('X');
								ylabel_edit(['k = ' num2str(k)]);
							end
							
						else
						
							ylabel_edit(['k = ' num2str(k)]);
							
						end
						
					end
				
				%--
				% cumulative display
				%--
				
				else
				
					for k = 1:nf
		
						% normalize and scale histogram, and compute cumulative
					
						N = sum(h{k});
						w = c{k}(2) - c{k}(1);
						g = h{k} / (w * N);
						
						t = cumsum(g);
						t = t / t(end);
				
						% cumulative distribution
						
						subplot(nf,1,k);
								
						plot(c{k},t,opt.line);
						
						if (length(c{k}) < 100)
							hold on;
							plot(c{k},t,opt.mark);
						end
																
						ax = axis;
						axis([v{k}(1) v{k}(end) ax(3:4)]);
						
						% grid on;
						
						axes_scale_bdfun(gca,'y');
						
						% annotate
						
						if (k == 1)
						
							if (~isempty(inputname(1)))
								title_edit(['Cumulative Distribution of ' inputname(1)]);
							else
								title_edit('Cumulative Distribution');
							end
							
						elseif (k == nf)
						
							if (~isempty(inputname(1)))
								xlabel_edit(inputname(1));
							else
								xlabel_edit('X');
							end
							
						end
						
					end
				
				end
				
			%--
			% linetype display
			%--
			
			case ('type')
				
				%--
				% histogram display
				%--
				
				if (opt.pdf)
				
					% get linetype sequence
					
					S = line_type(nf,opt.line_order);
					
					% compute and plot histograms
					
					for k = 1:nf
											
						% normalize and scale histogram
					
						N = sum(h{k});
						w = c{k}(2) - c{k}(1);
						g = h{k} / (w * N);
						
						% normalized histogram
												
						plot(c{k},g,S{k});
						
						hold on;
						
						ax = axis;
						axis([v{k}(1) v{k}(end) ax(3:4)]);
																			
					end
										
					% grid on;
					
					axes_scale_bdfun(gca,'y');
					
					% annotate
					
					if (~isempty(inputname(1)))
						title_edit(['Normalized Histogram of ' inputname(1)]);
					else
						title_edit('Normalized Histogram');
					end
				
				%--
				% cumulative display
				%--
				
				else
				
					% get linetype sequence
					
					S = line_type(nf,opt.line_order);
					
					% compute and plot histograms
					
					for k = 1:nf
											
						% normalize and scale histogram
					
						N = sum(h{k});
						w = c{k}(2) - c{k}(1);
						g = h{k} / (w * N);
						
						% compute cumulative distribution
					
						t = cumsum(g);
						t = t / t(end);
						
						plot(c{k},t,S{k});
						hold on;
													
						ax = axis;
						axis([v{k}(1) v{k}(end) ax(3:4)]);
																								
					end
										
					% grid on;
					
					axes_scale_bdfun(gca,'y');
					
					% annotate
										
					if (~isempty(inputname(1)))
						title_edit(['Cumulative Distribution of ' inputname(1)]);
					else
						title_edit('Cumulative Distribution');
					end
											
					if (~isempty(inputname(1)))
						xlabel_edit(inputname(1));
					else
						xlabel_edit('X');
					end
										
				end
				
		end
	
	%--
	% normalized histogram and cumulative distribution
	%--
	
	case (2)
	
		switch (opt.disp)
		
			%--
			% subplot display
			%--
			
			case ('sub')
		
				for k = 1:nf
				
					% normalize and scale histogram
				
					N = sum(h{k});
					w = c{k}(2) - c{k}(1);
					g = h{k} / (w * N);
					
					% normalized histogram
					
					subplot(nf,2,2*k - 1);
					
					plot(c{k},g,opt.line);
					
					if (length(c{k}) < 100)
						hold on;
						plot(c{k},g,opt.mark);
					end
											
					ax = axis;
					axis([v{k}(1) v{k}(end) ax(3:4)]);
					
					% grid on;
					
					axes_scale_bdfun(gca,'y');
					
					% annotate
					
					if (k == 1)
						if (~isempty(inputname(1)))
							title_edit(['Normalized Histogram of ' inputname(1)]);
							ylabel_edit(['k = ' num2str(k)]);
						else
							title_edit('Normalized Histogram');
							ylabel_edit(['k = ' num2str(k)]);
						end
					elseif (k == nf)
						if (~isempty(inputname(1)))
							xlabel_edit(inputname(1));
							ylabel_edit(['k = ' num2str(k)]);
						else
							xlabel_edit('X');
							ylabel_edit(['k = ' num2str(k)]);
						end
					else
						ylabel_edit(['k = ' num2str(k)]);
					end
			
					% cumulative distribution
					
					subplot(nf,2,2*k);
					
					% compute cumulative distribution
					
					t = cumsum(g);
					t = t / t(end);
					
					plot(c{k},t,opt.line);
					
					if (length(c{k}) < 100)
						hold on;
						plot(c{k},t,opt.mark);
					end
												
					ax = axis;
					axis([v{k}(1) v{k}(end) ax(3:4)]);
					
					% grid on;
					
					axes_scale_bdfun(gca,'y');
					
					% annotate
					
					if (k == 1)
					
						if (~isempty(inputname(1)))
							title_edit(['Cumulative Distribution of ' inputname(1)]);
						else
							title_edit('Cumulative Distribution');
						end
						
					elseif (k == nf)
					
						if (~isempty(inputname(1)))
							xlabel_edit(inputname(1));
						else
							xlabel_edit('X');
						end
						
					end
					
				end
			
			%--
			% linetype display
			%--
			
			case ('type')
			
				% get linetype sequence
					
				S = line_type(nf,opt.line_order);
				
				% compute and plot histograms
				
				for k = 1:nf
										
					% normalize and scale histogram
				
					N = sum(h{k});
					w = c{k}(2) - c{k}(1);
					g = h{k} / (w * N);
					
					% compute cumulative distribution
				
					t = cumsum(g);
					t = t / t(end);
					
					% display histogram
					
					subplot(2,1,1);
					
					plot(c{k},g,S{k});
					hold on;
												
					ax = axis;
					axis([v{k}(1) v{k}(end) ax(3:4)]);
					
					% display cumulative
					
					subplot(2,1,2);
					
					plot(c{k},t,S{k});
					hold on;
												
					ax = axis;
					axis([v{k}(1) v{k}(end) ax(3:4)]);
																							
				end
				
				% annotate
				
				subplot(2,1,1);
				
				% grid on;
				axes_scale_bdfun(gca,'y');
				
				if (~isempty(inputname(1)))
					title_edit(['Normalized Histogram of ' inputname(1)]);
				else
					title_edit('Normalized Histogram');
				end
				
				subplot(2,1,2);
				
				% grid on;
				axes_scale_bdfun(gca,'y');
				
				if (~isempty(inputname(1)))
					title_edit(['Cumulative Distribution of ' inputname(1)]);
				else
					title_edit('Cumulative Distribution');
				end
				
				if (~isempty(inputname(1)))
					xlabel_edit(inputname(1));
				else
					xlabel_edit('X');
				end
												
		end
		
end
