function image_kpfun(h)

% image_kpfun - key press function for image figure
% -------------------------------------------------
%
% image_kpfun(h)
%
% Input:
% ------
%  h - handle of figure

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
% attach to figure
%--

if (nargin)
	set(h,'keypressfcn','image_kpfun;');
end

%--
% get current character
%--

n = double(get(gcf,'currentcharacter'));

%--
% escape empty characters
%--

if (isempty(n))
	return;
end

%--
% perform command
%--

switch (n)
	
%--
% Zoom
%--

case (double('z'))
	image_menu(gcf,'Zoom');
	
case (double('Z'))
	image_menu(gcf,'Zoom Range ...');
	
%--
% Grid
%--

case (double(':'))
	image_menu(gcf,'Grid');
	
%--
% Colormap
%--

case (double('G'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Grayscale')))
		image_menu(gcf,'Grayscale');
	end
	
case (double('H'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Hot')))
		image_menu(gcf,'Hot');
	end
	
case (double('J'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Jet')))
		image_menu(gcf,'Jet');
	end
	
case (double('B'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Bone')))
		image_menu(gcf,'Bone');
	end
	
case (double('V'))
	if (~isempty(findobj(gcf,'type','uimenu','label','HSV')))
		image_menu(gcf,'HSV');
	end
	
case (double('R'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Real')))
		image_menu(gcf,'Real');
	end
	
%--
% Colormap Options
%--

case (double('c'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Colorbar')))
		image_menu(gcf,'Colorbar');
	end

case (double('i'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Invert')))
		image_menu(gcf,'Invert');
	end
	
case (double('d'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Darken')))
		image_menu(gcf,'Darken');
	end
	
case (double('b'))
	if (~isempty(findobj(gcf,'type','uimenu','label','Brighten')))
		image_menu(gcf,'Brighten');
	end
	
%--
% Display Size
%--

case (double('h'))
	image_menu(gcf,'Half Size');
	
case (double('x'))
	image_menu(gcf,'Normal Size');
	
%--
% Rotation, flipping and stack navigation
%--
	
% back arrow
case (28)
	if (isempty(findobj(gcf,'type','uimenu','Label','Stack')))
		image_menu(gcf,'Rotate Left');
	else
		stack_menu(gcf,'Previous Frame');
	end
	
% forward arrow
case (29)
	if (isempty(findobj(gcf,'type','uimenu','Label','Stack')))
		image_menu(gcf,'Rotate Right');
	else
		stack_menu(gcf,'Next Frame');
	end
	
% up arrow
case (30)
	if (isempty(findobj(gcf,'type','uimenu','Label','Stack')))
		image_menu(gcf,'Flip Horizontal');
	else
		stack_menu(gcf,'First Frame');
	end
	
% down arrow
case (31)
	if (isempty(findobj(gcf,'type','uimenu','Label','Stack')))
		image_menu(gcf,'Flip Vertical');
	else
		stack_menu(gcf,'Slide Show');
	end
	
%--
% contour
%--

case ('C')
	image_menu(gcf,'Contour');
	
	
end
