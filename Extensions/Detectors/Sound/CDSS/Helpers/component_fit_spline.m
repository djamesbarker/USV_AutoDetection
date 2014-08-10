function model = component_fit_spline(component, n)

% component_fit_spline - fit spline to component
% ----------------------------------------------
%
% model = component_fit_spline(component, n)
%
% Input:
% ------
%  component - a component event
%  n - the number of knots to model the event with
%
% Output:
% -------
% model - the model: y- and t-coordinates of knots

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
% fit spline
%--

[y, val, flag] = spline_fit_image(component.image, n);

%--
% scale frequency
%--

f = component.event.freq / 1000;  bw = diff(f);

y = y * (bw/size(component.image, 1)) + f(1); 

%--
% get time grid
%--

% NOTE: remember skips and plops

knot_time = component.event.duration / (n - 1); 

%--
% N knots [0 : N - 1] and two phantom knots
%--

t = [-1:n]*knot_time; 

model.y = y; 

model.t = t + component.event.time(1);
