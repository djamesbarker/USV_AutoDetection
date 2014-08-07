function h = splash_image(f, t)

% splash_image - display image as splash screen
% ---------------------------------------------
% 
% h = splash_image(f, t)
%
% Input:
% ------
%  f - image filename or filenames
%  t - time to display image
%
% Output:
% -------
%  h - figure handle
%  f - filename of image displayed

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
% $Revision: 6472 $
% $Date: 2006-09-11 18:11:43 -0400 (Mon, 11 Sep 2006) $
%--------------------------------

% NOTE: status bar of splash image is in progress

%--
% set time
%--

if (nargin < 2)
	t = 3;
end 

%--
% select image if needed
%--

if iscell(f)
	ix = round((length(f) - 1) * rand(1)) + 1;
	f = f{ix};
end

%--
% read image from file
%--

X = imread(f);

m = size(X,1); n = size(X,2);

%--
% compute status bar fraction
%--

BAR = 24;
p = BAR / m;

%--
% create figure and display image
%--

h = figure;

set(h, ...
	'menubar','none', ...
	'numbertitle','off', ...
	'resize','off', ...
	'backingstore','on', ...
	'name','' ...
);

% 'visible','off', ...

hi = image(X);

set(gca, ...
	'visible','on', ...
	'units','normalized', ...
	'xcolor',get(h,'color'), ...
	'ycolor',get(h,'color'), ...
	'position',[0 p 1 (1 - p)], ...
	'xtick',[], ...
	'ytick',[] ...
);

%--
% create status bar axes
%--

ax = axes( ...
	'position', [0 0 1 p], ...
	'xtick', [], ... 
	'ytick', [], ...
	'box', 'on', ...
	'color', get(0,'defaultuicontrolbackgroundcolor') ...
);

pos = get(h,'position'); 
pos(3:4) = [n, (m + BAR)];

set(h,'position',pos);

% truesize;

%--
% wait, or set buttondown function
%--

if (t > 0)
	pause(t);
	close(h);
else
	set(hi,'buttondownfcn','closereq;');
end
