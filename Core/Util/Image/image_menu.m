function image_menu(h,str,flag)

% image_menu - image viewing tools menu
% -------------------------------------
%
% image_menu(h,str,flag)
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
% $Revision: 1.0 $
% $Date: 2003-07-06 13:36:54-04 $
%--------------------------------

%--
% enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Image'))
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
			image_menu(h,str{k}); 
		catch
			disp(' '); 
			warning(['Unable to execute command ''' str{k} '''.']);
			disp(' ');
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

[COLOR,COLOR_SEP] = color_to_rgb;

[PDF,PDF_SEP] = prob_to_fun;

[COLORMAP,COLORMAP_SEP] = colormap_to_fun;

[LINESTYLE,LINESTYLE_SEP] = linestyle_to_str('','strict');

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
	
	if (get_menu(h,'Image'))
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
		'Image', ...
		'Zoom', ...					
		'Zoom Range ...', ...		
		'Save Image ...', ...		
		'Save Image Options', ...
		'Contour', ... 				
		'Contour Options' ... 
		'Grid', ... 				
		'Grid Options', ... 		
		'Colormap', ... 			
		'Colormap Options', ...		
		'Histogram', ...
		'Histogram Options', ...
		'Half Size', ... 		
		'Normal Size', ... 			
		'Double Size', ... 		
		'Fill Screen', ... 			
		'Rotate Left', ... 			
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
	S{12} = 'on';
	S{14} = 'on';
	S{18} = 'on';
	
	A = cell(1,n);
% 	A{2} = 'Z';
	A{12} = 'H';
% 	A{14} = 'X';
% 	A{15} = 'D';
	
	data.image_menu.h.image = menu_group(h,'image_menu',L,S,A);	
	
	%--
	% Save Image Options
	%--
	
	L = { ...
		'Create HTML', ...	
		'View HTML', ...	
		'JPEG', ...			
		'JPEG Quality', ...
		'TIFF', ...	
		'TIFF Tags ...', ...
		'TIFF Compression', ...
		'PNG', ...
		'PNG Tags ...', ...
		'PNG BitDepth' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{5} = 'on';
	S{8} = 'on';
	
	A = cell(1,n);
	
	data.image_menu.h.save_options = ...
		menu_group(get_menu(h,'Save Image Options'),'image_menu',L,S,A);
	
	%--
	% Save Image Options: JPEG Quality
	%--
	
	L = { ...
		'100 (Best)', ...		
		'90  (Very High)', ...	
		'75  (High)', ...
		'50  (Medium)', ...
		'25  (Low)', ...
		'Other JPEG Quality ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{end} = 'on';
	
	A = cell(1,n);
	
	data.image_menu.h.jpeg_quality = ...
		menu_group(get_menu(h,'JPEG Quality'),'image_menu',L,S,A);
	
	%--
	% Save Image Options: TIFF Compression
	%--
	
	L = { ...
		'None', ...				%  1 -
		'PackBits', ...			%  2 -
		'CCITT (Binary)', ...			%  3 - sep
		'Fax3 (Binary)', ...
		'Fax4 (Binary)' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	
	A = cell(1,n);
	
	data.image_menu.h.tiff_compression = ...
		menu_group(get_menu(h,'TIFF Compression'),'image_menu',L,S,A);
	
	%--
	% Save Image Options: PNG BitDepth
	%--
	
	L = { ...
		'1 Bit', ...		
		'2 Bits', ...	
		'4 Bits', ...
		'8 Bits', ...
		'16 Bits' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
	
	A = cell(1,n);
	
	data.image_menu.h.png_bitdepth = ...
		menu_group(get_menu(h,'PNG BitDepth'),'image_menu',L,S,A);
	
	%--
	% Contour Options
	%--
	
	L = { ...
		'Values', ...
		'Color', ...
		'Line Style', ...
		'Line Width', ...
		'Labels' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
		
	data.image_menu.h.contour_options = ...
		menu_group(get_menu(h,'Contour Options'),'image_menu',L,S);
	
	%--
	% Contour Options: Values
	%--
	
	L = { ...
		'Auto', ...
		'Mean', ...
		'Median', ...
		'Quartiles', ...
		'Other Values ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
		
	data.image_menu.h.contour_value = ...
		menu_group(get_menu(h,'Values'),'image_menu',L,S);
	
	
	%--
	% Contour Options: Color
	%--
	
	data.image_menu.h.contour_color = ...
		menu_group(get_menu(data.image_menu.h.contour_options,'Color'),'image_menu', ...
		COLOR,COLOR_SEP ...
	);
	
	%--
	% Contour Options: Line Style
	%--
	
	data.image_menu.h.contour_linestyle = ...
		menu_group(get_menu(data.image_menu.h.contour_options,'Line Style'),'image_menu', ...
		LINESTYLE,LINESTYLE_SEP ...
	);	
	
	%--
	% Contour Options: Line Width
	%--
	
	L = {'1 pt','2 pt','3 pt','4 pt'};
	
	data.image_menu.h.contour_linewidth =  ...
		menu_group(get_menu(data.image_menu.h.contour_options,'Line Width'),'image_menu',L);
	
	%--
	% Grid Options
	%--
			
	L = { ...
		'Color', ...		
		'Spacing' ...
	};
	
	data.image_menu.h.grid_options = ...
		menu_group(get_menu(h,'Grid Options'),'image_menu',L);
		
	%--
	% Grid Options: Color
	%--
	
	data.image_menu.h.color = ...
		menu_group(get_menu(h,'Color'),'image_menu',COLOR,COLOR_SEP);
	
	%--
	% Grid Options: Spacing
	%--

	L = { ...
		'No Ticks', ...
		'1 x 1', ...
		'2 x 2', ...
		'4 x 4', ...
		'8 x 8', ...
		'16 x 16', ...
		'32 x 32', ...
		'64 x 64', ...
		'128 x 128', ...
		'Other Grid Spacing ...' ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';

	data.image_menu.h.spacing = ...
		menu_group(get_menu(h,'Spacing'),'image_menu',L,S);
			
	%--
	% Colormap
	%--

	data.image_menu.h.colormap = ...
		menu_group(get_menu(h,'Colormap'),'image_menu',COLORMAP,COLORMAP_SEP);
					
	%--
	% Colormap Options
	%--
	
	L = { ...
		'Colorbar', ...	
		'Number of Levels', ...		
		'Brighten', ...	
		'Darken', ...
		'Invert' ...
	};
	
	n = length(L);

	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{3} = 'on';

	data.image_menu.h.colormap_options = ...
		menu_group(get_menu(h,'Colormap Options'),'image_menu',L,S);
				
	%--
	% Colormap Options: Number of Levels
	%--
	
	L = { ...
		'256', ...
		'2', ...
		'4', ...
		'8', ...
		'16', ...	
		'32', ...
		'64', ...				
		'128', ... 		
		'Other Number of Levels ...' ...
	};
	
	n = length(L);

	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{end} = 'on';
					
	A = cell(1,n);
	
	data.image_menu.h.levels = ...
		menu_group(get_menu(h,'Number of Levels'),'image_menu',L,S,A);
	
	%--
	% Histogram Options
	%--
	
	L = { ...
		'Number of Bins', ...
		'Fit Model', ...
		'Model' ...	
	};
	
	n = length(L);

	S = bin2str(zeros(1,n));
	S{2} = 'on';

	data.image_menu.h.hist_options = ...
		menu_group(get_menu(h,'Histogram Options'),'image_menu',L,S);
	
	%--
	% Histogram Options: Number of Bins
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

	data.image_menu.h.bins = ...
		menu_group(get_menu(h,'Number of Bins'),'image_menu',L,S);
	
	%--
	% Histogram Options: Model
	%--
		
	data.image_menu.h.models = ...
		menu_group(get_menu(h,'Model'),'image_menu',PDF,PDF_SEP);
	
	%--
	% Parameter Initializations
	%--
		
	%--
	% Image Save Options Parameters
	%--
	
	% jpeg parameters
	
	data.browser.jpeg_quality = 100;
	
	% png parameters
	
	data.browser.png_bitdepth = 8;
	
	data.browser.png_tags.author = 'Harold Figueroa';
	data.browser.png_tags.copyright = 'Harold Figueroa';
	data.browser.png_tags.software = 'Matlab';
	data.browser.png_tags.comments = 'Put comments here.';
	data.browser.png_tags.description = 'Put description here.';
	
	% tiff parameters
	
	data.browser.tiff_description = 'Put description here.';
	
	%--
	% HTML Options Parameters
	%--
	
	data.browser.view_html = 0;
			
	%--
	% set menu zoom state
	%--
	
	if (strcmp(get(h,'WindowButtonDownFcn'),'zoom down'))
		set(data.image_menu.h.image(2),'checked','on');
	else
		set(data.image_menu.h.image(2),'checked','off');
	end

	%--
	% set grid and menu grid state
	%--
	
	if (strcmp(get(gca,'XGrid'),'on') & strcmp(get(gca,'YGrid'),'on'))
		set(data.image_menu.h.image(3),'checked','on');
		data.browser.flag_grid = 1;
	else
		set(data.image_menu.h.image(3),'checked','off');
		data.browser.flag_grid = 0;
	end
	
	%--	
	% colorbar state
	%--
	
	data.image_menu.h.colorbar = findobj(gcf,'tag','TMW_COLORBAR');
		
	if (isempty(data.image_menu.h.colorbar))
		data.browser.flag_colorbar = 0;
	else
		data.browser.flag_colorbar = 1;
	end
		
	%--	
	% initial colormap and levels
	%--
	
	data.browser.levels = 256;
	data.browser.colormap = 'Grayscale';

	%--
	% scale
	%--
	
	data.browser.scale = '';
	
	%--
	% histogram and model fit options
	%--
	
	data.browser.bins = 256;
	set(get_menu(data.image_menu.h.bins,'256'),'check','on'); 
	
	data.browser.fit_model = 1;
	set(get_menu(h,'Fit Model'),'check','on'); 
	
	data.browser.model = 'Generalized Gaussian';
	set(get_menu(h,'Generalized Gaussian'),'check','on');
	
	%--
	% contour options
	%--
	
	tmp.on = 0;
	tmp.values = 0.5;
	tmp.label = 0;
	tmp.color = color_to_rgb('Green');
	tmp.linewidth = 2;
	tmp.linestyle = '-';
	
	data.browser.contour = tmp;
	
	%--
	% save userdata
	%--
	
	set(h,'userdata',data);
			
	%--
	% set default options
	%--
	
	% display options
	
	image_menu(h,'Light Gray');
	image_menu(h,'No Ticks');
	
	% save image options
	
	image_menu(h,'Create HTML');
	image_menu(h,'View HTML');
	
	image_menu(h,'JPEG'); 
	
	image_menu(h,'PackBits');
	
	image_menu(h,'8 Bits');
		
%--
% Save Image ...
%--

case ('Save Image ...')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% move last save directory
	%--
	
	pi = pwd;
			
	if (~isempty(save_path))
		cd(save_path);
	end
	
	%--
	% get path and set filename
	%--
	
	[f,p] = uiputfile( ...
		[fig_name(h) '.' data.browser.format], ...
		'Save Image As:');
	
	if (~f)
		return;
	end
	
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
	
	switch (data.browser.format)
	
	case ('jpg')
	
		switch (ndims(X))
		case (2)
			imwrite(X,map,f, ...
				'jpeg', ...
				'Quality',data.browser.jpeg_quality);
		case (3)
			imwrite(X,f, ...
				'jpeg', ...
				'Quality',data.browser.jpeg_quality);
		end

	case ('png')
		
		tags = data.browser.png_tags;
		
		switch (ndims(X))
		case (2)
			imwrite(X,map,f,'png', ...
				'Author',tags.author, ...
				'Description',tags.description, ...
				'Copyright',tags.copyright, ...
				'Comments',tags.comments ...
			);
		case (3)
			imwrite(X,f,'png', ...
				'Author',tags.author, ...
				'Description',tags.description, ...
				'Copyright',tags.copyright, ...
				'Comments',tags.comments ...
			);
		end
		
	case ('tif')
	
		imwrite(X,map,f, ...
			'tiff', ...
			'Compression',data.browser.compression);
			
	end
	
	%--		
	% create and view html
	%--
	
	if (data.browser.create_html)
	
		[m,n,d] = size(X);
		
		%--
		% set document colors
		%--
		
		S = ['<BODY' ...
			' BGCOLOR=' rgb_to_hex([0 0 0]) ...
			' ALINK=' rgb_to_hex([1 1 0]) ...
			' LINK=' rgb_to_hex([1 1 1]) ...
			' VLINK=' rgb_to_hex([1 1 1]) ...
			' TEXT=' rgb_to_hex([1 1 1]) ...
			' > \n'];
		
		%--
		% axes title
		%--
		
		if (~isempty(title_edit))
			S = [S '<P ALIGN=CENTER>' strrep(title_edit,'\','\\') '</P>\n'];
		end
		
		%--
		% display image at full size
		%--
		
		S = [S '<P ALIGN=CENTER> \n'];
		S = [S '<IMG SRC="' f ...
			'"' ' HEIGHT=' num2str(m) ' WIDTH=' num2str(n) '> \n'];
		S = [S '</P> \n'];
		
		%--
		% set xlabel
		%--
		if (~isempty(xlabel_edit))
			S = [S '<P ALIGN=CENTER>' strrep(xlabel_edit,'\','\\') '</P>\n'];
		end
		
		S = [S '</BODY>'];
		
		%--
		% create html file
		%--
		
		f = file_ext(f,'html');
		
		str_to_file(S,f);
			
		%--
		% display image in browser
		%--
		
		if (data.browser.view_html)
			eval(['!' f]);
		end
		
	end
		
	%--
	% return to original directory
	%--
	
	cd(pi);
			
%--
% Create HTML
%--

case ('Create HTML')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
					
	%--
	% toggle option and check
	%--
	
	if (isfield(data.browser,'create_html'))
		data.browser.create_html = ~data.browser.create_html;
	else
		data.browser.create_html = 1;
	end
	
	if (data.browser.create_html)
		set(data.image_menu.h.save_options(1),'check','on');
	else
		set(data.image_menu.h.save_options(1),'check','off');
	end
	
	%--
	% update userdata and menu
	%--
	
	set(h,'userdata',data);
		
	if (data.browser.view_html & ~data.browser.create_html)
		image_menu(h,'View HTML');
	end
	
%--
% View HTML
%--

case ('View HTML')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% toggle option and check
	%--
	
	if (isfield(data.browser,'view_html'))
		data.browser.view_html = ~data.browser.view_html;
	else
		data.browser.view_html = 1;
	end
	
	if (data.browser.view_html)
		set(data.image_menu.h.save_options(2),'check','on');
	else
		set(data.image_menu.h.save_options(2),'check','off');
	end
	
	%--
	% update userdata and menu
	%--
	
	set(h,'userdata',data);
		
	if (data.browser.view_html & ~data.browser.create_html)
		image_menu(h,'Create HTML');
	end

%--
% Image File Format
%--

case ({'TIFF','JPEG','PNG'})

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set format
	%--
	
	switch (str)
		
	case ('JPEG')
		data.browser.format = 'jpg';
	case ('PNG')
		data.browser.format = 'png';
	case ('TIFF')
		data.browser.format = 'tif';
		
	end

	%--
	% update menu and userdata
	%--
	
	set(data.image_menu.h.save_options(3),'check','off');
	set(findobj(data.image_menu.h.save_options,'label',str),'check','on');
	
	set(h,'userdata',data);
	
%--
% JPEG Quality
%--

case ({'100 (Best)','90  (Very High)','75  (High)','50  (Medium)','25  (Low)'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update menu and userdata
	%--
	
	tmp = str2num(strtok(str,' '));
	
	% update userdata
	
	data.browser.jpeg_quality = tmp;
	set(h,'userdata',data);
	
	% update menu
	
	ix = find([100,90,75,50,25] == tmp);
	set(data.image_menu.h.jpeg_quality,'check','off');
	set(data.image_menu.h.jpeg_quality(ix),'check','on');
	
%--
% Other JPEG Quality ...
%--

case ('Other JPEG Quality ...')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% setup input dialog
	%--
	
	ans = input_dialog( ...
		{'JPEG Quality'}, ...
		'Other JPEG Quality ...', ...
		[1,32], ...
		{[data.browser.jpeg_quality,0,100]} ...
	);
	
	%--
	% update menu and userdata if needed
	%--
	
	if (~isempty(ans))
		
		% update userdata
		
		data.browser.jpeg_quality = ans{1};
		set(h,'userdata',data);	
		
		% update menu
		
		set(data.image_menu.h.jpeg_quality,'check','off'); 
		
		ix = find(ans{1} == [100,90,75,50,25]);
		if (~isempty(ix))
			set(data.image_menu.h.jpeg_quality(ix),'check','on'); 
		else
			set(data.image_menu.h.jpeg_quality(end),'check','on');
		end
		
	end

%--
% TIFF Tags ...
%--

case ('TIFF Tags ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% setup input dialog
	%--
	
	ans = input_dialog( ...
		{'Description'}, ...
		'TIFF Tags ...', ...
		[4,60], ...
		{data.browser.tiff_description} ...
	);

	%--
	% update tiff tags if needed
	%--
	
	if (~isempty(ans))
		data.browser.tiff_description = ans{1};
		set(h,'userdata',data);
	end
	
%--
% TIFF Compression
%--

case ({'None','PackBits','CCITT (Binary)','Fax3 (Binary)','Fax4 (Binary)'})

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set tiff compression
	%--
	
	data.browser.compression = lower(strtok(str,' '));
	
	%--
	% update menu and userdata
	%--
	
	set(data.image_menu.h.tiff_compression,'check','off');
	set(findobj(data.image_menu.h.tiff_compression,'label',str),'check','on');
	
	set(h,'userdata',data);

%--
% PNG Tags ...
%--

case ('PNG Tags ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	png_tags = data.browser.png_tags;
	
	%--
	% setup input dialog using struct edit
	%--
		
	ans = input_dialog( ...
		{'Author','Copyright','Software','Comments','Description'}, ...
		'PNG Tags ...', ...
		[1, 32; 1, 32; 1, 32; 4, 60; 4, 60], ...
		{png_tags.author,png_tags.copyright,png_tags.software,png_tags.comments,png_tags.description} ...
	);

	%--
	% update tiff tags if needed
	%--
	
	if (~isempty(ans))
		
		png_tags.author = ans{1};
		png_tags.copyright = ans{2};
		png_tags.software = ans{3};
		png_tags.comments = ans{4};
		png_tags.description = ans{5};
		
		data.browser.png_tags = png_tags;
		
		set(h,'userdata',data);
		
	end
	
%--
% PNG BitDepth
%--

case ({'1 Bit','2 Bits','4 Bits','8 Bits','16 Bits'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update userdata and menu
	%--
	
	data.browser.png_bitdepth = str2num(strtok(str,' '));
	set(h,'userdata',data);
	
	set(data.image_menu.h.png_bitdepth,'check','off');
	set(get_menu(data.image_menu.h.png_bitdepth,str),'check','on');
	
%--
% Zoom
%--

case ('Zoom')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');

	%--
	% toggle zoom state using menu check and update menu
	%--
	
	% get handle to zoom menu item
	
	g = data.image_menu.h.image(2);
	
	% toggle zoom state and menu check
	
	switch (get(g,'check'))
		
	case ('on')
		zoom_linked(h,'off');
		set(g,'checked','off');
		
	case ('off')
		zoom_linked(h,'xy');
		set(g,'checked','on');
		
	end
	
% 	%--
% 	% toggle zoom state
% 	%--
% 	
% 	zoom;
% 	
% 	%--
% 	% update menu
% 	%--
% 	
% 	if (strcmp(get(h,'WindowButtonDownFcn'),'zoom(gcbf,''down'')'))
% 		set(data.image_menu.h.image(2),'checked','on');
% 	else
% 		set(data.image_menu.h.image(2),'checked','off');
% 	end
	
%--
% Zoom Range ...
%--

case ('Zoom Range ...')

	%--
	% setup input dialog
	%--
	
	xl = get(gca,'XLim');
	xl = [num2str(ceil(xl(1))) ':' num2str(floor(xl(2)))];
	
	yl = get(gca,'YLim');
	yl = [num2str(ceil(yl(1))) ':' num2str(floor(yl(2)))];
						
	ans = input_dialog( ...
		{'Row Range','Column Range'}, ...
		'Zoom Range ...', ...
		[1,32], ...
		{yl,xl});
	
	%--
	% update display if needed
	%--
	
	if (~isempty(ans))

		[r1,r2] = strtok(ans{1},':,');
		r1 = str2num(r1);
		r2 = str2num(r2(2:end));
		
		[c1,c2] = strtok(ans{2},':,');
		c1 = str2num(c1);
		c2 = str2num(c2(2:end));
		
		% get handles to all images
		
		im = get_image_handles(h);
		
		for k = 1:length(im)
			ax = get(im(k),'parent');
			set(ax,'XLim',[c1,c2],'YLim',[r1,r2]);
		end
	
	end

%--
% Grid
%--

case ('Grid')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% toggle grid state
	%--
	
	ax = findobj(h,'type','axes');
	
	for k = length(ax):-1:1
		tag = get(ax(k),'tag');
		if (~strcmp(tag,'Colorbar') & ~strcmp(tag,'support'))
			axes(ax(k));	
			grid;
		end
	end
	
	%--
	% update menu and userdata
	%--
	
	if (strcmp(get(gca,'XGrid'),'on') & strcmp(get(gca,'YGrid'),'on'))
		set(data.image_menu.h.image(6),'checked','on');
		data.browser.flag_grid = 1;
	else
		set(data.image_menu.h.image(6),'checked','off');
		data.browser.flag_grid = 0;
	end
	
	set(h,'userdata',data);

%--
% Grid Spacing
%--

% specific grid spacing options handles in 'otherwise'

%--
% No Ticks
%--

case ('No Ticks')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update grid
	%--
	
	% get all axes except colorbar axes and set grid
	
	ax = findobj(h,'type','axes');
	
	for k = length(ax):-1:1
		if (~strcmp(get(ax(k),'tag'),'Colorbar'))
			axes(ax(k));
			image_grid(0);
		end
	end
	
	%--
	% update menu
	%--
	
	set(data.image_menu.h.spacing,'check','off');
	set(findobj(data.image_menu.h.spacing,'label',str),'check','on');
	
%--
% Other Grid Spacing ...
%--

case ('Other Grid Spacing ...')
		
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% setup input dialog
	%--
	
	ans = input_dialog( ...
		{'Column Spacing','Row Spacing'}, ...
		'Other Grid Spacing ...', ...
		[1,32], ...
		{'',''} ...
	);

	%--
	% update grid display, menus, and userdata
	%--
	
	if (~isempty(ans))

		c = round(str2num(ans{1}));
		r = round(str2num(ans{2}));
		
		if (r == c)
			ix = find(c == [-1,1,2,4,8,16,32,64,128]);
			if (~isempty(ix))
				set(data.image_menu.h.spacing,'check','off');
				set(data.image_menu.h.spacing(ix),'check','on');
			else
				set(data.image_menu.h.spacing,'check','off');
				set(data.image_menu.h.spacing(end),'check','on');
			end
		else
			set(data.image_menu.h.spacing,'check','off');
			set(data.image_menu.h.spacing(end),'check','on');
		end
		
		% get all axes except colorbar axes and set grid
	
		ax = findobj(h,'type','axes');
		
		for k = length(ax):-1:1
			if (~strcmp(get(ax(k),'tag'),'Colorbar'))
				axes(ax(k));
				image_grid(-r,-c);
			end
		end
				
	else
		
		return;
		
	end
	
%--
% Grid or Contour Color
%--

case (COLOR)
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get parent of callback object
	%--
	
	try
		type = get(get(get(gcbo,'parent'),'parent'),'label');
		if (isempty(type))
			type = 'Grid Options';
		end
	catch
		type = 'Grid Options';
	end
	
	%--
	% update axes or contour color
	%--
	
	switch (type)
		
		%--
		% update axes/grid color
		%--
		
		case ('Grid Options')
		
			%--
			% set axes colors
			%--
			
			tmp = color_to_rgb(str);
			ax = findobj(h,'type','axes');
			
			set(ax,'XColor',tmp,'YColor',tmp);
			
			%--
			% update menu
			%--
			
			set(data.image_menu.h.color,'check','off');
			set(findobj(data.image_menu.h.color,'label',str),'check','on');
			
			%--
			% update userdata
			%--
			
			data.browser.axes_color = str;
			set(h,'userdata',data);
			
		%--
		% update contour color
		%--
		
		case ('Contour Options')
			
			%--
			% update userdata
			%--
			
			rgb = color_to_rgb(str);
			
			data.browser.contour.color = rgb;
			set(h,'userdata',data);
			
			%--
			% update display
			%--
			
			set(findobj(h,'tag','contour'),'color',rgb);
			
	end
		
%--
% Colorbar
%--

case ('Colorbar')

	% FIXME: there is a problem when we are displaying a color image
	
	% NOTE: we are handling this temporarily with an exception
	
	try
		
		%--
		% get userdata
		%--

		data = get(h,'userdata');

		%--
		% toggle colorbar state and update userdata and menu
		%--

		if (~data.browser.flag_colorbar)

			%--
			% get image handles and set colorbars
			%--

			im = get_image_handles(h);

			j = 1;
			for k = 1:length(im)

				tmp = get(im(k),'CData');
				ax = get(im(k),'parent');

				if (ndims(tmp) < 3)
					axes(ax);
					g(j) = colorbar;
					j = j + 1;
				end

			end 

			rgb = color_to_rgb(data.browser.axes_color);

			set(g,'XColor',rgb,'YColor',rgb);

			data.image_menu.h.colorbar = g;
			data.browser.flag_colorbar = 1;
			set(h,'userdata',data);

			if (~isempty(data.browser.scale))
				image_menu(h,data.browser.scale);
			end

			set(data.image_menu.h.colormap_options(1),'check','on');

		else

			delete(data.image_menu.h.colorbar);
			data.browser.flag_colorbar = 0;
			set(h,'userdata',data);

			if (~isempty(data.browser.scale))
				image_menu(h,data.browser.scale);
			end

			set(data.image_menu.h.colormap_options(1),'check','off');

		end
	
	end
		
%--
% Colormap
%--

case (COLORMAP)

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update userdata and menu
	%--
	
	data.browser.colormap = str;
	set(h,'userdata',data);
	
	set(data.image_menu.h.colormap,'check','off');
	
	set(findobj(data.image_menu.h.colormap,'label',str),'check','on');
	
	%--
	% remove colorbars
	%--
	
	if (data.browser.flag_colorbar)
		image_menu(h,'Colorbar');
	end
	
	%--
	% update display
	%--
	
	map = data.browser.colormap;
	
	n = data.browser.levels;
	
	% update clim axes property for colormaps different from 'Real'
	
	if (~strcmp(map,'Real'))
		
		im = get_image_handles(h); 
		
		for k = 1:length(im)
			ax = get(im(k),'parent');
			set(ax,'clim',fast_min_max(get(im(k),'CData')));
		end
		
	end
	
	colormap(eval([colormap_to_fun(map) '(' num2str(n) ')']));
	
	%--
	% add colorbars if needed
	%--
	
	if (data.browser.flag_colorbar)
		image_menu(h,'Colorbar');
	end
	
%--
% 'Number of Levels' and 'Number of Bins'
%--

case ({'2','4','8','16','32','64','128','256','10','100'})

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set number of levels or number of bins
	%--
	
	tmp = get(get(gcbo,'parent'),'label');
	
	if (isempty(tmp))
		tmp = 'Number of Levels';
	end
	
	switch (tmp)
		
	case ('Number of Levels')
		
		%--
		% set number of levels
		%--
		
		data.browser.levels = str2num(str);
		set(h,'userdata',data);
		
		%--
		% update display
		%--
		
		image_menu(h,data.browser.colormap);
		
		if (data.browser.flag_colorbar)
			g = colorbar;
% 			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
		%--
		% update menu
		%--
		
		set(data.image_menu.h.levels,'check','off');
		set(findobj(data.image_menu.h.levels,'label',str),'check','on');
	
	case ('Number of Bins')
		
		%--
		% get userdata
		%--
		
		data = get(h,'userdata');
		
		%--
		% set number of bins
		%--
		
		data.browser.bins = str2num(str);
		
		%--
		% update userdata and menu
		%--
		
		set(h,'userdata',data);
		
		set(data.image_menu.h.bins,'check','off');
		set(findobj(data.image_menu.h.bins,'label',str),'check','on');
		
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

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	colormap(flipud(get(h,'colormap')));

%--
% Histogram
%--

case ('Histogram')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get displayed image data (use image_crop) and title
	%--
	
	X = get_image_data(h);
	
	[X,r,c] = image_crop(gca);
	
	t = title_edit;
	
	%--
	% display histogram using hist_view
	%--
	
	g = fig;
	
	% TODO: the 'hist_view' command is not available
	
	hist_view(X,data.browser.bins);
	
	%--
	% apply available histogram options
	%--
	
	hist_menu(g,data.browser.model);
	
	if (data.browser.fit_model)
		hist_menu(g,'Fit Model');
	end
	
% 	%--
% 	% compute histogram for image planes
% 	%--
% 	
% 	[hh,c,v] = hist_1d(X,data.browser.bins);
% 	
% 	%--
% 	% color image
% 	%--
% 	
% 	if (iscell(hh))
% 		
% 		%--
% 		% add plane information to title
% 		%--
% 		
% 		for k = 1:length(hh)
% 			N{k} = [t ' (:,:,' num2str(k) ')'];
% 		end
% 		
% 		%--
% 		% display histogram
% 		%--
% 		
% 		fig; g = hist_1d_view(hh,c,v,N);
% 		
% 		%--
% 		% set head title
% 		%--
% 		
% 		axes(g(1));
% 		title_edit(['Normalized Histograms of ' t]);
% 		
% 		%--
% 		% compute and display fit to model
% 		%--
% 		
% 		if (data.browser.fit_model)
% 
% 			for k = 1:length(g)
% 				
% 				%--
% 				% compute fit
% 				%--
% 				
% 				[p,y] = hist_1d_fit(X(:,:,k),data.browser.model,c{k});
% 				
% 				%--
% 				% display fit
% 				%--
% 				
% 				axes(g(k));
% 				hold on; 
% 				plot(c{k},y,'k-');
% 				
% 				%--
% 				% display parameter values
% 				%--
% 				
% 				tmp = [data.browser.model ': '];
% 				for k = 1:length(p)
% 					tmp = [tmp, 'p(' num2str(k) ') = ' num2str(p(k)) ', '];
% 				end
% 				tmp = tmp(1:end - 2);
% 				
% 				xlabel_edit(tmp);
% 				
% 			end	
% 			
% 		%--
% 		% display kernel smoothed histogram
% 		%--
% 		
% 		else
% 
% 			for k = 1:length(g)
% 				
% 				%--
% 				% compute kernel smoothed histogram
% 				%--
% 				
% 				nn = floor(data.browser.bins / 10);
% 				tmp = conv2(hh{k}/(sum(hh{k}) *(c{k}(2) - c{k}(1))),filt_binomial(nn)','same');
% 				
% 				%--
% 				% display smoothed histogram
% 				%--
% 				
% 				axes(g(k));
% 				hold on; 
% 				plot(c{k},tmp,'k-');
% 				
% 			end
% 			
% 		end 
% 		
% 	%--
% 	% grayscale image
% 	%--
% 	
% 	else
% 		
% 		%--
% 		% display histograms
% 		%--
% 				
% 		fig; hist_1d_view(hh,c,v,t);
% 		
% 		%--
% 		% compute and display fit to model
% 		%--
% 		
% 		if (data.browser.fit_model)
% 				
% 			%--
% 			% compute fit
% 			%--
% 			
% 			[p,y] = hist_1d_fit(X,data.browser.model,c);
% 			
% 			%--
% 			% display fit
% 			%--
% 			
% 			hold on; 
% 			plot(c,y,'--','color',color_to_rgb('Red'));
% 			
% 			%--
% 			% display parameter values
% 			%--
% 			
% 			tmp = [data.browser.model ': '];
% 			for k = 1:length(p)
% 				tmp = [tmp, 'p(' num2str(k) ') = ' num2str(p(k)) ', '];
% 			end
% 			tmp = tmp(1:end - 2);
% 			
% 			xlabel_edit(tmp);
% 					
% 		%--
% 		% display kernel smoothed histogram
% 		%--
% 		
% 		else
% 			
% 			%--
% 			% compute kernel smoothed histogram
% 			%--
% 			
% 			nn = floor(data.browser.bins / 10);
% 			tmp = conv2(hh/(sum(hh) *(c(2) - c(1))),filt_binomial(nn)','same');
% 			
% 			%--
% 			% display smoothed histogram
% 			%--
% 			
% 			hold on; 
% 			plot(c,tmp,'k-');
% 							
% 		end 
% 		
% 	end
	
%--
% Other Number of Bins ...
%--

case ('Other Number of Bins ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% setup input dialog
	%--
	
	ans = input_dialog( ...
		{'Number of Bins'}, ...
		'Other Number of Bins ...', ...
		[1,32], ...
		{num2str(data.browser.bins)} ...
	);

	%--
	% update number of bins, menus, and userdata
	%--
	
	if (~isempty(ans))
		
		bins = round(str2num(ans{1}));
		data.browser.bins = bins;
		
		ix = find(bins == [10,100,32,64,128,256]);
		if (~isempty(ix))
			set(data.image_menu.h.bins,'check','off');
			set(data.image_menu.h.bins(ix),'check','on');
		else
			set(data.image_menu.h.bins,'check','off');
			set(data.image_menu.h.bins(end),'check','on');
		end
		
		set(h,'userdata',data);
		
	else
		
		return;
		
	end

%--
% Fit Model
%--

case ('Fit Model')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% toggle fit flag
	%--
	
	data.browser.fit_model = ~data.browser.fit_model;
	
	%--
	% update userdata and menu
	%--
	
	set(h,'userdata',data);
	
	if (data.browser.fit_model)
		set(findobj(data.image_menu.h.hist_options,'label',str),'check','on');
	else
		set(findobj(data.image_menu.h.hist_options,'label',str),'check','off');
	end
	
%--
% Model
%--

case (PDF)
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update userdata and menu
	%--
	
	data.browser.model = str;
	set(h,'userdata',data);
	
	set(data.image_menu.h.models,'check','off');
	set(findobj(data.image_menu.h.models,'label',str),'check','on');
	
%--
% Histogram Options ...
%--

case ('Histogram Options ...')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% setup input dialog
	%--
	
	% make current model default answer
	
	ix = find(strcmp(data.browser.model,PDF));
	
	if (~isempty(ix))
		list = PDF;
		list{1} = PDF{ix};
		list{ix} = PDF{1};
	end
	
	ans = input_dialog( ...
		{'Number of Bins','Fit','Model to Fit'}, ...
		'Histogram Options ...', ...
		[1,32], ...
		{num2str(data.browser.bins),{'on','off'},list} ...
	);

	%--
	% update histogram options, menus, and userdata
	%--
	
	if (~isempty(ans))
		
		bins = round(str2num(ans{1}));
		data.browser.bins = bins;
		
		ix = find(bins == [10,100,32,64,128,256]);
		if (~isempty(ix))
			set(data.image_menu.h.bins,'check','off');
			set(data.image_menu.h.bins(ix),'check','on');
		else
			set(data.image_menu.h.bins,'check','off');
			set(data.image_menu.h.bins(end),'check','on');
		end
		
		if (strcmp(ans{2},'on'))
			data.browser.fit_model = 1;
			set(get_menu(data.image_menu.h.hist_options,'Fit'),'check','on');
		else
			data.browser.fit_model = 0;
			set(get_menu(data.image_menu.h.hist_options,'Fit'),'check','off');
		end
		
		data.browser.model = ans{3};
		set(data.image_menu.h.models,'check','off');
		set(get_menu(data.image_menu.h.models,ans{3}),'check','on');
		
		set(h,'userdata',data);
		
	else
		
		return;
		
	end
	
%--
% Half Size
%--

case ('Half Size')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	% get size of displayed image, not full image
	
% 	s = size(get_image_data(h));
	s = size(image_crop(gca));
	
	s = s(1:2);
	truesize(h,0.5*s);
	
	%--
	% update userdata and menu
	%--
	
	data.browser.scale = 'Half Size';
	set(h,'userdata',data);
	
	set(data.image_menu.h.image(12:15),'check','off');
	
% 	if (~isempty(get_menu(gcf,'Colormap')))
% 		set(data.image_menu.h.image(13:16),'check','off');
% 	else
% 		set(data.image_menu.h.image(11:14),'check','off');
% 	end
		
	set(findobj(data.image_menu.h.image,'label',str),'check','on');

%--
% Normal Size
%--

case ('Normal Size')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	% get size of displayed image, not full image
	
% 	s = size(get_image_data(h));
	s = size(image_crop(gca));
	
	s = s(1:2);
	truesize(h,s);
	
	%--
	% update userdata and menu
	%--
	
	data.browser.scale = 'Normal Size';
	set(h,'userdata',data);
	
	set(data.image_menu.h.image(12:15),'check','off');
	
% 	if (~isempty(get_menu(gcf,'Colormap')))
% 		set(data.image_menu.h.image(13:16),'check','off');
% 	else
% 		set(data.image_menu.h.image(11:14),'check','off');
% 	end
		
	set(findobj(data.image_menu.h.image,'label',str),'check','on');
	
%--
% Double Size
%--

case ('Double Size')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	% get size of displayed image, not full image
	
% 	s = size(get_image_data(h));
	s = size(image_crop(gca));
	
	s = s(1:2);
	truesize(h,2*s);
	
	%--
	% update userdata and menu
	%--
	
	data.browser.scale = 'Double Size';
	set(h,'userdata',data);
	
	set(data.image_menu.h.image(12:15),'check','off');
	
% 	if (~isempty(get_menu(gcf,'Colormap')))
% 		set(data.image_menu.h.image(13:16),'check','off');
% 	else
% 		set(data.image_menu.h.image(11:14),'check','off');
% 	end
		
	set(findobj(data.image_menu.h.image,'label',str),'check','on');

%--
% Fill Screen
%--

case ('Fill Screen')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');

	%--
	% update display 
	%--
	
	truesize_max(h);

	%--
	% update userdata and menu
	%--
	
	data.browser.scale = 'Fill Screen';
	set(h,'userdata',data);
	
	set(data.image_menu.h.image(12:15),'check','off');
	
% 	if (~isempty(get_menu(gcf,'Colormap')))
% 		set(data.image_menu.h.image(13:16),'check','off');
% 	else
% 		set(data.image_menu.h.image(11:14),'check','off');
% 	end
		
	set(findobj(data.image_menu.h.image,'label',str),'check','on');
	
%--
% Rotate Left
%--

case ('Rotate Left')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	% get all image handles
	
	im = get_image_handles(h);
	
	for k = 1:length(im)
		
		ax = get(im(k),'parent');
		axes(ax);
		
		[X,g] = get_image_data(ax);
		
		set(ax,axes_transpose(ax));			
		set(g,'CData',image_rot90(X,1));
		
	end
	
	image_menu(h,data.browser.scale);
				
%--
% Rotate Right
%--

case ('Rotate Right')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	% get all image handles
	
	im = get_image_handles(h);
	
	for k = 1:length(im)
		
		ax = get(im(k),'parent');
		axes(ax);
		
		[X,g] = get_image_data(ax);
		
		set(ax,axes_transpose(ax));	
		set(g,'CData',image_rot90(X,-1));
		
	end
	
	image_menu(h,data.browser.scale);

%--
% Flip Horizontal
%--

% there is a problem displaying lines on top of the image in this case

case ('Flip Horizontal')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	% get all image handles
	
	im = get_image_handles(h);
	
	for k = 1:length(im)
		
		ax = get(im(k),'parent');
		axes(ax);
		
		[X,g] = get_image_data(ax);
		
		set(g,'CData',image_flip_hor(X));
		
	end
	
	if (data.browser.flag_grid)
		grid;
		grid;
	end
			
%--
% Flip Vertical
%--

% there is a problem displaying lines on top of the image in this case

case ('Flip Vertical')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update display
	%--
	
	im = get_image_handles(h);
	
	for k = 1:length(im)
		
		ax = get(im(k),'parent');
		axes(ax);
		
		[X,g] = get_image_data(ax);
		
		set(g,'CData',image_flip_ver(X));
		
	end
	
	if (data.browser.flag_grid)
		grid;
		grid;
	end
	
%--
% Contour
%--

case ('Contour')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update contour display state
	%--
	
	state = ~data.browser.contour.on;
	data.browser.contour.on = state;
	set(h,'userdata',data);
	
	%--
	% update contour display and menu
	%--
	
	tmp = data.image_menu.h.image;
	if (state == 1)
		set(get_menu(tmp,'Contour'),'check','on');
	else 
		set(get_menu(tmp,'Contour'),'check','off');
	end
	
	image_menu(h,'Contour Display');
	
%--
% Contour Options: Values
%--

case ({'Auto','Mean','Median','Quartiles','Other Values ...'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%-- 
	% update contour value parameter
	%--
	
	switch (str)
		
		case ('Other Values ...')
			
			%--
			% set up input dialog ...
			%--
			
			data.browser.contour.values = 0.5;
			
		otherwise
			data.browser.contour.values = lower(str);
			
	end
	
	set(h,'userdata',data);
	
	%--
	% update contour display
	%--
	
	image_menu(h,'Contour Display');
			
%--
% Contour Options: Line Width
%--

case ({'1 pt','2 pt','3 pt','4 pt'})
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% parse line width and update userdata
	%--
	
	w = eval(strtok(str,' '));

	data.browser.contour.linewidth = w;
	set(h,'userdata',data);
	
	%--
	% update display and menu
	%--
	
	tmp = data.image_menu.h.contour_linewidth;
	set(tmp,'check','off');
	set(get_menu(tmp,str),'check','on');
	
	set(findobj(h,'tag','contour'),'linewidth',w);
	
%--
% Labels
%--

case ('Labels')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update contour display state
	%--
	
	state = ~data.browser.contour.label;
	data.browser.contour.label = state;
	set(h,'userdata',data);
	
	%--
	% update contour display and menu
	%--
	
	image_menu(h,'Contour Display');
	
	if (state == 0)
		set(get_menu(data.image_menu.h.contour_options,'Labels'),'check','off');
	else 
		set(get_menu(data.image_menu.h.contour_options,'Labels'),'check','on');
	end
	
%--
% Contour Display (internal)
%--

case ('Contour Display')
	
	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% update contour display
	%--
	
	if (data.browser.contour.on == 0)
		
		%--
		% set figure renderer mode to automatic
		%--
		
		set(h,'renderermode','auto');
		
		%--
		% delete contour display objects
		%--
		
		delete(findobj(h,'tag','contour')); 
		
	else
		
		%--
		% set figure renderer and pointer
		%--
		
		set(h, ...
			'renderermode','manual', ...
			'renderer','painters', ...
			'pointer','watch' ...
		);
		
		%--
		% delete previous contour display objects
		%--
		
		delete(findobj(h,'tag','contour')); 
	
		%--
		% compute and display contours
		%--
		
		im = get_image_handles(h);
		
		for k = 1:length(im)
			
			%--
			% make image parent axes current
			%--
			
			ax = get(im(k),'parent');
			axes(ax);
			hold on;
			
			%--
			% get image data and compute and display contours
			%--
			
			[X,g] = get_image_data(ax);
									
			[m,n,d] = size(X);
			
			if (d > 1)
				
				continue;
				
			else
				
				%--
				% compute and display contours
				%--
				
				val = data.browser.contour.values;
				
				if (isstr(val))
					
					%--
					% compute level values for contours
					%--
					
					switch (val)
						
						case ('mean')
							val = mean(X(:));
							
						case ('median')
							val = fast_median(X(:));
							
						case ('quartiles')
							val = [fast_rank(X(:),0.25), fast_rank(X(:),0.5), fast_rank(X(:),-0.25)];
							
						otherwise
							val = [];
							
					end
					
					%--
					% compute contours
					%--
					
					if (isempty(val))
						[C,hh] = contour(X,'-');
					else
						[C,hh] = contour(X,val,'-');
					end
					
				else
					
					%--
					% compute contours
					%--
					
					[C,hh] = contour(X,val,'-');
					
				end
					
				%--
				% set contour display properties and labels if needed
				%--
				
				set(hh, ...
					'color',data.browser.contour.color, ...
					'linestyle',data.browser.contour.linestyle, ...
					'linewidth',data.browser.contour.linewidth, ...
					'tag','contour' ...
				);
			
				if (data.browser.contour.label)
					ht = clabel(C,hh);
					set(ht, ...
						'color',data.browser.contour.color, ...
						'tag','contour' ...
					);
				end
				
			end
						
		end
		
		%--
		% reset pointer
		%--
		
		set(h,'pointer','arrow');

	end
	
%--
% various command string classes
%--

otherwise
	
	%--
	% Grid Spacing (Specific)
	%--

	if (~isempty(findstr(str,' x ')))
		
		%--
		% get userdata
		%--
		
		data = get(h,'userdata');

		%--
		% get and set grid spacing
		%--
		
		ax = findobj(h,'type','axes');
		
		for k = length(ax):-1:1
			tag = get(ax(k),'tag');
			if (~strcmp(tag,'Colorbar') & ~strcmp(tag,'support'))
				axes(ax(k));
				image_grid(-str2num(strtok(str,' ')));
			end
		end
		
		%--
		% update menu
		%--
		
		set(data.image_menu.h.spacing,'check','off');
		set(findobj(data.image_menu.h.spacing,'label',str),'check','on');
		
		return;
		
	end

	%--
	% get first token from command string
	%--
	
	[tok,res] = strtok(str,' ');
	res = res(2:end);
	
	%--
	% Number of Levels
	%--
	
	if (strcmp(tok,'Levels'))
		
		%--
		% get userdata
		%--
		
		data = get(h,'userdata');
		
		%--
		% update number of levels
		%--
		
		data.browser.levels = str2num(res);
		set(h,'userdata',data);
		
		%--
		% update display
		%--
		
		image_menu(h,data.browser.colormap);
		
		if (data.browser.flag_colorbar)
			g = colorbar;
% 			set(g,'XColor',0.5*[1, 1, 1],'YColor',0.5*[1, 1, 1]);
		end
		
		%--
		% update menu
		%--
		
		set(data.image_menu.h.levels,'check','off');
		
		tmp = findobj(data.image_menu.h.levels,'label',res);
		
		if (~isempty(tmp))
			set(tmp,'check','on');
		else
			set(data.image_menu.h.levels(end),'check','on');
		end
		
		return;
		
	end
	
	%--
	% Number  of Bins
	%--
	
	if (strcmp(tok,'Bins'))
		
		%--
		% get userdata
		%--
		
		data = get(h,'userdata');
		
		%--
		% update number of levels
		%--
		
		data.browser.bins = str2num(res);
		set(h,'userdata',data);
		
		%--
		% update menu
		%--
		
		set(data.image_menu.h.bins,'check','off');
		
		tmp = findobj(data.image_menu.h.bins,'label',res);
		
		if (~isempty(tmp))
			set(tmp,'check','on');
		else
			set(data.image_menu.h.bins(end),'check','on');
		end
		
		return;
		
	end
	
	%--
	% unrecognized command string
	%--
	
% 	disp(' ');
% 	warning(['Unrecognized command ''' str ''' in ''image_menu''.']);
% 	disp(' ');
			
end
		
