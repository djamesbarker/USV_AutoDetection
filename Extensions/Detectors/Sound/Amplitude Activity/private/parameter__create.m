function parameter = parameter__create(context)

% AMPLITUDE ACTIVITY - parameter__create

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

% size of decision block

parameter.block = 0.025;

% size of window

parameter.window = 5;

% percentile to mark as signal amplitude

parameter.percent = 0.7;

% fraction needed to exceed signal amplitude in block

parameter.fraction = 0.4;

% markovian relaxation of fraction

parameter.relax = 0.70;

% flag for event refining using energy time frequency distribution

parameter.refine = 1;
