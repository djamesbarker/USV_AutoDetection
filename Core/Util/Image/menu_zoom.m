% Fragment of code to link zooming of images in different figures
% linked zooming of images in same figure may also be useful,
% however generally multiple images in one figure is not a great idea

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
% get figures with image menus
%--

h = findobj(0,'type','figure');

% keep figures with image menus

for k = length(h):-1:1
	if (~isfield(get(h(k),'userdata'),'image_menu'))
		h(k) = [];
	end
end

%--
% create name strings
%--

for k = 1:length(h)
	
	% standard figure name
	
	t = ['Figure No. ' num2str(h(k))];
	
	% append name
	
	n = get(h(k),'Name');
	if (~isempty(n))
		t = [t ': ' n];
	end
	
	L{k} = t;
	
end

%--
% create uimenu for
%--


