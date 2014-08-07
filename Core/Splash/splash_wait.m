function pal = splash_wait(file, ticks)

% splash_wait - splash screen with waitbar
% ----------------------------------------
%
% pal = splash_wait(file, ticks)
%
% Input:
% ------
%  file - splash image file
%  ticks - number of ticks
%
% Output:
% -------
%  pal - figure handle

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

%------------------
% HANDLE INPUT
%------------------

%--
% set default number of ticks
%--

% NOTE: this is never used

if nargin < 2
	ticks = 1;
end

%--
% set default image and check we can find image file
%--

if (nargin < 1) || isempty(file)
	file = select_splash;
end

if ~exist(file, 'file')
	error('Unable to find splash image file.');
end

%------------------
% SETUP
%------------------

%--
% get image info
%--

info = imfinfo(file);

%--
% compute palette options
%--

% NOTE: get tile size in pixels

opt = waitbar_group;

opt.width = (info.Width / opt.tilesize);

opt.progress_header = 0;

opt.left = 0; opt.right = 0; opt.bottom = 0;

%--
% compute image height
%--

lines = info.Height / opt.tilesize;

width = (opt.width - 2) / opt.width;

%------------------
% CREATE WAIT
%------------------

%--
% create controls
%--

control = empty(control_create);
	
control(end + 1) = control_create( ...
	'name', 'image', ...
	'style', 'axes', ...
	'label', 0, ...
	'onload', 1, ...
	'space', 0.5, ...
	'callback', {@add_image, file}, ... 
	'lines', lines ...
);

control(end + 1) = control_create( ...
	'name', 'PROGRESS', ...
	'style', 'waitbar', ...
	'width', width, ...
	'lines', 0.5, ...
	'align', 'center', ...
	'confirm', 1, ...
	'space', 1.75 ...
);

%--
% render waitbar
%--

% pal = waitbar_group('', control, [], [], opt);

pal = control_group([], [], '', control, opt);

set(pal, ...
	'tag', 'XBAT_WAITBAR::splash' ...
);

position_palette(pal, 0, 'center');

%--
% update display
%--

color = 1.1 * [212, 121, 40] / 255;

waitbar_update(pal, 'PROGRESS', 'color', color);

waitbar_update(pal, 'PROGRESS', 'message', 'LOADING ...');

%--
% add tick state
%--

set_ticks(pal, ticks);

%--
% test code
%--

if ~nargout && ~nargin
	
	for k = linspace(0, 1, 100)
		
		% NOTE: consider developing a smarter 'update' response, then use it
		
		update = waitbar_update(pal, 'PROGRESS', 'value', k); pause(0.05);
		
		if ~update
			return;
		end
		
	end

end


%---------------------------------
% ADD_IMAGE
%---------------------------------

function handle = add_image(obj, eventdata, file)

%--
% load image
%--

I = imread(file); N = size(I);

%--
% display image
%--

xlim = [0, N(2)]; ylim = [0, N(1)];

set(obj, 'xlim', xlim, 'ylim', ylim);

handle = image(xlim, ylim, I, 'parent', obj);

set(handle, 'hittest', 'off');

color = 0.5 * ones(1,3);

set(obj, ...
	'xtick', [], 'ytick', [], ...
	'xcolor', color, 'ycolor', color ...
);

%--
% display version and perhaps license 
%--

% % NOTE: this should not be hard-coded
% 
% x = N(2) - 24; y = 28;
% 
% handle = text(x, y, xbat_version, ...
% 	'parent', obj, ...
% 	'hittest', 'off', ...
% 	'fontweight', 'normal', ...
% 	'horizontalalignment', 'right' ...
% );

%--
% update callback
%--

% NOTE: this may not be the best option

set(obj, 'buttondownfcn', @close_parent);


%---------------------------------
% CLOSE_PARENT
%---------------------------------

function close_parent(obj, eventdata)

par = ancestor(obj, 'figure'); close(par);


%---------------------------------
% SET_TICKS
%---------------------------------

function set_ticks(pal, ticks)

data = get(pal, 'userdata');

tick.value = linspace(0, 1, ticks + 1); tick.pos = 1; data.tick = tick;

set(pal, 'userdata', data);


%---------------------------------
% SELECT_SPLASH
%---------------------------------

function file = select_splash(ratio)

%--
% set default screen to image ratio
%--

if ~nargin
	ratio = 2.5;
end

%--
% get screen size
%--

screen = get_size_in(0, 'px', 1);

%--
% get candidate images and widths
%--

root = [fileparts(mfilename('fullpath')), filesep, 'Images'];

files = what_ext(root, 'png'); files = files.png;

widths = zeros(size(files));

for k = 1:length(files)
	info = imfinfo([root, filesep, files{k}]); widths(k) = info.Width;
end

%--
% select file closest to desired ratio
%--

[ignore, ix] = min(abs(widths - (screen.width / ratio)));

file = [root, filesep, files{ix}];






