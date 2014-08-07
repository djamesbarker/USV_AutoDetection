function h = gmm_display(mix,ax,opt)

% gmm_display - produce display of mixture model
% ----------------------------------------------
%
% opt = gmm_display
% 
% h = gmm_display(mix,ax,opt)
%
% Input:
% ------
%  mix - mixture model to display
%  ax - parent axes
%  opt - display options
%
% Output:
% -------
%  opt - default display options
%  h - handles to geenerated objects

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%---------------------------------------------
% TEST CODE
%---------------------------------------------

if ((nargin < 1) || isstr(mix))
	
	% NOTE: the test function can take the covariance type or all as input
	
	if (isstr(mix))
		test_gmm_display(mix); 
	else
		test_gmm_display('all');
	end
	
	return;
	
end

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% set default options
%--

if ((nargin < 3) || isempty(opt))
	
	%--
	% image display options
	%--
	
	opt.image.on = 1;
	
	opt.image.scale = 'linear';
	
	%--
	% model display options
	%--
	
	% centre display
	
	opt.centre.on = 1;
	
	opt.centre.color = [0.9 0 0]; 
	
	opt.centre.marker = 'o';
	
	% samples display
	
	opt.samples.on = 0;
	
	opt.samples.data = 1000;
	
	opt.samples.color = [1 1 0.9];
	
	opt.samples.marker = '.';
	
	% covariance display
	
	opt.covariance.on = 1;
	
	opt.covariance.color = [0.9 0 0];
	
	opt.covariance.linestyle = ':';
	
	% contours display
	
	opt.contours.on = 1;
	
	opt.contours.color = [0.9 0 0];
	
	opt.contours.linestyle = '-';
	
end

%--
% output display options if needed
%--

if (nargin < 1)
	h = opt; return;
end

%--
% set default axes
%--

if ((nargin < 2) || isempty(ax))
	ax = gca;
end

%---------------------------------------------
% HIGH DIMENSIONAL DISPLAYS ARE RECURSIVE
%---------------------------------------------

if (mix.nin > 2)
	
	% TODO: implement higher dimensional displays recursively
	
end

%---------------------------------------------
% PRODUCE 1D DISPLAY
%---------------------------------------------

% TODO: implement 1-dimensional displays for mixture models

%---------------------------------------------
% PRODUCE 2D DISPLAY
%---------------------------------------------

% TODO: this function currently displays the 2 dimensional mixure model case, generalize

%--
% configure axes hold state and aspect ratio
%--

hold(ax,'on');

ratio = get(ax,'dataaspectratio');

ratio(1:2) = 1;

set(ax,'dataaspectratio',ratio);

%--
% display evaluation
%--

% NOTE: the evaluation domain and resolution should be inputs

if (opt.image.on)
	
	%--
	% create evaluation image, optionally scale
	%-- 
	
	[P,x,y] = gmm_image(mix);

	if (strcmp(opt.image.scale,'log'))
		P = log(P + eps);
	end
	
	%--
	% display image with scaled colormap and fitted to axes
	%--
	
	% NOTE: there is a problem with axes grids and specifying the image parent directly
	
	axes(ax);
	
	h.image = image( ...
		'cdata',P, ...
		'cdatamapping','scaled', ...
		'xdata',x, ... 
		'ydata',y ...
	);

	set(ax, ...
		'xlim',[x(1),x(end)], ...
		'ylim',[y(1),y(end)] ...
	);

end

%--
% display samples
%--

if (opt.samples.on)
	
	% NOTE: data contains either data, or the number of samples to generate
	
	if (length(opt.samples.data) == 1)
		X = gmmsamp(mix,opt.samples.data);
	end
	
	% TODO: implement display of data samples, a simple check on the data passed
	
	h.samples = line( ...
		'parent',ax, ...
		'xdata',X(:,1), ...
		'ydata',X(:,2), ...
		'linestyle','none', ... 
		'marker','.', ...
		'color',opt.samples.color ... 
	);

end

%--
% display model
%--

for k = 1:mix.ncentres
	
	if (opt.centre.on)
		h.model(k).centre = display_centre(mix,k,ax,opt);
	end
	
	if (opt.covariance.on)
		h.model(k).covariance = display_covariance(mix,k,ax,opt);
	end
	
	if (opt.contours.on)
		h.model(k).contours = display_contours(mix,k,ax,opt);
	end
	
end


%---------------------------------------------
% DISPLAY_CENTRE
%---------------------------------------------

function h = display_centre(mix,k,ax,opt)

%--
% display centre
%--

h = line( ...
	'parent',ax, ...
	'xdata', mix.centres(k,1), ...
	'ydata', mix.centres(k,2), ...
	'linestyle','none', ...
	'marker',opt.centre.marker, ...
	'markerfacecolor','none', ...
	'color',opt.centre.color ...
);


%---------------------------------------------
% DISPLAY_COVARIANCE
%---------------------------------------------

function h = display_covariance(mix,k,ax,opt)

%--
% produce display depending on covariance type
%--

switch (mix.covar_type)

	%--
	% spherical covariance
	%--
	
	% NOTE: we represent this in the same way as diagonal
	
	case 'spherical'
		
		% NOTE: skip display of covariance structure
		
		h = []; return;
		
		% NOTE: the x and y variance are the same here
		
		%--
		% x variance
		%--
		
		x = mix.centres(k,1) + mix.covars(k) * [-1, 1];
		y = mix.centres(k,2) * [1, 1];

		h = line( ...
			'parent',ax, ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle',opt.covariance.linestyle, ...
			'marker','none', ...
			'color',opt.covariance.color ...
		);
	
		%--
		% y variance
		%--
		
		x = mix.centres(k,1) * [1, 1];
		y = mix.centres(k,2) + mix.covars(k) * [-1, 1];

		h = line( ...
			'parent',ax, ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle',opt.covariance.linestyle, ...
			'marker','none', ...
			'color',opt.covariance.color ...
		);

	%--
	% diagonal covariance
	%--
	
	case 'diag'

		%--
		% x variance
		%--
		
		x = mix.centres(k,1) + mix.covars(k,1) * [-1, 1];
		y = mix.centres(k,2) * [1, 1];

		h = line( ...
			'parent',ax, ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle',opt.covariance.linestyle, ...
			'marker','none', ...
			'color',opt.covariance.color ...
		);
	
		%--
		% y variance
		%--
		
		x = mix.centres(k,1) * [1, 1];
		y = mix.centres(k,2) + mix.covars(k,2) * [-1, 1];

		h = line( ...
			'parent',ax, ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle',opt.covariance.linestyle, ...
			'marker','none', ...
			'color',opt.covariance.color ...
		);

	%--
	% full covariance
	%--
	
	case ('full')
		
		%--
		% compute principal axes of covariance
		%--
		
		[V,D] = eig(mix.covars(:,:,k)); d = diag(D);
		
		%--
		% first axis variance
		%--
		
		x = mix.centres(k,1) + d(1) * V(1,1) * [-1, 1];
		y = mix.centres(k,2) + d(1) * V(2,1) * [-1, 1];

		h = line( ...
			'parent',ax, ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle',opt.covariance.linestyle, ...
			'marker','none', ...
			'color',opt.covariance.color ...
		);
	
		%--
		% second axis variance
		%--
		
		x = mix.centres(k,1) + d(2) * V(1,2) * [-1, 1];
		y = mix.centres(k,2) + d(2) * V(2,2) * [-1, 1];

		h = line( ...
			'parent',ax, ...
			'xdata', x, ...
			'ydata', y, ...
			'linestyle',opt.covariance.linestyle, ...
			'marker','none', ...
			'color',opt.covariance.color ...
		);

	case ('ppca')
		
		h = [];

	otherwise
		
		error(['Unknown covariance type ', mix.covar_type]);

end


%---------------------------------------------
% DISPLAY_CONTOURS
%---------------------------------------------

function h = display_contours(mix,k,ax,opt)

%--
% get points on a circle
%--

N = 512; 

P = circle_points(N);

%--
% create contours
%--

switch (mix.covar_type)

	%--
	% spherical covariance
	%--
	
	case ('spherical')
		
		%--
		% scale and shift points on circle
		%--
		
		P = (mix.covars(k) * P) + mix.centres(k,:)' * ones(1,N);
		
		%--
		% display one deviation contour
		%--
		
		h = line( ...
			'parent',ax, ...
			'xdata', P(1,:)', ...
			'ydata', P(2,:)', ...
			'linestyle',opt.contours.linestyle, ...
			'marker','none', ...
			'color',opt.contours.color ...
		);

	%--
	% diagonal covariance
	%--
	
	case ('diag')
		
		%--
		% scale and shift points on circle
		%--
		
		P = (diag(mix.covars(k,:)) * P) + mix.centres(k,:)' * ones(1,N);
		
		%--
		% display one deviation contour
		%--
		
		h = line( ...
			'parent',ax, ...
			'xdata', P(1,:), ...
			'ydata', P(2,:), ...
			'linestyle',opt.contours.linestyle, ...
			'marker','none', ...
			'color',opt.contours.color ...
		);
		
	%--
	% full covariance
	%--
	
	case ('full')
		
		%--
		% scale, rotate, and shift points on circle
		%--
		
		P = (mix.covars(:,:,k) * P) + mix.centres(k,:)' * ones(1,N);
		
		%--
		% display one deviation contour
		%--
		
		h = line( ...
			'parent',ax, ...
			'xdata', P(1,:), ...
			'ydata', P(2,:), ...
			'linestyle',opt.contours.linestyle, ...
			'marker','none', ...
			'color',opt.contours.color ...
		);

	case ('ppca')
		
		h = [];

	otherwise
		
		error(['Unknown covariance type ', mix.covar_type]);

end


%---------------------------------------------
% CIRCLE_POINTS
%---------------------------------------------

function P = circle_points(n)

%--
% compute equispaced points on the unit circle
%--

P = exp(2 * pi * i * linspace(0,1,n));

%--
% separate real and imaginary parts
%--

P = [real(P); imag(P)];



%---------------------------------------------
% TEST_GMM_DISPLAY
%---------------------------------------------

function test_gmm_display(covar_type)

TOL = 0.125;

%--
% set all flag
%--

if (strcmpi(covar_type,'all'))
	flag = 1;
else
	flag = 0;
end

%--
% number of centres sequence
%--

if (flag)
	seq = 4:8;
	rep = 2;
else
	seq = 2:8;
	rep = 4;
end

%---
% spherical models
%--

if (strcmpi(covar_type,'spherical') || flag)
	
	for k = seq
	for j = 1:rep

		%--
		% create random spherical model
		%--

		mix = gmm(2,k,'spherical');
		mix.centres = 1.5 * randn(k,2);
		mix.covars = rand(1,k) + TOL;

		%--
		% display in new figure
		%--

		fig; gmm_display(mix); 
		colormap(flipud(bone)); cmap_scale;
		title(['SPHERICAL (N = ', int2str(k), ')']);
		drawnow;

	end
	end

end

%---
% diagonal models
%--

if (strcmpi(covar_type,'diag') || flag)

	for k = seq
	for j = 1:rep

		%--
		% create random spherical model
		%--

		mix = gmm(2,k,'diag');
		mix.centres = 1.5 * randn(k,2);
		mix.covars = rand(k,2) + TOL;

		%--
		% display in new figure
		%--

		fig; gmm_display(mix); 
		colormap(flipud(bone)); cmap_scale;
		title(['DIAG (N = ', int2str(k), ')']);
		drawnow;

	end
	end

end

%---
% full models
%--

if (strcmpi(covar_type,'full') || flag)

	for k = seq
	for j = 1:rep

		%--
		% create random spherical model
		%--

		mix = gmm(2,k,'full');
		mix.centres = 1.5 * randn(k,2);
		for k = 1:mix.ncentres
			mix.covars(:,:,k) = randsym(mix.nin,rand(1,mix.nin) + TOL);
		end

		%--
		% display in new figure
		%--

		fig; gmm_display(mix); 
		colormap(flipud(bone)); cmap_scale;
		title(['FULL (N = ', int2str(k), ')']);
		drawnow;

	end
	end
	
end

