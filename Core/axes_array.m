function [h, g] = axes_array(m,n,layout,par)

% axes_array - create an array of axes
% ------------------------------------
%
%       [h, g] = axes_array(m,n,layout,par)
%
%  [pos, size] = axes_array(m,n,layout)
%
%       layout = axes_array
%
% Input:
% ------
%  m - rows 
%  n - columns
%  layout - layout options
%  par - parent handle
%
% Output:
% -------
%  h - array axes handle
%  g - support axes handle
%  pos - array axes positions
%  layout - default layout options
%
% NOTE: positions are all in normalized units

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
% $Revision: 7011 $
% $Date: 2006-10-12 18:28:31 -0400 (Thu, 12 Oct 2006) $
%--------------------------------

% TODO: make use of the parent figure input argument when creating axes

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set default parent
%--

if ((nargin < 4) || isempty(par))
	par = gcf;
end

%--
% set default layout parameters
%--

if ((nargin < 3) || isempty(layout))
	
	%--
	% default layout parameters
	%--

	% NOTE: these are normalized units
	
	layout.top = 0.05;
	
	layout.bottom = 0.075;

	layout.left = 0.075;
	
	layout.right = 0.075;

	layout.xspace = 0.025;
	
	layout.yspace = 0.025;

	%--
	% possibly return layout options
	%--

	if (~nargin)
		h = layout; return;
	end

end

%--
% compute size of axes in array
%--

x = (1 - ((n - 1) * layout.xspace) - (layout.left + layout.right)) / n;

y = (1 - ((m - 1) * layout.yspace) - (layout.top + layout.bottom)) / m;

%---------------------------------------
% CREATE AXES ARRAY
%---------------------------------------

if (nargin > 3)
	
	%--
	% create invisible support axes
	%--
	
	pos = [ ...
		layout.left, ...
		layout.bottom, ...
		1 - (layout.left + layout.right), ...
		1 - (layout.top + layout.bottom) ...
	];
	
	g = axes( ...
		'parent',par, ...
		'position',pos ...
	);

	% NOTE: set support axes properties, including a 'support' tag
	
	set(g, ...
		'visible','off', ...
		'hittest','off', ...
		'xtick',[], ...
		'ytick',[], ...
		'tag','support' ...
	);
	
	%--
	% build state information to store in support axes
	%--
	
	data = get(g,'userdata');
	
	data.row = m; 
	
	data.col = n; 
	
	data.pos = layout;
		
	data.colorbar = findobj(par,'type','axes','tag','Colorbar');
	
	%--
	% create visible axes array
	%--
	
	h = zeros(m,n);

	for j = 1:n
		for i = 1:m

			pos = [ ...
				((j - 1) * (x + layout.xspace)) + layout.left, ...
				1 - (i * (y + layout.yspace)) + layout.yspace - layout.top, ...
				x, ...
				y ...
			];

			h(i,j) = axes( ...
				'parent',par, ...
				'position', pos, ...
				'userdata',[i,j] ...
			);

		end
	end

	%--
	% add children handles to state and store state
	%--
	
	data.child = h;
	
	set(g,'userdata',data);
	
%---------------------------------------
% COMPUTE AXES POSITIONS
%---------------------------------------

else

	%--
	% compute array axes positions
	%--
	
	h = cell(m, n);

	for j = 1:n
		for i = 1:m

			h{i, j} = [ ...
				((j - 1) * (x + layout.xspace)) + layout.left, ...
				1 - (i * (y + layout.yspace)) + layout.yspace - layout.top, ...
				x, ...
				y ...
			];

		end
	end

	g = [x, y];

end
