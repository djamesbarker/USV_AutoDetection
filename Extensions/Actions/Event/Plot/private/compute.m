function [result,context] = compute(event,parameter,context)

% PLOT - compute

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

result = [];

h = fig;

%--
% amplitude plot
%--

subplot(2, 1, 1);

t = linspace(event.time(1), event.time(2), length(event.samples));

plot(t, event.samples);

title(['Amplitude Of Event #' int2str(event.id)]);

xlabel('Time (s)'); ylabel('Amplitude (normalized)');

%--
% spectrum plot
%--

subplot(2, 1, 2);

%--
% initialize spectrum estimation object
%--

method = parameter.method{1};

spec_obj = spectrum.(method);

%--
% plot psd or pseudospectrum, depending on method
%--

switch method
	
	case {'periodogram', 'welch', 'cov'}
		
		psd(spec_obj, event.samples, 'Fs', event.rate);
	
	case 'music'
		
		pseudospectrum(spec_obj,hilbert(event.samples),'Fs',event.rate); 
		
	otherwise
		
end

title(['Spectrum Of Event #' int2str(event.id)]);

xlabel('Frequency (KHz)'); ylabel('Amplitude (dB)');

%--
% some prettification
%--

set(h, 'numbertitle', 'off', 'name', ['Event Plot (# ', int2str(event.id), ')']);

%--
% send back result
%--

result = h;
