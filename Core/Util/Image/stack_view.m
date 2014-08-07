function h = stack_view(X,N)

% stack_view - view an image stack
% --------------------------------
%
% h = stack_view(X,N)
%
% Input:
% ------
%  X - image stack
%  N - image names
%
% Output:
% -------
%  h - handle to axes

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
% $Revision: 1.0 $
% $Date: 2003-07-06 13:36:40-04 $
%--------------------------------

%--
% check stack input
%--

if (~is_stack(X))
	disp(' ');
	error('Input is not a valid image stack.');
end

%--
% get length of stack
%--

n = length(X);

%--
% set default names
%--

if (nargin < 2)
	for k = 1:n
		N{k} = ['Frame ' num2str(k)];
	end
end

%--
% view first frame
%--

% compute stack global clim bounds

b = stack_oper(X,'fast_min_max');

m = stack_oper(b,'min'); 
M = stack_oper(b,'max');

bg = [m(1) M(2)];

h = image_view(X{1},[],b{1}); % creates image viewing menu

%--
% attach stack to image and tag image
%--

g = findobj(h,'type','image');

data.X = X;
data.N = N;
data.bounds.frame = b; % frame value bounds
data.bounds.stack = bg; % stack value bounds

tag = image_tag(X);

set(g,'userdata',data);
set(g,'tag',tag);

% put type and size in xlabel

% xlabel_edit(['(' tag ', ' num2str(size(X{1},2)) ' x ' num2str(size(X{1},1)) ')']);

%--
% setup stack viewing menu
%--

stack_menu(gcf);

%--
% set doublebuffer on
%--

set(gcf,'doublebuffer','on');

