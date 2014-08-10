function samples = get_marker_samples(marker, parameter, context)

% NOTE: this can probably more general, but this is a little helper

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
% get marker page
%--

page.start = marker.time; 

% NOTE: should this derive from a marker property or scope parameter?

page.duration = parameter.duration;

%--
% get marker samples from context sound
%--

page = read_sound_page(context.sound, page, marker.channel);

page = filter_sound_page(page, context);

if isempty(page.filtered)
	samples = page.samples;
else
	samples = page.filtered;
end
