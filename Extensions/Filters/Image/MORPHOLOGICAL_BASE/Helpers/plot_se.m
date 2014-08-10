function plot_se(pal,param)

% plot_se - produce mask plot in filter palette
% -----------------------------------------------
%
% plot_se(pal,param)
%
% Input:
% ------
%  pal - control palette handle
%  param - mask parameters

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

%------------------------------------
% CONSTANTS
%------------------------------------

% NOTE: colormap and line display colors

IMAGE_COLOR = gray(2);

% LINE_COLOR = [0.8, 0.8, 0.4];

LINE_COLOR = 0.75 * [0.8, 0.9, 1]; % NOTE: hue matches the control flash color

%------------------------------------
% CREATE MASK IMAGE
%------------------------------------

% NOTE: create and pad structuring element

SE = create_se(param);

% TODO: reconsider padding depending on size to keep proportions

[m,n] = size(SE);

if (m < n)
	
	p = ceil((n - m) / 2);
	SE = [zeros(p,n); SE; zeros(p,n)];
	
elseif (m > n)	
	
	p = ceil((m - n) / 2);
	SE = [zeros(m,p), SE, zeros(m,p)];
	
end

temp = zeros(size(SE) + 2);

temp(2:end - 1,2:end -1) = SE;

SE = temp;

[M,N] = size(SE);

%------------------------------------
% DISPLAY IMAGE
%------------------------------------

%--
% clear previously displayed elements
%--

delete(findobj(pal,'tag','DELETE_ME'));

%--
% set axes for display
%--

ax = findobj(pal,'tag','mask_plot','type','axes');

axes(ax); hold on;

% NOTE: we need to know the visibility to solve a tab related problem

visible = get(ax,'visible');

%--
% display image
%--

tmp = imagesc(SE);

set(tmp,'tag','DELETE_ME'); % tag for later deletion

% update axes properties to handle image changing size

set(ax, ...
	'box','on', ...
	'dataaspectratio',ones(1,3), ...
	'xlim',[0.5, N + 0.5], ...
	'ylim',[0.5, M + 0.5], ...
	'yaxislocation','right' ...
);

%--
% set colormap
%--

colormap(IMAGE_COLOR);

%------------------------------------
% DISPLAY SIZE INDICATORS
%------------------------------------

%--
% add label with filter support information
%--

fontsize = get(findobj(pal,'tag','width','style','text'),'fontsize');

temp = ylabel([int2str(m) ' X ' int2str(n)]);

set(temp, ...
	'fontunits','pixels', ...
	'fontsize',1.1 * fontsize ...
);

%--
% display mask boundaries
%--

xl = 0.5 * (N - n + 1); 
xr = 0.5 * (N + n + 1);

x = [xl, xr, xr, xl, xl];

yl = 0.5 * (M - m + 1);
yh = 0.5 * (M + m + 1);

y = [yl, yl, yh, yh, yl];

temp = plot(x,y,':');

set(temp, ...
	'color',LINE_COLOR, ...
	'tag','DELETE_ME' ...
);

%--
% display mask center
%--

temp = plot((N - 1)/2 + 1,(M - 1)/2 + 1,'o');

set(temp, ...
	'color',LINE_COLOR, ...
	'tag','DELETE_ME' ...
);

%--
% reset axes visibility
%--

% NOTE: retain axes visibility when they are in a hidden tab

set(ax,'visible',visible);
