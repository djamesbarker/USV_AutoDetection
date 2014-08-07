function stack_to_html(X)

% stack_to_html - display image in browser
% ----------------------------------------
%
%   f = stack_to_html(X,C,opt)
% opt = stack_to_html
%
% Input:
% ------
%  X - image
%  C - colormap
%  opt - various display options
%
% Output:
% -------
%  f - filename

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
% $Date: 2003-07-06 13:36:59-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% get userdata
%--

		data = get(h,'userdata');
		
		%--
		% move to last save directory
		%--
		
		pi = pwd;
				
		if (~isempty(save_path))
			cd(save_path);
		end
		
		%--
		% get path and set filename
		%--
		
		[f,p] = uiputfile( ...
			[fig_name(h) '_f1.' data.stack_menu.p.format], ...
			'Save Stack As:');
		
		% filename is for first frame in stack
			
		%--
		% move to destination directory and update save_path
		%--
		
		cd(p);
		
		save_path(p);
		
		%--
		% get image data and colormap
		%--
		
		% get frame names (to get number of frames)
		
		hi = findobj(h,'tag','IMAGE_STACK'); 
	 	N = getfield(get(hi,'userdata'),'N');
		
		%--
		% create filenames
		%--
		
		for k = 1:length(N)
			F{k} = [fig_name(h) '_f' num2str(k) '.' ...
				data.stack_menu.p.format];
		end
		
		% repeat filenames to handle wrapping
		
		F = {F{end}, F{:}, F{1}};

		%--
		% loop over the frames and use the same code as for save image
		%--
		
		stack_menu(h,'First Frame');
		
		map = get(h,'colormap');	
		
		for k = 1:length(N)
		
			%--
			% get image data
			%--
			
			X = uint8(lut_range(image_crop));
						
			%--
			% write image file
			%--
			
			switch (data.stack_menu.p.format)
			
				case ('jpg')
				
					switch (ndims(X))
					
						case (2)
							imwrite(X,map,F{k + 1}, ...
								'jpeg', ...
								'Quality',data.stack_menu.p.jpeg_quality);
								
						case (3)
							imwrite(X,F{k + 1}, ...
								'jpeg', ...
								'Quality',data.stack_menu.p.jpeg_quality);
								
					end
						
					if (strcmp(computer,'MAC2'))
						filetype(F{k + 1},'JPEG','GKON');
					end
									
				case ('tif')
				
					imwrite(X,map,F{k + 1}, ...
						'tiff', ...
						'Compression',data.stack_menu.p.compression);
						
					if (strcmp(computer,'MAC2'))
						filetype(F{k + 1},'TIFF','GKON');
					end
					
			end
			
			%--		
			% create html depending on hmtl option
			%--
			
			if (data.stack_menu.p.create_html)
			
				[m,n,d] = size(X);
				
				switch (data.stack_menu.p.html_format)
				
					%--
					% plain
					%--
					
					case ('plain')
					
						%--
						% create html string
						%--
						
						S = ['<BODY' ...
							' BGCOLOR=' rgb_to_hex([0 0 0]) ...
							' ALINK=' rgb_to_hex([1 1 0]) ...
							' LINK=' rgb_to_hex([1 1 1]) ...
							' VLINK=' rgb_to_hex([1 1 1]) ...
							' TEXT=' rgb_to_hex([1 1 1]) ...
							' > \n'];
						
						% stack navigation
						
						S = [S '<P ALIGN=CENTER> \n'];
						S = [S '\t' html_anchor('Previous Frame', ...
							file_ext(F{k},'html')) html_spacer(0,12) '\n'];
							
						for j = 2:length(N) + 1
							S = [S '\t' html_anchor(num2str(j - 1), ...
								file_ext(F{j},'html')) html_spacer(0,12) '\n'];
						end
						
						S = [S '\t' html_anchor('Next Frame', ...
							file_ext(F{k + 2},'html')) '\n'];
						S = [S '</P> \n'];
						S = [S '<HR> \n'];
						
						% title
						
						if (~isempty(title_edit))
							S = [S '<P ALIGN=CENTER>' title_edit '</P>\n'];
						end
						
						% image
						
						S = [S '<P ALIGN=CENTER> \n'];
						S = [S '\t<IMG SRC="' F{k + 1} ...
							'"' ' HEIGHT=' num2str(m) ' WIDTH=' num2str(n) '> \n'];
						S = [S '</P> \n'];
						
						% xlabel
						
						if (~isempty(xlabel_edit))
							S = [S '<P ALIGN=CENTER>' xlabel_edit '</P>\n'];
						end
						
						% stack navigation
						
						S = [S '<HR> \n'];
						S = [S '<P ALIGN=CENTER> \n'];
						S = [S '\t' html_anchor('Previous Frame', ...
							file_ext(F{k},'html')) html_spacer(0,12) '\n'];
							
						for j = 2:length(N) + 1
							S = [S '\t' html_anchor(num2str(j - 1), ...
								file_ext(F{j},'html')) html_spacer(0,12) '\n'];
						end
						
						S = [S '\t' html_anchor('Next Frame', ...
							file_ext(F{k + 2},'html')) '\n'];
						S = [S '</P> \n'];
						
						% end of body
						
						S = [S '</BODY>'];
						
						f = file_ext(F{k + 1},'html');
						
						%--
						% write file
						%--
						
						str_to_file(S,f);
						
						if (strcmp(computer,'MAC2'))
							filetype(f,'TEXT','MSIE');
						end
						
					%--
					% imagemap
					%--
					
					case ('imagemap')
					
					%--
					% javascript
					%--
					
					case ('javascript')
				
				end
											
			end
			
			stack_menu(h,'Next Frame')
			
		end
		
		%--
		% view html
		%--
		
		if (data.stack_menu.p.view_html)
			web(['file:///' strrep([p file_ext(F{2},'html')],':','/')]);
		end
		
		% display first frame
			
		%--
		% return to original directory
		%--
		
		cd(pi);
