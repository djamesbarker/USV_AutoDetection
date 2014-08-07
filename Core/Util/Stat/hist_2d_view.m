%--
% display
%--

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

if (~nargout | opt)

	switch (opt)
	
		%--
		% log scaled normalized histogram
		%--
		
		case (1)
	
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
			% display according to data type
			%--
			
			if (isa(X,'double'))
	
				% display image
				
				image(G,'CDataMapping','scaled','XData',b(1,:),'YData',b(2,:));
				set(gca,'Clim',m);
				axis('xy');
				
				% set aspect ratio
				
% 				r = (b.x(2) - b.x(1)) / (b.y(2) - b.y(1));
% 				r = min(r,1/r);
% 				
% 				if (r > 0.33)
% 					axis('image');
% 				end
											
			elseif (isa(X,'uint8'))
				
				% display image
				
				image(G,'CDataMapping','scaled','XData',[0 255],'YData',[0 255]);
				set(gca,'Clim',m);
				axis('xy');
				
				% set aspect ratio
				
				axis('image');
									
				% add identity
				
				hold on;
				plot([0,255],[0,255],'w:');
								
			end
			
			% set colormap
			
			colormap(hot);
			
			% add quartile contours
			
		  	hold on;
		 	
			[v,q] = hist_2d_level(H);
			
		 	[c,h] = contour(c.x,c.y,median_filter(H/N,se_ball(3)),v);
			set(h,'EdgeColor',ones(1,3),'LineStyle','--');
															
			%--
			% label axes
			%--
				
			% planes of multiple-plane image
			
			if (flag)
			
				if (~isempty(inputname(1)))
					N1 = [inputname(1) '(:,:,' num2str(p(1)) ')'];
					N2 = [inputname(1) '(:,:,' num2str(p(2)) ')'];
					T = ['Joint Histogram of ' N1 ' and ' N2];
					title_edit(T);
					xlabel_edit(N1);
					ylabel_edit(N2);
				else
					N1 = ['[inputname(1)](:,:,' num2str(p(1)) ')'];
					N2 = ['[inputname(1)](:,:,' num2str(p(2)) ')'];
					T = ['Joint Histogram of ' N1 ' and ' N2];
					title_edit(T);
					xlabel_edit(N1);
					ylabel_edit(N2);
				end
				
			% separate images
			
			else
				
				if (~isempty(inputname(1)))
					xlabel_edit(inputname(1));
					N1 = inputname(1);
				else
					xlabel_edit('[inputname(1)]');
					N1 = '[inputname(1)]';
				end
				
				if (~isempty(inputname(2)))
					ylabel_edit(inputname(2));
					N2 = inputname(2);
				else
					ylabel_edit('[inputname(2)]');
					N2 = '[inputname(2)]';
				end

				T = ['Joint Histogram of ' N1 ' and ' N2];
				title_edit(T);
				
			end
		
			% titled colorbar
			
% 			colorbar;
			
		%--
		% histogram and marginals
		%--
		
		case (2)
		
			%--
			% normalize and scale histogram
			%--
			
			N = sum(H(:));
			w = (c.x(2) - c.x(1))*(c.y(2) - c.y(1));
			G = H / (w * N);
						
			% compute marginals and product distribution
			
			wx = (c.x(2) - c.x(1));
			Gx = sum(H,1) / (wx * N);
						
			wy = (c.y(2) - c.y(1));
			Gy = sum(H,2) / (wy * N);
						
			Gxy = Gy*Gx;
						
			% logarithmic scaling
			
			G = log10(G);
			Z = isfinite(G);
			m = double(fast_min_max(G,Z));
			
			Gxy = log10(Gxy);
			Zxy = isfinite(Gxy);
			mxy = double(fast_min_max(Gxy,Zxy));
			
			%--
			% JOINT HISTOGRAM
			%--
			
			%--
			% display according to data type
			%--
			
			subplot(2,2,2);
			
			if (isa(X,'double'))
	
				% display image
				
				image(G,'CDataMapping','scaled','XData',b(1,:),'YData',b(2,:));
				set(gca,'Clim',m);
				axis('xy');
				
				% set aspect ratio
				
% 				r = (b.x(2) - b.x(1)) / (b.y(2) - b.y(1));
% 				r = min(r,1/r);
% 				
% 				if (r > 0.33)
% 					axis('image');
% 				end
				
				% add identity
							
			elseif (isa(X,'uint8'))
				
				% display image
				
				image(G,'CDataMapping','scaled','XData',[0 255],'YData',[0 255]);
				set(gca,'Clim',m);
				axis('xy');
				
				% set aspect ratio
				
				axis('image');
									
				% add identity
				
				hold on;
				plot([0,255],[0,255],'w:');
								
			end
			
			% set colormap
			
			colormap(hot);
			
			% add quartile contours
			
		  	hold on;
		 	
			[V,q] = hist_2d_level(H);
			
		 	[tmp,h] = contour(c.x,c.y,median_filter(H/N,se_ball(3)),V);
			set(h,'EdgeColor',ones(1,3),'LineStyle','--');
															
			%--
			% label axes
			%--
				
			% planes of multiple-plane image
			
			if (flag)
				
				if (~isempty(inputname(1)))
					N1 = [inputname(1) '(:,:,' num2str(p(1)) ')'];
					N2 = [inputname(1) '(:,:,' num2str(p(2)) ')'];
					T = ['Joint Histogram of ' N1 ' and ' N2];
					title_edit(T);
					xlabel_edit(N1);
					ylabel_edit(N2);
				else
					N1 = ['[inputname(1)](:,:,' num2str(p(1)) ')'];
					N2 = ['[inputname(1)](:,:,' num2str(p(2)) ')'];
					T = ['Joint Histogram of ' N1 ' and ' N2];
					title_edit(T);
					xlabel_edit(N1);
					ylabel_edit(N2);
				end
			
			% separate images
			
			else
				
				if (~isempty(inputname(1)))
					xlabel_edit(inputname(1));
					N1 = inputname(1);
				else
					xlabel_edit('[inputname(1)]');
					N1 = '[inputname(1)]';
				end
				
				if (~isempty(inputname(2)))
					ylabel_edit(inputname(2));
					N2 = inputname(2);
				else
					ylabel_edit('[inputname(2)]');
					N2 = '[inputname(2)]';
				end

				T = ['Joint Histogram of ' N1 ' and ' N2];
				title_edit(T);
				
			end
		
			% titled colorbar
			
% 			colorbar;
			
			%--
			% MARGINALS
			%--
			
			% normalized histogram
			
			subplot(2,2,4);
			
			plot(c.x,Gx,'k-');
			if (length(c.x) < 100)
				hold on;
				plot(c.x,Gx,'ko');
			end
			
			ax = axis;
			axis([v.x(1) v.x(end) ax(3:4)]);
			
			grid on;
			
			axes_scale_bdfun(gca,'y');
			
			%--
			% label axes
			%--
			
			% planes of multiple-plane image
			
			if (flag) 
			
				if (~isempty(inputname(1)))
					N1 = [inputname(1) '(:,:,' num2str(p(1)) ')'];
					xlabel_edit(['Histogram of ' N1]);
				else
					N1 = ['[inputname(1)](:,:,' num2str(p(1)) ')'];
					xlabel_edit(['Histogram of ' N1]);
				end
				
			% separate images
			
			else
			
				if (~isempty(inputname(1)))
					xlabel_edit(['Histogram of ' inputname(1)]);
				else
					xlabel_edit('Histogram of [inputname(1)]');
				end
			
			end
			
			% normalized histogram
			
			subplot(2,2,1);
			
			plot(Gy,c.y,'k-');
			if (length(c.y) < 100)
				hold on;
				plot(Gy,c.y,'ko');
			end
			
			ax = axis;
			axis([ax(1:2) v.y(1) v.y(end)]);
			set(gca,'XDir','reverse');
	% 		set(gca,'YAxisLocation','right');
			
			grid on;
			
			axes_scale_bdfun(gca,'x');
			
			%--
			% label axes
			%--
			
			% planes of multiple-plane image
			
			if (flag) 
			
				if (~isempty(inputname(1)))
					N2 = [inputname(1) '(:,:,' num2str(p(2)) ')'];
					ylabel_edit(['Histogram of ' N2]);
				else
					N2 = ['[inputname(1)](:,:,' num2str(p(2)) ')'];
					ylabel_edit(['Histogram of ' N2]);
				end
				
			% separate images
			
			else
			
				if (~isempty(inputname(2)))
					ylabel_edit(['Histogram of ' inputname(2)]);
				else
					ylabel_edit('Histogram of [inputname(2)]');
				end
			
			end
			
			% PRODUCT HISTOGRAM
				
			%--
			% display according to data type
			%--
			
			subplot(2,2,3);
			
			if (isa(X,'double'))
	
				% display image
				
				image(Gxy,'CDataMapping','scaled','XData',b(1,:),'YData',b(2,:));
				set(gca,'Clim',mxy);
				axis('xy');
				
				% set aspect ratio
				
% 				r = (b.x(2) - b.x(1)) / (b.y(2) - b.y(1));
% 				r = min(r,1/r);
% 				
% 				if (r > 0.33)
% 					axis('image');
% 				end
				
				% add identity
							
			elseif (isa(X,'uint8'))
				
				% display image
				
				image(Gxy,'CDataMapping','scaled','XData',[0 255],'YData',[0 255]);
				set(gca,'Clim',m);
				axis('xy');
				
				% set aspect ratio
				
				axis('image');
									
				% add identity
				
				hold on;
	
				plot([0,255],[0,255],'w:');
								
			end
			
			% set colormap
			
			colormap(hot);
			
			% add quartile contours
			
% 		  	hold on;
% 		 	
% 			[V,q] = hist_2d_level(Gxy);
% 			
% 		 	[tmp,h] = contour(c.x,c.y,median_filter(Gxy/N,se_ball(3)),V);
% 			set(h,'EdgeColor',ones(1,3),'LineStyle','--');
															
			%--
			% label axes
			%--
				
			if (flag)
			
				if (~isempty(inputname(1)))
					title_edit('Product Distribution');
					xlabel_edit([inputname(1) '(:,:,' num2str(p(1)) ')']);
					ylabel_edit([inputname(1) '(:,:,' num2str(p(2)) ')']);
				else
					title_edit('Product Distribution');
					xlabel_edit(['[inputname(1)](:,:,' num2str(p(1)) ')']);
					ylabel_edit(['[inputname(1)](:,:,' num2str(p(2)) ')']);
				end
				
				if (~isempty(inputname(1)))
					N1 = [inputname(1) '(:,:,' num2str(p(1)) ')'];
					N2 = [inputname(1) '(:,:,' num2str(p(2)) ')'];
					T = ['Product Histogram of ' N1 ' and ' N2];
					title_edit(T);
					xlabel_edit(N1);
					ylabel_edit(N2);
				else
					N1 = ['[inputname(1)](:,:,' num2str(p(1)) ')'];
					N2 = ['[inputname(1)](:,:,' num2str(p(2)) ')'];
					T = ['Product Histogram of ' N1 ' and ' N2];
					title_edit(T);
					xlabel_edit(N1);
					ylabel_edit(N2);
				end
				
			% separate images
			
			else
				
				if (~isempty(inputname(1)))
					xlabel_edit(inputname(1));
					N1 = inputname(1);
				else
					xlabel_edit('[inputname(1)]');
					N1 = '[inputname(1)]';
				end
				
				if (~isempty(inputname(2)))
					ylabel_edit(inputname(2));
					N2 = inputname(2);
				else
					ylabel_edit('[inputname(2)]');
					N2 = '[inputname(2)]';
				end

				T = ['Product Histogram of ' N1 ' and ' N2];
				title_edit(T);
				
			end
		
			% titled colorbar
			
% 			colorbar;

			I = hist_mutual(H)
		
	end
	
end


% 				% add identity
% 				
% 				hold on;
% 				
% 				m = min(b.x(1),b.y(1));
% 				M = max(b.x(2),b.y(2));
% 				
% 				plot([m; M],[m; M],'w:');

% 			% titled colorbar
% 						
% 			ax = gca;
% 			
% 			colorbar;
% 			
% 			axes(get(findobj(gcf,'tag','TMW_COLORBAR'),'parent'));
% 			title('Log 10');
% 			
% 			axes(ax);
