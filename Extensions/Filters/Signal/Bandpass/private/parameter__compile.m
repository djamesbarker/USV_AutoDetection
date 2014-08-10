function [parameter, context] = parameter__compile(parameter, context)

% BANDPASS - parameter__compile

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
% get rate and nyquist from context
%--

rate = get_sound_rate(context.sound); nyq = 0.5 * rate;

%--
% compute band description from parameters
%--

LC = parameter.min_freq;

HC = parameter.max_freq;

% NOTE: this handles a call to compile before the callback gets a chance to check validity

% NOTE: this is a failure of the system to fully implement MVC

% NOTE: there are alternatives, ask matt ... they look weird though, ask harold

if LC > (HC - parameter.min_band)
	return;
end

F = [LC - parameter.transition, LC, HC, HC + parameter.transition] ./ nyq;

%--
% set band amplitude and distortion parameters
%--

A = parameter.amplitude;

if ~A(1)
	D = [10^(parameter.stop_ripple / 20), 10^(parameter.pass_ripple / 20), 10^(parameter.stop_ripple / 20)];
else
	D = [10^(parameter.pass_ripple / 20), 10^(parameter.stop_ripple / 20), 10^(parameter.pass_ripple / 20)];
end

%--
% get length
%--

L = round(parameter.length);

if parameter.estimate
	L = [];
end

%--
% design filter
%--

[b, a, L] = design_fir_filter(F, A, D, L);

%--
% store results of compilation
%--

parameter.length = L;

parameter.filter.a = a;

parameter.filter.b = b;


