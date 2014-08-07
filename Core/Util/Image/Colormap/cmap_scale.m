function C = cmap_scale(p, X, map)

% cmap_scale - scale colormap to reveal percentile structure
% ----------------------------------------------------------
%
% C = cmap_scale(p, X, map)
%   = cmap_scale(p, hi, map)
%
% Input:
% ------
%  p - percentile points
%  X - data used to scale map
%  hi - image handles
%  map - colormap to scale
%
% Output:
% -------
%  C - percentile scaled colormap

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
% $Revision: 943 $
% $Date: 2005-04-15 18:03:43 -0400 (Fri, 15 Apr 2005) $
%--------------------------------

%-----------------------------------------------
% HANDLE INPUT
%-----------------------------------------------

%--
% set or check data source input
%--

if (nargin < 2) || isempty(X)
	
	X = get_image_handles(gcf);
	
	if isempty(X)
		error('There are no displayed images in figure.');
	end
	
end

% NOTE: empty handles indicate image data input

if all(ishandle(X))
	hi = X; par = get(get(hi(1), 'parent'), 'parent');
else
	hi = []; par = [];
end

%--
% set percentile point vector
%--

% NOTE: these values were empirically hand selected 

if (nargin < 1) || isempty(p)
	
 	p = [ ...
		0, 0.5:0.1:0.7, 0.75:0.05:0.80, 0.825:0.025:0.90, 0.91:0.01:0.99, 0.995, 1 ...
	];
	
end

%--
% set default colormap
%--

if (nargin < 3) || isempty(map)
	
	% NOTE: when the data source is a figure use the figure colormap
	
	if isempty(par)
		
		% NOTE: start from a 'length(p)' inverted gray colormap
		
		RGB = flipud(gray(length(p)));
		
	else
		
		% NOTE: get a 'length(p)' uniformly spaced sample from the parent colormap
		
		RGB = get(par,'Colormap');
		
		ix = round(linspace(1,size(RGB,1),length(p)));
		
		RGB = RGB(ix,:);
		
	end
	
else
	
	%--
	% evaluate function to get colormap
	%--

	if isa(map,'function_handle') || isstr(map)
		
		% NOTE: this exception only affords us a possibly clearer error message

		try
			RGB = feval(map,length(p));
		catch
			error('Unable to create proper length colormap using supplied function.');
		end
		
	%--
	% the input is a colormap, subsample 
	%--
	
	else
		
		% NOTE: we could perform some checks here
		
		RGB = map; 
		
		ix = round(linspace(1,size(RGB,1),length(p)));
		
		RGB = RGB(ix,:);
		
	end
	
end

%-----------------------------------------------
% COMPUTE DATA LIMITS
%-----------------------------------------------

%--
% get data limits from data or image handles
%--

if isempty(hi)

	b = fast_min_max(X);

else

	% NOTE: we also get parent in case we need to set something
	
	par = get(hi(1), 'parent');

	for k = 1:length(hi)
		[a(k), b(k)] = fast_min_max(get(hi(k), 'CData'));
	end
	
	b = [min(a), max(b)];

end

% HACK: we only allow a minimum value of -151

b(1) = max(b(1), -151);

%-----------------------------------------------
% COMPUTE DATA STATISTICS
%-----------------------------------------------

%--
% create percentile scales version of colormap
%--

% NOTE: there may be a reasonable way of sub-sampling the image

if isempty(hi)

	% NOTE: the last input flag maked the histogram computation faster
	
	[h, c] = hist_1d(X, 256, b, [], 1);
	
else
	
	%--
	% compute histograms of data we get from source handles
	%--
	
	for k = 1:length(hi)
	
		temp = vec(get(hi(k), 'CData'));
		
		[h(k,:), c] = hist_1d(temp, 256, b, [], 1); 
	
	end

end

%-----------------------------------------------
% COMPUTE COLORMAP
%-----------------------------------------------

h = sum(h, 1);

h = cumsum(h);

h = h / h(end);

C = [];

for k = 2:length(p)	
	
	m = length(find((h > p(k - 1)) & (h < p(k))));
	
	C = [C; ones(m,1) * RGB(k - 1,:)];
	
end

%--
% set colormap of current figure
%--

if ~nargout && ~isempty(par)
		
	%--
	% check for valid limits
	%--
	
	% TODO: create a cheap warning message function
	
	if (diff(b) < sqrt(eps))
% 		db_disp('WARNING: Color limits should be increasing.'); 
		return;
	end
	
	if any(isnan(b))
% 		disp('WARNING: Color limits contain NAN.'); 
		return;
	end
		
	if any(isinf(b))
% 		disp('WARNING: Color limits contain INF.'); 
		return;
	end
	
	%--
	% update axes color limits and figure colormap
	%--
	
	set(findobj(par, 'type', 'axes'), 'clim', b);
	
	set(ancestor(par, 'figure'), 'colormap', C);
		
end
