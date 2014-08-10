function parameter = parameter__create(context)

% BANDPASS - parameter__create

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

%----------------
% SETUP
%----------------

%--
% inherit basic parameters from parent
%--

fun = parent_fun; parameter = fun(context);

%--
% get nyquist from context
%--

rate = get_sound_rate(context.sound); nyq = 0.5 * rate;
		
%----------------
% PARAMETERS
%----------------

%--
% hidden parameters
%--

parameter.min_band = 0.05 * nyq;

% NOTE: this describes the desired band amplitudes

parameter.amplitude = [0, 1, 0];

%--
% band parameters
%--

parameter.min_freq = 0.25 * nyq;

parameter.max_freq = 0.75 * nyq;

parameter.transition = 0.1 * nyq;

%--
% design parameters
%--

parameter.length = 16;

parameter.estimate = 1;

parameter.pass_ripple = -60;

parameter.stop_ripple = -30;


