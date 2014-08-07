function [X,N,h] = get_stack_data(g)

% get_stack_data - get stack data
% -------------------------------
%
% [X,N,h] = get_stack_data(g)
%
% Input:
% ------
%  g - handle to parent figure or axes (def: gcf)
%
% Output:
% ------
%  X - image stack
%  N - image names
%  h - handle to image containing stack

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
% $Date: 2003-07-06 13:36:53-04 $
% $Revision: 1.0 $
%--------------------------------

%--
% set handle
%--

if (~nargin)
	g = gcf;
end

%--
% get stack image handle
%--

h = findobj(g,'tag','IMAGE_STACK');

if (isempty(h))
	error('Parent object does not contain image stack.');
end

%--
% get stack data
%--

X = getfield(get(h,'userdata'),'X');

if (nargout > 1)
	N = getfield(get(h,'userdata'),'N');
end
