function zoom_linked(h,t)

% zoom_linked - zoom all axes in figure together
% ----------------------------------------------
%
% zoom_linked(h,t)
%
% Input:
% ------
%  h - handle to figure
%  t - type of zoom 'x', 'y', 'xy', or 'off'

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
% $Revision: 1.18 $
% $Date: 2003-02-18 17:43:21-05 $
%--------------------------------

%--
% set type
%--

if (nargin < 2)
	t = 'xy';
end

%--
% set figure
%--

if (nargin < 1)
	h = gcf;
end

%--
% set figure windowbuttondownfcn according to type
%--

switch (t)

% zoom in x

case ('x')
	
	str = [ ...
		'zoom(gcbf,''xdown'');' ...
		'ax = gca;' ...
		'axs = findobj(gcf,''type'',''axes'');' ...
		'cb = findobj(gcf,''type'',''axes'',''tag'',''Colorbar'');' ...
		'axs = setdiff(axs,cb);' ...
		'set(axs,''xlim'',get(ax,''xlim''));' ...
		'refresh(gcf);' ...
	];
% 		'tag = get(ax,''tag''), xlim = get(ax,''xlim'')', ... % debug code

	set(h,'windowbuttondownfcn',str);

% zoom in y

case ('y')
	
	str = [ ...
		'zoom(gcbf,''ydown'');' ...
		'ax = gca;' ...
		'axs = findobj(gcf,''type'',''axes'');' ...
		'cb = findobj(gcf,''type'',''axes'',''tag'',''Colorbar'');' ...
		'axs = setdiff(axs,cb);' ...
		'set(axs,''ylim'',get(ax,''ylim''));' ...
		'refresh(gcf);' ...
	];
	set(h,'windowbuttondownfcn',str);

% zoom in x and y

case ('xy')
	
	str = [ ...
		'zoom(gcbf,''down'');' ...
		'ax = gca;' ...
		'axs = findobj(gcf,''type'',''axes'');' ...
		'cb = findobj(gcf,''type'',''axes'',''tag'',''Colorbar'');' ...
		'axs = setdiff(axs,cb);' ...
		'set(axs,''xlim'',get(ax,''xlim''));' ...
		'set(axs,''ylim'',get(ax,''ylim''));' ...
		'image_bdfun(gcf,''highlight''); refresh(gcf);' ...	% change to accomodate axes highlighting
	];
	set(h,'windowbuttondownfcn',str);

% zoom off

case ('off')
	
	set(h,'windowbuttondownfcn',['image_bdfun(gcf,''highlight'');']); % change to accomodate axes highlighting
	
end
	
	

