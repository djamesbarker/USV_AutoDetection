function out = input_create(k)

% input_create - create input description
% ---------------------------------------
%
% out = input_create(k)
%
% Input:
% ------
%  k - number of input elements
%
% Output:
% -------
%  out - input structure

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

%----------------------------------------
% create input structure
%----------------------------------------

%--
% set units
%--

out.unit = 9;

%--
% set margins
%--

margin.top = 1;
margin.bottom = 1;
margin.left = 1; 
margin.right = 1;
margin.sep = 1;

out.margin = margin;

%--
% set input elements
%--

elem.name = 'Input';
elem.style = 'slider';
elem.size = [12,1];
elem.min = 0;
elem.max = 1;
elem.step = [0.01, 0.1];
elem.list = cell(0);
elem.value = 0.5;

for j = 1:k
	out.input(j) = elem;
	out.input(j).name = ['Input ' int2str(k)];
end
