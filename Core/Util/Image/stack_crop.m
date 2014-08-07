function [Y,r,c] = stack_crop(h,X)

% stack_crop - crop a displayed stack
% -----------------------------------
%
% [Y,r,c] = stack_crop(h,X)
% 
% Input:
% ------
%  h - axes handle for displayed stack (def: gca)
%  X - stack to crop (def: displayed stack)
%
% Output:
% -------
%  Y - cropped stack
%  r - row limits
%  c - column limits

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

%--
% set handle
%--

if (~nargin)
	h = gca;
end 

%--
% set stack
%--

if (nargin < 2)
	X = get(findobj(h,'type','image'),'userdata');
	X = X.X;
end

%--
% get indexing from axes handle
%--

p = get(h);

r = p.YLim + [0.5 -0.5];
r = [ceil(r(1)), floor(r(2))];

c = p.XLim + [0.5 -0.5];
c = [ceil(c(1)), floor(c(2))];

%--
% create cropped image
%--

for k = 1:length(X)
	Y{k} = X{k}(r(1):r(2),c(1):c(2),:);
end
