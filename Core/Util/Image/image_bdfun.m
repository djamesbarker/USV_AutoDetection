function image_bdfun(h,str)

% image_bdfun - axes selection display for image viewing
% ------------------------------------------------------
%
% image_bdfun(h)
%
% Input:
% ------
%  h - handle to figure (def: gcf)

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
% $Date: 2003-07-06 13:36:53-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% set figure and command string if needed
%--

switch (nargin)
	
case (0)
	h = gcf;
	str = 'Initialize';
case (1)
	str = 'Initialize';
	
end
	
%--
% set bdfun or highlight axes
%--

switch (str)
	
%--
% set bdfun
%--

case ('Initialize')
	
	set(h,'windowbuttondownfcn',['image_bdfun(gcf,''highlight'');']);
	
%--
% highlight current axes
%--

case ('highlight')
	
% 	% get all axes handles
% 	
% 	axs = findobj(h,'type','axes');
% 	
% 	% make all axes normal
% 	
% 	for k = 1:length(axs)
% 		ax = axs(k);
% 		set(ax,'linewidth',0.5);
% 		set(get(ax,'title'),'fontweight','normal');
% 		set(get(ax,'xlabel'),'fontweight','normal');
% 		set(get(ax,'ylabel'),'fontweight','normal');
% 	end
% 	
% 	% get image axes handles
% 	
% 	im = get_image_handles(h);
% 	clear axs;
% 	for k = 1:length(im);
% 		axs(k) = get(im(k),'parent');
% 	end 
% 	
% 	% highlight current image axes
% 	
% 	ax = gca;
% 	if (any(axs == ax))
% 		set(ax,'linewidth',2);
% 		set(get(ax,'title'),'fontweight','bold');
% 		set(get(ax,'xlabel'),'fontweight','bold');
% 		set(get(ax,'ylabel'),'fontweight','bold');
% 	end
	
end
