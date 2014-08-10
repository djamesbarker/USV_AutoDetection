function ylim = get_scope_ylim(samples, parameter)

%--
% set width allowance in number of sample deviations
%--

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

% TODO: turn this into a parameter, and consider others

width = 6;

%--
% compute center and scale for positive and negative samples
%--

% TODO: factor this center-scale extraction

pos.samples = samples(samples > 0); 

if ~isempty(pos.samples)
	pos.center = mean(pos.samples); pos.scale = std(pos.samples);
else
	pos.center = 0; pos.scale = 0;
end

neg.samples = samples(samples < 0); 

if ~isempty(neg.samples)
	neg.center = mean(neg.samples); neg.scale = std(neg.samples);
else
	neg.center = 0; neg.scale = 0;
end

%--
% compute reasonable limits
%--

% NOTE: these limits should contain most samples, consider making symmetric

ylim(1) = min(neg.center - width * neg.scale, pos.center - width * pos.scale);

ylim(2) = max(pos.center + width * pos.scale, neg.center + width * neg.scale);
