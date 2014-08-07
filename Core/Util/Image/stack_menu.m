function stack_menu(h,str,flag)

% stack_menu - stack viewing tools menu
% -------------------------------------
%
% stack_menu(h,str,flag)
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
% $Date: 2003-07-06 13:36:59-04 $
%--------------------------------

%--
% set enable flag option
%--

if (nargin == 3)	
	if (get_menu(h,'Stack'))
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
			stack_menu(h,str{k}); 
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
% main switch
%--

switch (str)

%--
% Initialize
%--

case ('Initialize')
	
	%--
	% get userdata
	%--
	
	if (~isempty(get(h,'userdata')))
		data = get(h,'userdata');
	end
	
	%--
	% Stack
	%--
	
	L = { ...
		'Stack', ...				%
		'Bounds', ...
		'Save Stack ...', ...		%  5 - sep
		'Save Stack Options', ...	%  6 - sub
		'View Frames', ...			%  9 - acc I, sep
		'View Frames Options', ...		% 10 - sub menu 
		'Previous Frame', ...		%  3 - acc [
		'Next Frame', ...			%  4 - acc ]
		'Slide Show', ...			%  7 - acc M, sep
		'Slide Show Options' ...	%  8 - sub menu
	};
	
	hi = findobj(h,'tag','IMAGE_STACK');
	
	% get and prefix names
	
 	N = getfield(get(hi,'userdata'),'N');
	
	for k = 1:length(N)
		N{k} = ['Frame ' num2str(k) ': ' N{k}];
	end
	
	L = {L{:}, N{:}};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{3} = 'on';
	S{5} = 'on';
	S{7} = 'on';
	S{11} = 'on';
	
	A = cell(1,n);
% 	A{3} = 'B';
% 	A{4} = 'N';
% 	A{7} = 'M';
	
	data.stack_menu.h.stack = menu_group(h,'stack_menu',L,S,A);
	
	%--
	% Bounds
	%--
	
	L = { ...
		'Frame', ...
		'Stack' ...
	};

	n = length(L);
	S = bin2str(zeros(1,n));
	
	A = cell(1,n);
	
	data.stack_menu.h.bounds = menu_group( ...
		get_menu(data.stack_menu.h.stack,'Bounds'),'stack_menu',L,S,A);

	%--
	% Save Stack Options
	%--
	
	L = { ...
		'Create HTML', ...		%  1 -
		'View HTML', ...
		'HTML Options', ...		%  2 - sub
		'JPEG', ...				%  3 - sep
		'JPEG Quality ...', ...	%  4 - 
		'TIFF', ...				%  5 - sep
		'TIFF Compression'		%  6 - sub
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{4} = 'on';
	S{6} = 'on';
	
	A = cell(1,n);
	
	data.stack_menu.h.save_options = ...
		menu_group(get_menu(h,'Save Stack Options'),'stack_menu',L,S,A);
		
	%--
	% HTML Options
	%--
	
	L = { ...
		'Plain HTML', ...		%  2 -
		'Use Imagemap' ...		%  3 - 
		'Use Javascript', ...	%  4 - 
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	
	A = cell(1,n);
	
	data.stack_menu.h.html_options = ...
		menu_group(get_menu(h,'HTML Options'),'stack_menu',L,S,A);
	
	set(get_menu(h,'Use Imagemap'),'enable','off'); 
	set(get_menu(h,'Use Javascript'),'enable','off');
		
	%--
	% TIFF Compression
	%--
	
	L = { ...
		'None', ...				%  1 -
		'PackBits' ...			%  2 - sep
		'CCITT', ...			%  3 - 
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	
	A = cell(1,n);
	
	data.stack_menu.h.tiff_compression = ...
		menu_group(get_menu(h,'TIFF Compression'),'stack_menu',L,S,A);
	
	%--
	% Slide Show Options
	%--
	
	L = { ...
		'Frame Interval', ...		%  1 - sub
		'Loop', ...					%  2 - sub, sep
		'Loop Back and Forth' ...	%  3 - sub
	};
			
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	
	A = cell(1,n);

	data.stack_menu.h.sequence_options = ...
		menu_group(get_menu(h,'Slide Show Options'),'stack_menu',L,S,A);
	
	set(get_menu(h,'Loop'),'enable','off');
	set(get_menu(h,'Loop Back and Forth'),'enable','off');
	
	%--
	% Frame Interval
	%--	
	
	L = { ...
		'Pause', ...
		'1/4 Sec', ...
		'1/2 Sec', ...
		'1 Sec', ...
		'2 Sec', ...
		'4 Sec', ...
	};
	
	n = length(L);
	
	S = bin2str(zeros(1,n));
	S{2} = 'on';
	S{4} = 'on';
	
	A = cell(1,n);
	
	data.stack_menu.h.interval = ...
		menu_group(get_menu(h,'Frame Interval'),'stack_menu',L,S,A);
	
	%--
	% View Frames Options
	%--
	
	L = { ...
		'Row', ...				%  1
		'Horizontal Bias', ...	%  2
		'Vertical Bias', ...	%  3
		'Column' ...			%  4
	};
			
	n = length(L);
	
	S = bin2str(zeros(1,n));
	
	A = cell(1,n);

	data.stack_menu.h.image_options = ...
		menu_group(get_menu(h,'View Frames Options'),'stack_menu',L,S,A);
	
	%--
	% other initializations and set userdata
	%--
	
	data.stack_menu.p.bounds = 'frame';
	set(data.stack_menu.h.bounds(1),'check','on');
	
	data.stack_menu.p.jpeg_quality = 100;
	data.stack_menu.p.view_html = 0;
					
	data.stack_menu.h.image = hi;

	data.stack_menu.p.frame = 1;
	data.stack_menu.p.no_frames = length(N);
	
	data.stack_menu.p.loop = 0;
	data.stack_menu.p.back_and_forth = 0;
	
	data.stack_menu.p.bias = 'h';
	
	set(h,'userdata',data);
	
	%--
	% set default properties
	%--
	
	stack_menu(h,'1/2 Sec');
	
	stack_menu(h,'First Frame');
	
	stack_menu(h,'Horizontal Bias');
	
	stack_menu(h,'Create HTML');
	
	stack_menu(h,'View HTML');
	
	stack_menu(h,'Plain HTML');
	
	stack_menu(h,'JPEG'); 
	
% 	stack_menu(h,'PackBits');

%--
% Bounds
%--

%--
% Frame
%--

case ('Frame')
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% update bounds option and menu
	%--
	
	data.stack_menu.p.bounds = lower(str);
	
	set(data.stack_menu.h.bounds,'check','off'); 
	set(data.stack_menu.h.bounds(1),'check','on');
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	stack_menu(h,'Update Bounds');
		
%--
% Stack
%--

case ('Stack')
	
	%--
	% get userdata
	%--
	
	data = get(gcf,'userdata');
	
	%--
	% update bounds option and menu
	%--
	
	data.stack_menu.p.bounds = lower(str);
	
	set(data.stack_menu.h.bounds,'check','off'); 
	set(data.stack_menu.h.bounds(2),'check','on');
	
	%--
	% update userdata
	%--
	
	set(h,'userdata',data);
	
	%--
	% update display
	%--
	
	stack_menu(h,'Update Bounds');
	
%--
% Update bounds
%--

case ('Update Bounds')
	
	%--
	% get userdata and relevant fields
	%--
	
	data = get(h,'userdata');
	
	bounds = data.stack_menu.p.bounds;
	k = data.stack_menu.p.frame;
		
	%--
	% update bounds of relevant objects
	%--
	
	if (strcmp(bounds,'frame'))
		
		g = findobj(h,'tag','IMAGE_STACK');
		datag = get(g,'userdata');
		
		set(findobj(h,'type','axes'),'clim',datag.bounds.frame{k});
		
		tmp = findobj(h,'tag','Colorbar');
		if (~isempty(tmp))
			set(tmp,'ylim',datag.bounds.frame{k});
			tmp = findobj(h,'tag','TMW_COLORBAR');
			set(tmp,'ydata',datag.bounds.frame{k});
		end
		
	else
		
		g = findobj(h,'tag','IMAGE_STACK');
		datag = get(g,'userdata');
		
		set(findobj(h,'type','axes'),'clim',datag.bounds.stack);
		
		tmp = findobj(h,'tag','Colorbar');
		if (~isempty(tmp))
			set(tmp,'ylim',datag.bounds.stack);
			tmp = findobj(h,'tag','TMW_COLORBAR');
			set(tmp,'ydata',datag.bounds.stack);
		end
		
	end
	
	%--
	% return to image axes
	%--
	
	axes(get(g,'parent'));
	
	%--
	% update colormap if needed
	%--
	
% 	if (strcmp(data.image_menu.p.colormap,'Real'))
% 		image_menu(h,'Real');
% 	end
 	
%--
% Save Stack ...
%--

case ('Save Stack ...')

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
			
%--
% Create HTML
%--

case ('Create HTML')

	% get menu data
	
	data = get(h,'userdata');
					
	% toggle option and check
	
	if (isfield(data.stack_menu.p,'create_html'))
		data.stack_menu.p.create_html = ~data.stack_menu.p.create_html;
	else
		data.stack_menu.p.create_html = 1;
	end
	
	if (data.stack_menu.p.create_html)
		set(get_menu(h,str),'check','on');
	else
		set(get_menu(h,str),'check','off');
	end
	
	% update menu data
	
	set(h,'userdata',data);
	
	% update view html
	
	if (data.stack_menu.p.view_html & ~data.stack_menu.p.create_html)
		stack_menu(h,'View HTML');
	end
	
%--
% View HTML
%--

case ('View HTML')

	% get menu data
	
	data = get(h,'userdata');
	
	% toggle option and check
	
	if (isfield(data.stack_menu.p,'view_html'))
		data.stack_menu.p.view_html = ~data.stack_menu.p.view_html;
	else
		data.stack_menu.p.view_html = 1;
	end
	
	if (data.stack_menu.p.view_html)
		set(get_menu(h,str),'check','on');
	else
		set(get_menu(h,str),'check','off');
	end
	
	% update menu data
	
	set(h,'userdata',data);
	
	% update create html
	
	if (data.stack_menu.p.view_html & ~data.stack_menu.p.create_html)
		stack_menu(h,'Create HTML');
	end
	
%--
% HTML Options
%--

%--
% Plain HTML
%--

case ('Plain HTML')

	% get menu data
	
	data = get(h,'userdata');
	
	% set option and check
	
	data.stack_menu.p.html_format = 'plain';
	
	set(data.stack_menu.h.html_options,'check','off');
	set(findobj(data.stack_menu.h.html_options,'label',str),'check','on');
	
	% update menu data
	
	set(h,'userdata',data);

%--
% Use Imagemap
%--

case ('Use Imagemap')

	% get menu data
	
	data = get(h,'userdata');
	
	% set option and check
	
	data.stack_menu.p.html_format = 'imagemap';
	
	set(data.stack_menu.h.html_options,'check','off');
	set(findobj(data.stack_menu.h.html_options,'label',str),'check','on');
	
	% update menu data
	
	set(h,'userdata',data);

%--
% Use Javascript
%--

case ('Use Javascript')

	% get menu data
	
	data = get(h,'userdata');
	
	% set option and check
	
	data.stack_menu.p.html_format = 'javascript';
	
	set(data.stack_menu.h.html_options,'check','off');
	set(findobj(data.stack_menu.h.html_options,'label',str),'check','on');
	
	% update menu data
	
	set(h,'userdata',data);

%--
% JPEG
%--

case ('JPEG')

	% get menu data
	
	data = get(h,'userdata');
	
	% set option and check
	
	data.stack_menu.p.format = 'jpg';
	
	set(data.stack_menu.h.save_options(5),'check','off');
	set(findobj(data.stack_menu.h.save_options,'label',str),'check','on');
	
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
		[1,50], ...
		{num2str(data.stack_menu.p.jpeg_quality)});
	
	% update userdata
	
	if (~isempty(ans))
		data.stack_menu.p.jpeg_quality = str2num(ans{1});
	end
	
	set(h,'userdata',data);	

%--
% TIFF
%--

case ('TIFF')

	% get menu data
	
	data = get(h,'userdata');
	
	% set option and check
	
	data.stack_menu.p.format = 'tif';
	
	set(data.stack_menu.h.save_options(3),'check','off');
	set(findobj(data.stack_menu.h.save_options,'label',str),'check','on');
	
	% update menu data
	
	set(h,'userdata',data);

%--
% TIFF Compression
%--

case ({'None','Packbits','CCITT'})

	% get menu data
	
	data = get(h,'userdata');
	
	% set option and check
	
	data.stack_menu.p.compression = lower(str);
	
	set(data.stack_menu.h.tiff_compression,'check','off');
	set(findobj(data.stack_menu.h.tiff_compression,'label',str),'check','on');
	
	% update menu data
	
	set(h,'userdata',data);

%--
% First Frame
%--

case ('First Frame')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% get stack image data
	%--
	
	g = data.stack_menu.h.image;

	tmp = get(g,'userdata');
	X = tmp.X{1};
	N = tmp.N{1};
			
	%--
	% update display
	%--
		
	if (ndims(X) > 2)
		X = uint8(lut_range(X));
	end
	set(g,'CData',X);
	
	title_edit(N);
	
	%--
	% update menu and userdata
	%--
	
	set(data.stack_menu.h.stack(10:end),'check','off');
	set(data.stack_menu.h.stack(10),'check','on');
		
	data.stack_menu.p.frame = 1;
	set(h,'userdata',data);
	
	%--
	% update bounds
	%--
	
	stack_menu(h,'Update Bounds');
			
%--
% Previous Frame
%--

case ('Previous Frame')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% compute frame to display
	%--
	
	frame = data.stack_menu.p.frame;
	
	if (frame == 1)
		frame = data.stack_menu.p.no_frames;
	else
		frame = frame - 1;
	end
		
	%--
	% get stack image data
	%--
	
	g = data.stack_menu.h.image;
	
	X = getfield(get(g,'userdata'),'X',{frame});
	X = X{1};
	
	N = getfield(get(g,'userdata'),'N',{frame});
	N = N{1};
	
	%--
	% update display
	%--
	
	if (ndims(X) > 2)
		X = lut_range(X,[0,1]);
	end		
	set(g,'CData',X);
	
	title_edit(N);
	
	%--
	% update menu and userdata
	%--
		
	set(data.stack_menu.h.stack(10:end),'check','off');
	set(data.stack_menu.h.stack(9 + frame),'check','on');
		
	data.stack_menu.p.frame = frame;
	set(h,'userdata',data);
	
	%--
	% update bounds
	%--
	
	stack_menu(h,'Update Bounds');
	
%--
% Next Frame
%--

case ('Next Frame')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% compute frame to display
	%--
	
	frame = data.stack_menu.p.frame;
	
	if (frame == data.stack_menu.p.no_frames)
		frame = 1;
	else
		frame = frame + 1;
	end
	
	%--
	% get stack image data
	%--
	
	g = data.stack_menu.h.image;
	
	X = getfield(get(g,'userdata'),'X',{frame});
	X = X{1};
	
	N = getfield(get(g,'userdata'),'N',{frame});
	N = N{1};
	
	%--
	% update display
	%--
	
	if (ndims(X) > 2)
		X = lut_range(X,[0,1]);
	end
			
	set(g,'CData',X);
	title_edit(N);
	
	%--
	% update menu and userdata
	%--
		
	set(data.stack_menu.h.stack(10:end),'check','off');
	set(data.stack_menu.h.stack(9 + frame),'check','on');
		
	data.stack_menu.p.frame = frame;
	set(h,'userdata',data);
	
	%--
	% update bounds
	%--
	
	stack_menu(h,'Update Bounds');
	
%--
% Slide Show
%--

case ('Slide Show')

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	g = data.stack_menu.h.image;
	frame = data.stack_menu.p.frame;
	no_frames = data.stack_menu.p.no_frames;
	
	% callback code
	
	for k = 1:no_frames
			
			% get image and title
			
			X = getfield(get(g,'userdata'),'X',{k});
			X = X{1};
			
			N = getfield(get(g,'userdata'),'N',{k});
			N = N{1};
			
			% set image and title
			
			if (ndims(X) > 2)
				X = lut_range(X,[0,1]);
			end
			
			set(g,'CData',X);
			title_edit(N);
			
			drawnow; % this fixes the update of the label annotations
			
			% pause
			
			pause_frac(data.stack_menu.p.interval);
		
	end
	
	% loop
	
	while (data.stack_menu.p.loop)
	
		for k = 1:no_frames
			
			% get image and title
			
			X = getfield(get(g,'userdata'),'X',{k});
			X = X{1};
			
			N = getfield(get(g,'userdata'),'N',{k});
			N = N{1};
			
			% set image and title
			
			if (ndims(X) > 2)
				X = lut_range(X,[0,1]);
			end
			
			set(g,'CData',X);
			title_edit(N);
			
			% pause
			
			pause_frac(data.stack_menu.p.interval);
		
		end
	
	end
	
	% update menu data
	
	data.stack_menu.p.frame = no_frames;
	
	set(h,'userdata',data);
		
%--
% Sequence Options
%--

%--
% Loop
%--

case ('Loop')

	% get menu data
	
	data = get(h,'userdata');
	
	% set option and check
	
	t = ~data.stack_menu.p.loop;
			
	data.stack_menu.p.loop = t;
	data.stack_menu.p.back_and_forth = 0;
	
	set(data.stack_menu.h.sequence_options(2:3),'check','off');
	set(findobj(data.stack_menu.h.sequence_options,'label',str),'check',bin2str(t));
	
	% update menu data
	
	set(h,'userdata',data);
		
%--
% Loop Back and Forth
%--

case ('Loop Back and Forth')

	% get menu data
	
	data = get(h,'userdata');
	
	% set option and check
	
	t = ~data.stack_menu.p.back_and_forth;
			
	data.stack_menu.p.loop = 0;
	data.stack_menu.p.back_and_forth = t;
	
	set(data.stack_menu.h.sequence_options(2:3),'check','off');
	set(findobj(data.stack_menu.h.sequence_options,'label',str),'check',bin2str(t));
	
	% update menu data
	
	set(h,'userdata',data);

%--
% Frame Interval
%--

case ({'1/4 Sec','1/2 Sec','1 Sec','2 Sec','4 Sec','Pause'})

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set frame interval
	%--
	
	if (strcmp(str,'Pause'))
		data.stack_menu.p.interval = -1;
	else
		data.stack_menu.p.interval = eval(strtok(str,' '));
	end
	
	%--
	% update menu and userdata
	%--
	
	set(data.stack_menu.h.interval,'check','off');
	set(findobj(data.stack_menu.h.interval,'label',str),'check','on');
		
	set(h,'userdata',data);
	
%--
% View Frames
%--

case ('View Frames')

	% get userdata
	
	data = get(h,'userdata');
	
	% get stack images and names
	
	tmp = get(get_image_handles(h),'userdata');
	
	X = tmp.X;
	X = stack_crop(gca,X);
	
	N = tmp.N;
	
	% get axes color from current figure
	
% 	rgb = get(gca,'xcolor');
	
	% create new figure
	
	g = fig;
	
	% create axes array
	
	[m,n] = tile(length(X),data.stack_menu.p.bias);
	
	p = axes_array;
	p.xspace = 0.025;
	p.yspace = 0.05;
	
	ax = axes_array(m,n,p,g)';
	
	% put images and names in axes array
	
	for k = 1:(m * n)
		if (k <= length(X))
			axes(ax(k));
			image_view(X{k});
			title_edit(N{k});
			set(ax(k),'xtick',[],'ytick',[]);
			set(ax(k),'box','on');
			set(ax(k),'xcolor',[0,0,0],'ycolor',[0,0,0]);
		else
			set(ax(k),'visible','off');
		end
	end	
	
% 	% get title
% 	
% 	t = get_axes_title(gca);
% 	
% 	% create image
% 	
% 	Y = stack_crop;
% 	[m,n,d] = size(Y{1});
% 	[Y,r,c] = stack_to_tile(Y,data.stack_menu.p.bias);
% 	
% 	% new fig
% 	
% 	g = fig;
% 	
% 	% display image and set colormap
% 	
% 	image_view(Y);
% 	
% 	data = get(h,'userdata');
% 	image_menu(g,data.image_menu.p.colormap);
% 	
% 	title_edit(t);
% 	
% 	% set array grid
% 	
% 	hold on; 
% 
% 	for k = 1:(r - 1)
% 		t = plot([0, c*n],[k*m, k*m] + 0.5);
% 		set(t,'color',0.5*ones(1,3));
% 	end
% 	
% 	for k = 1:(c - 1)
% 		t = plot([k*n, k*n] + 0.5,[0, r*m]);
% 		set(t,'color',0.5*ones(1,3));
% 	end
% 	
% 	hold off;
	
	%--
	% set fig properties
	%--
	
	fig_name(fig_name(h),g);
	fig_caption(fig_caption(h),g);
				
%--
% View Frames Options
%--

case ({'Row','Horizontal Bias','Vertical Bias','Column'})

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	%--
	% set option
	%--
	
	data.stack_menu.p.bias = lower(str(1));
	
	%--
	% update menu and userdata
	%--
	
	set(data.stack_menu.h.image_options,'check','off');
	set(findobj(data.stack_menu.h.image_options,'label',str),'check','on');
		
	set(h,'userdata',data);
	
%--
% Named Frames
%--

otherwise

	%--
	% get userdata
	%--
	
	data = get(h,'userdata');
	
	g = data.stack_menu.h.image;
	N = getfield(get(g,'userdata'),'N');

	%--
	% parse command string
	%--
	
	[tmp,str] = strtok(str,':');
	str = str(3:end);
	
	k = find(strcmp(str,N));
	
	if (~isempty(k))

		if (length(k) > 1)
			k = k(1);
			disp(' ');
			warning('Frames are not uniquely named, selecting first match.');
			disp(' ');
		end
		
		X = getfield(get(g,'userdata'),'X',{k});
		X = X{1};
		
		N = getfield(get(g,'userdata'),'N',{k});
		N = N{1};
		
		%--
		% update display
		%--
		
		if (ndims(X) > 2)
			X = lut_range(X,[0,1]);
		end
		set(g,'CData',X);	
		title_edit(N);
		
		%--
		% update menu and userdata
		%--
		
		set(data.stack_menu.h.stack(10:end),'check','off');
		set(data.stack_menu.h.stack(9 + k),'check','on');
			
		data.stack_menu.p.frame = k;
		set(h,'userdata',data);
		
		%--
		% update bounds
		%--
		
		stack_menu(h,'Update Bounds');
			
	%--
	% unrecognized command
	%--
	
	else
	
		disp(' ');
		warning(['Reference to non-existing command ''' str '''.']);
		disp(' ');
		
	end
						
end

%--
% compute tiling rows and columns
%--

function [m,n] = tile(N,bias)

%--
% default tilings
%--

mn = [1,1; ...
	2,1; ...
	2,2; ...
	2,2; ...
	3,2; ...
	3,2; ...
	3,3; ...
	3,3; ...
	3,3; ...
	4,3; ...
	4,3; ...
	4,3];
	
%--
% set rows and columns
%--

maxf = 36;

switch (nargin)

	case (1)
		
		if (N < 13)
							
			m = mn(N,1);
			n = mn(N,2);
			
		else
				
			sq = [2:sqrt(maxf)].^2;
			sq = sq(find(sq >= N));
			m = sqrt(sq(1));
			n = m;
		
		end
	
	case (2)
				
		switch (bias)
		
			case ('r')
				m = 1;
				n = N;
				
			case ('h')
				if (N < 13)	
					m = mn(N,2);
					n = mn(N,1);
				else
					sq = [2:sqrt(maxf)].^2;
					sq = sq(find(sq >= N));
					m = sqrt(sq(1));
					n = m;
				end
				
			case ('v')
				if (N < 13)	
					m = mn(N,1);
					n = mn(N,2);
				else
					sq = [2:sqrt(maxf)].^2;
					sq = sq(find(sq >= N));
					m = sqrt(sq(1));
					n = m;
				end
				
			case ('c')
				m = N;
				n = 1;
				
		end
		
end 
	
