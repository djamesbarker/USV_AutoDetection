function [parameter, context] = parameter__compile(parameter, context)

% NOTCH - parameter__compile

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

nyq = get_sound_rate(context.sound) / 2;

%--
% get zero angle
%--

freq = 0.5 * parameter.center_freq / nyq;

%--
% get filter impulse response
%--

%--
% get number of conjugate zero pairs
%--

np = round((parameter.order - 1) / 2);

%--
% generate sampled frequency response
%--

F = linspace(0, 0.5, np);

k = find(F < freq, 1, 'last');

Fl = linspace(0, freq, k); Fh = linspace(freq, 0.5, np - k); Fh = Fh(2:end);

F = [Fl, Fh];

H = ones(size(F));  H(k) = 0;

%--
% design filter using frequency sampling
%--

h = fsamp(F, H); 

% h = h .* hamming(length(h));

parameter.filter.b = h;


