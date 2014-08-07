function [g, h] = scatter_matrix(par, X, name, id)

% scatter_matrix - prototype for plotting and selection
% -----------------------------------------------------
%
% scatter_matrix(X, name, id)
%
% Input:
% ------
%  X - data to plot
%  name - column names
%  id - row id numbers
%
% Output:
% -------
%  g - support axes handle
%  h - plot axes handles

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
% $Revision: 5706 $
% $Date: 2006-07-13 17:32:20 -0400 (Thu, 13 Jul 2006) $
%--------------------------------


% TODO: create a more complete data structure to support talking to the parent
% that is the data source

% TODO: consider multiple selection behavior, there are two simple 
% approaches to dealing with creating more complex selections polygons 
% and selection sets.

% TODO: add zooming on each variable, this requires rows and columns zoom
% together

% NOTE: that the current axes labelling approach is not working


%-------------------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------------------

%--
% check shape of data
%--

if (ndims(X) > 2)
	error('Only data matrices are supported.');
end

[m, n] = size(X);

%--
% create id values if needed
%--

if (nargin < 4) || isempty(id)
	id = 1:m;
end

%--
% create names if needed
%--

if (nargin < 3) || isempty(name)
	for k = 1:n
		name{k} = ['X', int2str(k)];
	end
end

%--
% create parent if needed
%--

if isempty(par)
	par = fig;
end

%-------------------------------------------------------------
% CREATE PLOT
%-------------------------------------------------------------

%--
% create axes
%--

% TODO: replace this with a call to 'harray'

p = axes_array;

p.top = 0.05; p.bottom = 0.075;

p.left = 0.05; p.right = 0.05;

p.xspace = 0.05; p.yspace = 0.05;

[h, g] = axes_array(n, n, p, par);

%--
% plot data
%--

for i = 1:n
	
	for j = 1:n

		%--
		% diagonal elements of scatter matrix
		%--

		% TODO: replace this display with a scatter distribution display

		if (i == j)

			text(0.5, 0.5, name{i}, ...
				'parent', h(i,j), ...
				'horizontalalignment', 'center', ...
				'tag', 'SCATTER_DATA_NAME' ...
			);

			set(h(i,j), ...
				'visible','off' ...
			);

		%--
		% off-diagonal elements of display
		%--

		else

			line(X(:,j), X(:,i), ...
				'parent', h(i,j), ...
				'hittest', 'off', ...
				'linestyle', 'none', ... 
				'marker', 'o', ...
				'markersize', 4 ...
			);

			if (j > i)
				set(h(i,j), ...
					'xaxislocation','top', ...
					'yaxislocation','right' ...
				);
			end

		end

	end
	
end

%--
% set button down function
%--

set(h, 'buttondownfcn', @scatter_matrix_bdfun);

%--
% handle axes scaling
%--

if (0)
	
	%--
	% global scaling of axes
	%--
	
	range = fast_min_max(X);
	
	if ~diff(range)
		range = range + [-1 1];
	end
		
	for k = 1:n
		set(h(:,k), 'xlim', range); set(h(k,:), 'ylim', range);
	end
	
else
	
	%--
	% per variable scaling of axes
	%--
	
	for k = 1:n
		
		range = fast_min_max(X(:,k));
		
		if ~diff(range)
			range = range + [-1 1];
		end
		
		set(h(:,k), 'xlim', range); set(h(k,:), 'ylim', range);
		
	end
	
end

%--
% set other axes properties
%--

set(h,'box','on');

set(h(2:end - 1,:), 'xticklabel', []); set(h(:,2:end - 1), 'yticklabel', []);

%--
% change diagonal axes
%--

set(diag(h), ...
	'buttondownfcn', '', ...
	'xlim', [0, 1], ...
	'ylim', [0, 1] ...
);

%-------------------------------------------------------------
% STORE PLOT DATA IN FIGURE
%-------------------------------------------------------------

data = get(par, 'userdata');

data.scatter_matrix.X = X; 

data.scatter_matrix.name = name;

data.scatter_matrix.id = id;

set(par, 'userdata', data);
