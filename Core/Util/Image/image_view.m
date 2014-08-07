function h = image_view(X,N,b,C)

% image_view - view an image
% --------------------------
%
% h = image_view(X,N,b,C)
%
% Input:
% ------
%  X - input image or image stack
%  N - image name or frame names
%  b - bounds for display values
%  C - colormap for display (def: gray)
%
% Output:
% -------
%  h - handle to axes

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
% $Revision: 586 $
% $Date: 2005-02-22 14:22:50 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%-------------------------------------------------------
% INITIALIZATION
%-------------------------------------------------------

%--
% set or create axes
%--

h = gca;

%--
% crate tag for image data
%--

tag = image_tag(X);

%-------------------------------------------------------
% DISPLAY
%-------------------------------------------------------

switch (tag)

	%----------------------------------------
	% SCALAR IMAGE
	%----------------------------------------

	case ({'IMAGE_GRAY','IMAGE_GRAY_U8','IMAGE_GRAY_LOGICAL'})

		%--
		% set default colormap
		%--

		if (nargin < 4)
			C = gray(256);
		end

		%--
		% display image
		%--

		if ((nargin < 3) | isempty(b))
			g = imagesc(X);
		else
			g = imagesc(X,b);
		end

		axis('image');

		colormap(C);

		%--
		% set image properties and tag
		%--

		set(g,'erasemode','none');
		
		set(g,'tag',tag);

		%--
		% annotate display
		%--

		if ((nargin < 2) | isempty(N))
			
			if (~isempty(inputname(1)))
				N = inputname(1);
			else
				N = 'X';
			end
			
		end

		title_edit(N);
		
		refresh;

	%----------------------------------------
	% RGB IMAGE
	%----------------------------------------

	case ({'IMAGE_RGB','IMAGE_RGB_U8'})

		%--
		% create valid uint8 image for color display
		%--

		X = uint8(lut_range(X));

		%--
		% display image
		%--

		g = image(X);

		axis('image');

		%--
		% set special  properties
		%--

		set(g,'EraseMode','none');
		set(g,'tag',tag);

		%--
		% annotate display
		%--

		if ((nargin < 2) | isempty(N))

			if (~isempty(inputname(1)))
				N = inputname(1);
			else
				N = 'X';
			end

		end

	%----------------------------------------
	% N-DIMENSIONAL IMAGE
	%----------------------------------------

	case ({'IMAGE_NDIM','IMAGE_NDIM_U8'})

		%--
		% convert n-dimensional image to stack and create plane names
		%--

		X = nd_to_stack(X);

		tmp = N;

		for k = 1:length(X)
			N{k} = [tmp '(:,:,' num2str(k) ')'];
		end

		%--
		% display image as stack
		%--

		h = stack_view(X,N);

		return;

	%----------------------------------------
	% IMAGE STACK
	%----------------------------------------

	case ('IMAGE_STACK')

		if (nargin < 4)
			C = gray(256);
		end

		if (nargin > 1)
			h = stack_view(X,N);
		else
			h = stack_view(X);
		end

		return;

end

%--
% set black figure background
%--

f = gcf;

set(f,'Color',[0, 0, 0]);

%--
% add browser structure to support palettes
%--

data = get(f,'userdata');

data.browser.palettes = [];

data.browser.palette_states = [];

set(f,'userdata',data);

%--
% create image view menus
%--

image_menu(f);

image_window_menu(f);

%--
% update menu state according to image type and input
%--

if (strcmp(tag(1:9),'IMAGE_GRA'))

	%--
	% set number of levels
	%--

	image_menu(f,num2str(length(C)));

	%--
	% set grayscale colormap
	%--

	if (nargin < 3)
		image_menu(f,'Grayscale');
	end

else

	% 	%--
	% 	% remove colormap options for rgb images
	% 	%--
	%
	% 	data = get(gcf,'userdata');
	%
	% 	% remove colormaps
	%
	% 	tmp = get_menu(gcf,'Colormap');
	%
	% 	if (~isempty(tmp))
	% 		ix = find(data.image_menu.h.image == tmp);
	% 		data.image_menu.h.image(ix) = [];
	% 		delete(tmp);
	% 	end
	%
	% 	% remove colormap options
	%
	% 	tmp = get_menu(gcf,'Colormap Options');
	%
	% 	if (~isempty(tmp))
	% 		ix = find(data.image_menu.h.image == tmp);
	% 		data.image_menu.h.image(ix) = [];
	% 		delete(tmp);
	% 	end
	%
	% 	set(gcf,'userdata',data);

end

%--
% add key press function
%--

image_kpfun(f);

%--
% set doublebuffer on to reduce flickering
%--

set(f,'doublebuffer','on');


