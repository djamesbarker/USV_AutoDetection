function [Xk, ix] = get_component_signal(data, k, rate)

% get_component_signal - synthesize model signal component
% --------------------------------------------------------

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
% get component check and for model
%--

component = data.component(k);

if isempty(component.model)
	Xk = []; ix = []; return;
end

%--
% get event and component signal indices
%--

start = component.model.t(2);

stop = component.model.t(end - 1);

ix = [floor(start * rate):floor(stop * rate)]; 

n = length(ix);

%--
% create frequency and amplitude vectors
%--

[t, f] = spline_eval(component.model.y, component.model.t, n);

%--
% get linear-grid frequency signal
%--

f = interp1(t, f, linspace(min(t), max(t), length(f)), 'spline');

f = f * 1000;

a = component.amplitude; 

% NOTE: these are ad-hoc amplitude modifications to the amplitude

a(1) = 0; a(2) = 0.75 * a(2); a(end - 1) = 0.75 * a(end - 1); a(end) = 0;

a = interp1(a, linspace(1, length(a), length(f)), 'spline');

%--
% synthesize and add component to model signal
%--

Xk = fm_synth(f, a, rate, 2);
