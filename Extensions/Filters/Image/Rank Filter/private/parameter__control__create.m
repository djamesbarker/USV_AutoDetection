function control = parameter__control__create(parameter,context)

% RANK FILTER - parameter__control__create

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
% get size of structuring element
%--

% NOTE: create structuring element using parameters and compute size

n = se_size(create_se(parameter));

%--
% add leading rank control
%--

control(1) = control_create( ...
    'name','rank', ...
    'alias','Rank', ...
	'style','slider', ...
	'min',1, ...
	'max',n, ...
	'slider_inc',[1,2], ...
	'value',parameter.rank ...
);

control(end + 1) = control_create( ...
	'style','separator' ...
);

%--
% append parent controls
%--

fun = parent_fun;

par_control = fun(parameter,context);

control = [control, par_control];
