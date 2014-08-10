function parameter = parameter__create(context)

% DATA TEMPLATE - parameter__create

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

% TODO: context must include sound and user (consider user preferences)

%--
% templates
%--

% TODO: develop clips as part of the system

parameter.templates = [];

%--
% correlation threshold and extreme deviation test
%--

parameter.thresh = 0.4;

parameter.thresh_test = 1;

parameter.deviation = 3;

parameter.deviation_test = 0;

%--
% template masking
%--

% NOTE: there are other parameters used for masking

% TODO: add further masking parameters, they will be hidden

parameter.mask = 0;

parameter.mask_percentile = 0.6;
