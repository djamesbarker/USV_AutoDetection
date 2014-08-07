function image_cmenu(h,str,flag)

% image_cmenu - image viewing tools contextual menu
% -------------------------------------------------
%
% image_cmenu(h,str,flag)
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

%--
% get image handle
%--

hi = get_image_handles(h);

if (length(hi) > 1)
	error('There is more than one image in figure.');
end

%--
% set enable flag option
%--

if (nargin == 3)
	
	t = findobj(h,'type','uimenu','label','Image');
	
	if (~isempty(t))
		set(findobj(h,'type','uimenu','label',str),'enable',flag);
	end
	
	return;
	
end

%--
% set str
%--

if (nargin < 2)
	str = 'Initialize';
end

%--
% set handle
%--

if (nargin < 1)
	h = gcf;
end

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
		
		t = get(hi,'uicontextmenu');
		
		if (~isempty(t))
			return;
		end

		%--
		% UserData
		%--
		
		if (~isempty(get(h,'userdata')))
			data = get(h,'userdata');
		end
		
		%--
		% Image
		%--
		
		L = { ...
			'Image', ...
			'Zoom', ...					%  2 -
			'Zoom Range ...', ...		%  3 - 
			'Save Image ...', ...		%  4 - sep
			'Save Image Options', ...	%  5 - sub menu
			'Grid', ... 				%  6 - sep, acc `
			'Grid Options', ... 		%  7 - sub
			'Colormap', ... 			%  8 - sub, sep
			'Colormap Options', ...		%  9 - sub
			'Half Size', ... 			% 10 - sep
			'Normal Size', ... 			% 11 - acc =
			'Double Size', ... 			% 12 - acc D
			'Fill Screen', ... 			% 13 - acc F
			'Rotate Left', ... 			% 14 - sep
			'Rotate Right', ...
			'Flip Horizontal', ...
			'Flip Vertical' ...
		};
		
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{4} = 'on';
		S{6} = 'on';
		S{8} = 'on';
		S{10} = 'on';
		S{14} = 'on';
		
		A = cell(1,n);
		A{6} = 'G';
		A{11} = 'X';
		A{12} = 'D';
% 		A{12} = 'F';
		
		cmenu = uicontextmenu;
		set(hi,'uicontextmenu',cmenu);
		
		data.image_cmenu.h.image = menu_group(cmenu,'image_cmenu',L,S,A);	
		
		%--
		% Save Image Options
		%--
		
		L = { ...
			'Create HTML', ...		%  1 -
			'View HTML' ...			%  2 -
			'JPEG', ...				%  3 - sep
			'JPEG Quality ...', ...	%  4 - 
			'TIFF', ...				%  5 - sep
			'TIFF Compression'		%  6 - sub
		};
		
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{3} = 'on';
		S{5} = 'on';
		
		A = cell(1,n);
		
		data.image_cmenu.h.save_options = ...
			menu_group(data.image_cmenu.h.image(5),'image_cmenu',L,S,A);
			
		%--
		% TIFF Compression
		%--
		
		L = { ...
			'None', ...				%  1 -
			'PackBits' ...			%  2 -
			'CCITT', ...			%  3 - sep
		};
		
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		
		A = cell(1,n);
		
		data.image_cmenu.h.tiff_compression = ...
			menu_group(data.image_cmenu.h.save_options(6),'image_cmenu',L,S,A);
		
		%--
		% Grid Options
		%--
				
		L = { ...
			'Spacing', ...		%  1 -
			'Color' ...			%  2 -
		};
		
		n = length(L);
		S = bin2str(zeros(1,n));
		A = cell(1,n);
		
		data.image_cmenu.h.grid_options = ...
			menu_group(data.image_cmenu.h.image(7),'image_cmenu',L,S,A);
			
		%--
		% Spacing
		%--
	
		L = { ...
			'No Ticks', ...
			'1 x 1', ... % 2 - sep
			'2 x 2', ...
			'4 x 4', ...
			'8 x 8', ...
			'16 x 16', ...
			'32 x 32', ...
			'64 x 64', ...
			'10 x 10', ... % 9 - sep
			'25 x 25', ...
			'50 x 50', ...
			'100 x 100',
		};
		
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		S{9} = 'on';
		
		A = cell(1,n);
		
		data.image_cmenu.h.spacing = ...
			menu_group(data.image_cmenu.h.grid_options(1),'image_cmenu',L,S,A);
			
		%--
		% Color
		%--
		
		L = { ...
			'Black', ...
			'Gray', ...
			'White', ...
			'Red', ...	%  4 - sep
			'Yellow', ...
			'Green' ...
			'Blue',
		};
		
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{4} = 'on';
		
		A = cell(1,n);
		
		data.image_cmenu.h.color = ...
			menu_group(data.image_cmenu.h.grid_options(2),'image_cmenu',L,S,A);
				
		%--
		% Colormap
		%--
		
		L = { ...
			'Grayscale', ...							
			'Real', ... 			%  2 - sep
			'Real Options ...', ... 
			'Bone', ... 			%  4 - sep
			'Copper', ...
			'Hot', ...
			'HSV', ...
			'Jet' ...
		};
			
		n = length(L);
		
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		S{4} = 'on';
		
		A = cell(1,n);
				
		data.image_cmenu.h.colormap = ...
			menu_group(data.image_cmenu.h.image(8),'image_cmenu',L,S,A);
						
		%--
		% Colormap Options
		%--
		
		L = { ...
			'Colorbar', ...		% 1 - acc B
			'Number of Levels', ...		% 2 - sub, sep  'Scaling', ...
			'Brighten', ...		% 3 - sep, acc ]
			'Darken', ...		% 4 - acc [
			'Invert' ...		% 5 - acc I
		};
		
		n = length(L);
	
		S = bin2str(zeros(1,n));
		S{2} = 'on';
		S{3} = 'on';
						
		A = cell(1,n);
		A{1} = 'C';
% 		A{3} = 'L';
% 		A{4} = 'D';
		A{5} = 'R';
		
		data.image_cmenu.h.colormap_options = ...
			menu_group(data.image_cmenu.h.image(9),'image_cmenu',L,S,A);
					
		%--
		% Number of Levels
		%--
		
		L = { ...
			'256', ...
			'2', ...		%  2 - sep
			'4', ...
			'8', ...
			'16', ...	
			'32', ...
			'64', ...				
			'128', ... 			
		};
		
		n = length(L);
	
		S = bin2str(zeros(1,n));
		S{2} = 'on';
						
		A = cell(1,n);
		
		data.image_cmenu.h.levels = ...
			menu_group(data.image_cmenu.h.colormap_options(2), ...
			'image_cmenu',L,S,A);
					
		%--
		% Other initializations
		%--
			
		%--
		% jpeg quality
		%--
		
		data.image_cmenu.p.jpeg_quality = 100;
		
		%--
		% html option
		%--
		
		data.image_cmenu.p.view_html = 0;
				
		%--
		% zoom state
		%--
		
		if (strcmp(get(h,'WindowButtonDownFcn'),'zoom down'))
			set(data.image_cmenu.h.image(2),'checked','on');
		else
			set(data.image_cmenu.h.image(2),'checked','off');
		end
	
		%--
		% grid state
		%--
		
		if (strcmp(get(gca,'XGrid'),'on') & strcmp(get(gca,'YGrid'),'on'))
			set(data.image_cmenu.h.image(3),'checked','on');
			data.image_cmenu.p.flag_grid = 1;
		else
			set(data.image_cmenu.h.image(3),'checked','off');
			data.image_cmenu.p.flag_grid = 0;
		end
		
		%--	
		% colorbar state
		%--
		
		data.image_cmenu.h.colorbar = findobj(gcf,'tag','TMW_COLORBAR');
			
		if (isempty(data.image_cmenu.h.colorbar))
			data.image_cmenu.p.flag_colorbar = 0;
		else
			data.image_cmenu.p.flag_colorbar = 1;
		end
	
		%--
		% real colors
		%--
		
		% negative green, positive red
		
		data.image_cmenu.p.real_neg = '[0.1, 0.5, 0.1]';
		data.image_cmenu.p.real_zero = '[0.95, 0.95, 0.95]';
		data.image_cmenu.p.real_pos = '[0.5, 0.1, 0.1]';
		
		data.image_cmenu.p.real_colors = ...
			[eval(data.image_cmenu.p.real_neg); ...
			eval(data.image_cmenu.p.real_zero); ...
			eval(data.image_cmenu.p.real_pos)];
			
		%--	
		% initial colormap and levels
		%--
		
		data.image_cmenu.p.levels = 256;
		data.image_cmenu.p.colormap = 'Grayscale';
	
		%--
		% scale
		%--
		
		data.image_cmenu.p.scale = '';
		
		%--
		% Save userdata
		%--
		
		set(h,'userdata',data);
				
		%--
		% set default options
		%--
		
		% display options
		
		image_cmenu(h,'Gray');
		image_cmenu(h,'No Ticks');
		
		% save image options
		
		image_cmenu(h,'Create HTML');
		image_cmenu(h,'View HTML');
		image_cmenu(h,'JPEG'); 
		image_cmenu(h,'PackBits');
			
	%--
	% Save Image ...
	%--
	
	case ('Save Image ...')
	
		% get userdata
		
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
			[fig_name(h) '.' data.image_cmenu.p.format], ...
			'Save Image As:');
		
		%--
		% move to destination directory and update save_path
		%--
		
		cd(p);
		
		save_path(p);
		
		%--
		% get image data and colormap
		%--
		
		X = uint8(lut_range(image_crop));
		map = get(h,'colormap');		
		
		%--
		% write image file
		%--
		
		switch (data.image_cmenu.p.format)
		
			case ('jpg')
			
				switch (ndims(X))
				
					case (2)
						imwrite(X,map,f, ...
							'jpeg', ...
							'Quality',data.image_cmenu.p.jpeg_quality);
							
					case (3)
						imwrite(X,f, ...
							'jpeg', ...
							'Quality',data.image_cmenu.p.jpeg_quality);
							
				end
					
				if (strcmp(computer,'MAC2'))
					filetype(f,'JPEG','GKON');
				end
								
			case ('tif')
			
				imwrite(X,map,f, ...
					'tiff', ...
					'Compression',data.image_cmenu.p.compression);
					
				if (strcmp(computer,'MAC2'))
					filetype(f,'TIFF','GKON');
				end
				
		end
		
		%--		
		% create and view html
		%--
		
		if (data.image_cmenu.p.create_html)
		
			[m,n,d] = size(X);
			
			% set document colors
			
			S = ['<BODY' ...
				' BGCOLOR=' rgb_to_hex([0 0 0]) ...
				' ALINK=' rgb_to_hex([1 1 0]) ...
				' LINK=' rgb_to_hex([1 1 1]) ...
				' VLINK=' rgb_to_hex([1 1 1]) ...
				' TEXT=' rgb_to_hex([1 1 1]) ...
				' > \n'];
			
			% axes title
			
			if (~isempty(title_edit))
				S = [S '<P ALIGN=CENTER>' title_edit '</P>\n'];
			end
			
			% image at full size
			
			S = [S '<P ALIGN=CENTER> \n'];
			S = [S '<IMG SRC="' f ...
				'"' ' HEIGHT=' num2str(m) ' WIDTH=' num2str(n) '> \n'];
			S = [S '</P> \n'];
			
			% xlabel
			
			if (~isempty(xlabel_edit))
				S = [S '<P ALIGN=CENTER>' xlabel_edit '</P>\n'];
			end
			
			S = [S '</BODY>'];
			
			% create html file
			
			f = file_ext(f,'html');
			
			str_to_file(S,f);
			
			if (strcmp(computer,'MAC2'))
				filetype(f,'TEXT','MSIE');
			end
				
			% display image in browser
			
			if (data.image_cmenu.p.view_html)
				web(['file:///' strrep([p f],':','/')]);
			end
			
		end
				
		% return to original directory
		
		cd(pi);
				
	%--
	% Create HTML
	%--
	
	case ('Create HTML')
	
		% get menu data
		
		data = get(h,'userdata');
						
		% toggle option and check
		
		if (isfield(data.image_cmenu.p,'create_html'))
			data.image_cmenu.p.create_html = ~data.image_cmenu.p.create_html;
		else
			data.image_cmenu.p.create_html = 1;
		end
		
		if (data.image_cmenu.p.create_html)
			set(data.image_cmenu.h.save_options(1),'check','on');
		else
			set(data.image_cmenu.h.save_options(1),'check','off');
		end
		
		% update menu data
		
		set(h,'userdata',data);
		
		% update view html
		
		if (data.image_cmenu.p.view_html & ~data.image_cmenu.p.create_html)
			image_cmenu(h,'View HTML');
		end
		
	%--
	% View HTML
	%--
	
	case ('View HTML')
	
		% get menu data
		
		data = get(h,'userdata');
		
		% toggle option and check
		
		if (isfield(data.image_cmenu.p,'view_html'))
			data.image_cmenu.p.view_html = ~data.image_cmenu.p.view_html;
		else
			data.image_cmenu.p.view_html = 1;
		end
		
		if (data.image_cmenu.p.view_html)
			set(data.image_cmenu.h.save_options(2),'check','on');
		else
			set(data.image_cmenu.h.save_options(2),'check','off');
		end
		
		% update menu data
		
		set(h,'userdata',data);
		
		% update create html
		
		if (data.image_cmenu.p.view_html & ~data.image_cmenu.p.create_html)
			image_cmenu(h,'Create HTML');
		end
		
	%--
	% JPEG
	%--
	
	case ('JPEG')
	
		% get menu data
		
		data = get(h,'userdata');
		
		% set option and check
		
		data.image_cmenu.p.format = 'jpg';
		
		set(data.image_cmenu.h.save_options(5),'check','off');
		set(findobj(data.image_cmenu.h.save_options,'label',str),'check','on');
		
		% update menu data
		
		set(h,'userdata',data);
	
	%--
	% JPEG Quality ...
	%--
	
	case ('JPEG Quality ...')
	
		% get userdata
		
		data = get(h,'userdata');
		
		% setup dialog
		
		ans = input_dialog( ...
			{'JPEG Quality:'}, ...
			'JPEG Quality ...', ...
			[1,30], ...
			{num2str(data.image_cmenu.p.jpeg_quality)});
		
		% update userdata
		
		if (~isempty(ans))
			data.image_cmenu.p.jpeg_quality = str2num(ans{1});
		end
		
		set(h,'userdata',data);	
	
	%--
	% TIFF
	%--
	
	case ('TIFF')
	
		% get menu data
		
		data = get(h,'userdata');
		
		% set option and check
		
		data.image_cmenu.p.format = 'tif';
		
		set(data.image_cmenu.h.save_options(3),'check','off');
		set(findobj(data.image_cmenu.h.save_options,'label',str),'check','on');
		
		% update menu data
		
		set(h,'userdata',data);
	
	%--
	% TIFF Compression
	%--
	
	%--
	% None
	%--
	
	case ('None')
	
		% get menu data
		
		data = get(h,'userdata');
		
		% set option and check
		
		data.image_cmenu.p.compression = 'none';
		
		set(data.image_cmenu.h.tiff_compression,'check','off');
		set(findobj(data.image_cmenu.h.tiff_compression,'label',str),'check','on');
		
		% update menu data
		
		set(h,'userdata',data);
		
	%--
	% PackBits
	%--
	
	case ('PackBits')
	
		% get menu data
		
		data = get(h,'userdata');
		
		% set option and check
		
		data.image_cmenu.p.compression = 'packbits';
		
		set(data.image_cmenu.h.tiff_compression,'check','off');
		set(findobj(data.image_cmenu.h.tiff_compression,'label',str),'check','on');
		
		% update menu data
		
		set(h,'userdata',data);
		
	%--
	% CCITT
	%--
	
	case ('CCITT')
	
		% get menu data
		
		data = get(h,'userdata');
		
		% set option and check
		
		data.image_cmenu.p.compression = 'ccitt';
		
		set(data.image_cmenu.h.tiff_compression,'check','off');
		set(findobj(data.image_cmenu.h.tiff_compression,'label',str),'check','on');
		
		% update menu data
		
		set(h,'userdata',data);
	
	%--
	% Zoom
	%--
	
	case ('Zoom')

		data = get(h,'userdata');
	
		zoom;
		
		if (strcmp(get(h,'WindowButtonDownFcn'),'zoom(gcbf,''down'')'))
			set(data.image_cmenu.h.image(2),'checked','on');
		else
			set(data.image_cmenu.h.image(2),'checked','off');
		end
		
	%--
	% Zoom Range ...
	%--
	
	case ('Zoom Range ...')

		% setup dialog
		
		xl = get(gca,'XLim');
		xl = [num2str(round(xl(1))) ':' num2str(round(xl(2)))];
		yl = get(gca,'YLim');
		yl = [num2str(round(yl(1))) ':' num2str(round(yl(2)))];
							
		ans = input_dialog( ...
			{'Row Range:','Column Range:'}, ...
			'Zoom Range ...', ...
			[1,30], ...
			{yl,xl});
		
		% get answers
		
		if (~isempty(ans))

			[r1,r2] = strtok(ans{1},':,');
			r1 = str2num(r1);
			r2 = str2num(r2(2:end));
			
			[c1,c2] = strtok(ans{2},':,');
			c1 = str2num(c1);
			c2 = str2num(c2(2:end));
			
			set(gca,'XLim',[c1,c2],'YLim',[r1,r2]);
		
		end
	
	%--
	% Grid
	%--
	
	case ('Grid')
		
		data = get(h,'userdata');
		
		grid;
		
		if (strcmp(get(gca,'XGrid'),'on') & strcmp(get(gca,'YGrid'),'on'))
			set(data.image_cmenu.h.image(6),'checked','on');
			data.image_cmenu.p.flag_grid = 1;
		else
			set(data.image_cmenu.h.image(6),'checked','off');
			data.image_cmenu.p.flag_grid = 0;
		end
		
		set(h,'userdata',data);
	
	%--
	% Grid Options (no callback)
	%--
	
	case ('No Ticks')
	
		data = get(h,'userdata');
		
		image_grid(0);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
	
	case ('1 x 1')

		data = get(h,'userdata');

		image_grid(-1);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
		
	case ('2 x 2')

		data = get(h,'userdata');

		image_grid(-2);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
		
	case ('4 x 4')

		data = get(h,'userdata');

		image_grid(-4);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
		
	case ('8 x 8')

		data = get(h,'userdata');

		image_grid(-8);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
		
	case ('16 x 16')
		
		data = get(h,'userdata');
		
		image_grid(-16);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
	
	case ('32 x 32')

		data = get(h,'userdata');

		image_grid(-32);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
		
	case ('64 x 64')
	
		data = get(h,'userdata');
	
		image_grid(-64);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
		
	case ('10 x 10')
	
		data = get(h,'userdata');
	
		image_grid(-10);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
	
	case ('25 x 25')
	
		data = get(h,'userdata');
	
		image_grid(-25);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
	
	case ('50 x 50')

		data = get(h,'userdata');

		image_grid(-50);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
		
	case ('100 x 100')

		data = get(h,'userdata');
	
		image_grid(-100);
		
		set(data.image_cmenu.h.spacing,'check','off');
		set(findobj(data.image_cmenu.h.spacing,'label',str),'check','on');
	
	case ('Black')
		
		data = get(h,'userdata');
		
		set(gca,'XColor',[0 0 0],'YColor',[0 0 0]);
		
		set(data.image_cmenu.h.color,'check','off');
		set(findobj(data.image_cmenu.h.color,'label',str),'check','on');
		
	case ('Gray')
		
		data = get(h,'userdata');
		
		set(gca,'XColor',0.5*[1 1 1],'YColor',0.5*[1 1 1]);
		
		set(data.image_cmenu.h.color,'check','off');
		set(findobj(data.image_cmenu.h.color,'label',str),'check','on');
			
	case ('White')
		
		data = get(h,'userdata');
		
		set(gca,'XColor',[1 1 1],'YColor',[1 1 1]);
		
		set(data.image_cmenu.h.color,'check','off');
		set(findobj(data.image_cmenu.h.color,'label',str),'check','on');
			
	case ('Red')
		
		data = get(h,'userdata');
		
		set(gca,'XColor',0.75*[1 0 0],'YColor',0.75*[1 0 0]);
		
		set(data.image_cmenu.h.color,'check','off');
		set(findobj(data.image_cmenu.h.color,'label',str),'check','on');
	
	case ('Yellow')
	
		data = get(h,'userdata');
	
		set(gca,'XColor',0.75*[1 1 0],'YColor',0.75*[1 1 0]);
		
		set(data.image_cmenu.h.color,'check','off');
		set(findobj(data.image_cmenu.h.color,'label',str),'check','on');
	
	case ('Green')

		data = get(h,'userdata');
				
		set(gca,'XColor',0.75*[0 1 0],'YColor',0.75*[0 1 0]);
		
		set(data.image_cmenu.h.color,'check','off');
		set(findobj(data.image_cmenu.h.color,'label',str),'check','on');
	
	case ('Blue')

		data = get(h,'userdata');
		
		set(gca,'XColor',0.75*[0 0 1],'YColor',0.75*[0 0 1]);
		
		set(data.image_cmenu.h.color,'check','off');
		set(findobj(data.image_cmenu.h.color,'label',str),'check','on');
			
	%--
	% Colorbar
	%--
	
	case ('Colorbar')

		data = get(h,'userdata');
		
		if (~data.image_cmenu.p.flag_colorbar)
		
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
			
			data.image_cmenu.h.colorbar = g;
			data.image_cmenu.p.flag_colorbar = 1;
			set(h,'userdata',data);
			
			image_cmenu(h,data.image_cmenu.p.scale);
			
			set(data.image_cmenu.h.colormap_options(1),'check','on');
							
		else
				
			delete(data.image_cmenu.h.colorbar);
			data.image_cmenu.p.flag_colorbar = 0;
			set(h,'userdata',data);
			
			image_cmenu(h,data.image_cmenu.p.scale);
			
			set(data.image_cmenu.h.colormap_options(1),'check','off');
							
		end
			
	%--
	% Colormap
	%--
	
	case ('Grayscale')

		data = get(h,'userdata');
		
		colormap(gray(data.image_cmenu.p.levels));
		
		data.image_cmenu.p.colormap = 'Grayscale';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.colormap,'check','off');
		set(findobj(data.image_cmenu.h.colormap,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
						
	case ('Real')

		data = get(h,'userdata');
	
		colormap(cmap_real(data.image_cmenu.p.levels,data.image_cmenu.p.real_colors));
		
		data.image_cmenu.p.colormap = 'Real';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.colormap,'check','off');
		set(findobj(data.image_cmenu.h.colormap,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('Real Options ...')

		% get userdata
		
		data = get(h,'userdata');
	
		% setup dialog
		
		p = data.image_cmenu.p;
		
		ans = input_dialog( ...
			{'Negative Color:', 'Neutral Color:', 'Positive Color:'}, ...
			'Real Options ...', ...
			[1,30], ...
			{p.real_neg, p.real_zero, p.real_pos});
		
		% get answers, update userdata and display
		
		if (~isempty(ans))
		
			data.image_cmenu.p.real_neg = ans{1};
			data.image_cmenu.p.real_zero = ans{2};
			data.image_cmenu.p.real_pos = ans{3};
			data.image_cmenu.p.real_colors = ...
				[eval(ans{1}); eval(ans{2}); eval(ans{3})];
				
			set(h,'userdata',data);
			
			if (strcmp(get(data.image_cmenu.h.colormap(2),'check'),'on'))
				image_cmenu(h,'Real');
			end
			
		end
	
	case ('Bone')

		data = get(h,'userdata');
	
		colormap(bone(data.image_cmenu.p.levels));
		
		data.image_cmenu.p.colormap = 'Bone';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.colormap,'check','off');
		set(findobj(data.image_cmenu.h.colormap,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('Copper')

		data = get(h,'userdata');
	
		colormap(copper(data.image_cmenu.p.levels));
		
		data.image_cmenu.p.colormap = 'Copper';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.colormap,'check','off');
		set(findobj(data.image_cmenu.h.colormap,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
	
	case ('Hot')

		data = get(h,'userdata');
	
		colormap(hot(data.image_cmenu.p.levels));
		
		data.image_cmenu.p.colormap = 'Hot';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.colormap,'check','off');
		set(findobj(data.image_cmenu.h.colormap,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('HSV')

		data = get(h,'userdata');
		
		colormap(hsv(data.image_cmenu.p.levels));
		
		data.image_cmenu.p.colormap = 'HSV';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.colormap,'check','off');
		set(findobj(data.image_cmenu.h.colormap,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('Jet')

		data = get(h,'userdata');
	
		colormap(jet(data.image_cmenu.p.levels));
		data.image_cmenu.p.colormap = 'Jet';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.colormap,'check','off');
		set(findobj(data.image_cmenu.h.colormap,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
			
	%--
	% Levels (no callback)
	%--
	
	case ('256')

		data = get(h,'userdata');
		
		data.image_cmenu.p.levels = 256;
		set(h,'userdata',data);
		
		image_cmenu(h,data.image_cmenu.p.colormap);
		
		set(data.image_cmenu.h.levels,'check','off');
		set(findobj(data.image_cmenu.h.levels,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('2')

		data = get(h,'userdata');
	
		data.image_cmenu.p.levels = 2;
		set(h,'userdata',data);
		
		image_cmenu(h,data.image_cmenu.p.colormap);
		
		set(data.image_cmenu.h.levels,'check','off');
		set(findobj(data.image_cmenu.h.levels,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			colorbar;
		end
		
	case ('4')

		data = get(h,'userdata');
		
		data.image_cmenu.p.levels = 4;
		set(h,'userdata',data);
		
		image_cmenu(h,data.image_cmenu.p.colormap);
		
		set(data.image_cmenu.h.levels,'check','off');
		set(findobj(data.image_cmenu.h.levels,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('8')

		data = get(h,'userdata');
	
		data.image_cmenu.p.levels = 8;
		set(h,'userdata',data);
		
		image_cmenu(h,data.image_cmenu.p.colormap);
		
		set(data.image_cmenu.h.levels,'check','off');
		set(findobj(data.image_cmenu.h.levels,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('16')

		data = get(h,'userdata');
	
		data.image_cmenu.p.levels = 16;
		set(h,'userdata',data);
		
		image_cmenu(h,data.image_cmenu.p.colormap);
		
		set(data.image_cmenu.h.levels,'check','off');
		set(findobj(data.image_cmenu.h.levels,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('32')

		data = get(h,'userdata');
	
		data.image_cmenu.p.levels = 32;
		set(h,'userdata',data);
		
		image_cmenu(h,data.image_cmenu.p.colormap);
		
		set(data.image_cmenu.h.levels,'check','off');
		set(findobj(data.image_cmenu.h.levels,'label',str),'check','on');
	
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('64')

		data = get(h,'userdata');
		
		data.image_cmenu.p.levels = 64;
		set(h,'userdata',data);
		
		image_cmenu(h,data.image_cmenu.p.colormap);
		
		set(data.image_cmenu.h.levels,'check','off');
		set(findobj(data.image_cmenu.h.levels,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
	case ('128')

		data = get(h,'userdata');
		
		data.image_cmenu.p.levels = 128;
		set(h,'userdata',data);
		
		image_cmenu(h,data.image_cmenu.p.colormap);
		
		set(data.image_cmenu.h.levels,'check','off');
		set(findobj(data.image_cmenu.h.levels,'label',str),'check','on');
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
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

		data = get(h,'userdata');
		
		colormap(flipud(get(h,'colormap')));
		
		if (data.image_cmenu.p.flag_colorbar)
			g = colorbar;
			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
	
	%--
	% Half Size
	%--
	
	case ('Half Size')

		data = get(h,'userdata');
		
		s = size(get_image_data(h));
		s = s(1:2);
		truesize(h,0.5*s);
		
		data.image_cmenu.p.scale = 'Half Size';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.image(10:13),'check','off');
		set(findobj(data.image_cmenu.h.image,'label',str),'check','on');
	
	%--
	% Normal Size
	%--
	
	case ('Normal Size')

		data = get(h,'userdata');
		
		s = size(get_image_data(h));
		s = s(1:2);
		truesize(h,s);
		
		data.image_cmenu.p.scale = 'Normal Size';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.image(10:13),'check','off');
		set(findobj(data.image_cmenu.h.image,'label',str),'check','on');
		
	%--
	% Double Size
	%--
	
	case ('Double Size')

		data = get(h,'userdata');
		
		s = size(get_image_data(h));
		s = s(1:2);
		truesize(h,2*s);
		
		data.image_cmenu.p.scale = 'Double Size';
		set(h,'userdata',data);
		
		set(data.image_cmenu.h.image(10:13),'check','off');
		set(findobj(data.image_cmenu.h.image,'label',str),'check','on');
	
	%--
	% Fill Screen
	%--
	
	case ('Fill Screen')

		data = get(h,'userdata');
		
% 		s = size(get_image_data(h));
% 		s = s(1:2);
		truesize_max(h);
		
		data.image_cmenu.p.scale = 'Fill Screen';
		set(h,'userdata',data);
	
		set(data.image_cmenu.h.image(10:13),'check','off');
		set(findobj(data.image_cmenu.h.image,'label',str),'check','on');
		
	%--
	% Rotate Left
	%--
	
	case ('Rotate Left')

		data = get(h,'userdata');
		
		[X,g] = get_image_data(h);
		
		set(gca,axes_transpose(gca));			
		set(g,'CData',image_rot90(X,1));
		
		image_cmenu(h,data.image_cmenu.p.scale);
					
	%--
	% Rotate Right
	%--
	
	case ('Rotate Right')

		data = get(h,'userdata');
		
		[X,g] = get_image_data(h);
		
		set(gca,axes_transpose(gca));
		set(g,'CData',image_rot90(X,-1));
		
		image_cmenu(h,data.image_cmenu.p.scale);
	
	%--
	% Flip Horizontal
	%--
	
	case ('Flip Horizontal')

		data = get(h,'userdata');
		
		[X,g] = get_image_data(h);
		
		set(g,'CData',image_flip_hor(X));
		
		if (data.image_cmenu.p.flag_grid)
			grid;
			grid;
		end
			
	%--
	% Flip Vertical
	%--
	
	case ('Flip Vertical')

		data = get(h,'userdata');
		
		[X,g] = get_image_data(h);
		
		set(g,'CData',image_flip_ver(X));
		
		if (data.image_cmenu.p.flag_grid)
			grid;
			grid;
		end
	
end

	
	
	
	
