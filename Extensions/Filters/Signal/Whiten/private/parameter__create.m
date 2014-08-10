function parameter = parameter__create(context)

% WHITEN - parameter__create

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

fun = parent_fun; parameter = fun(context);

parameter.order = 16;

% NOTE: the next two parameters regularize the inverse filter in different ways

parameter.r = 0;

nyq = 0.5 * get_sound_rate(context.sound);

parameter.max_freq = 0.75 * nyq;

parameter.lowpass = 0;

parameter.noise_log = [];

parameter.use_log = 0;


