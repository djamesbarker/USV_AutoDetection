function [parameter, context] = parameter__compile(parameter, context)

% DIFFERENCE - parameter__compile

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
% perform parent compilation if needed
%--

% NOTE: this is the parent that should go into the code generator

fun = parent_fun;

if ~isempty(fun)
	parameter = fun(parameter, context);
end

%--
% compile filter from order
%--

% TODO: implement a binomial filter, how should these two share code

d = [-1, 1]; b = d;

for k = 1:(parameter.order - 1)
	b = conv(b,d);
end

% NOTE: filter normalization normalizes gain

b = b ./ sum(abs(b));

%--
% pack filter in parameter struct
%--

parameter.filter.b = b;

parameter.filter.a = 1;
