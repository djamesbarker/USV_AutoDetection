function [parameter, context] = parameter__compile(parameter, context)

% DATA TEMPLATE - parameter__compile

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

%-----------------------------
% HANDLE INPUT
%-----------------------------

if isempty(parameter.templates)
	return;
end

%--
% remove ignored clips
%--

for k = length(parameter.templates.clip):-1:1
	
	% NOTE: the zero mode is ignore
	
	if (parameter.templates.clip(k).mode == 0)
		parameter.templates.clip(k) = []; 
	end
	
end

%--
% check for any clips
%--

% NOTE: there are no clips to compile to templates, return

if isempty(parameter.templates.clip)
	return;
end

%-----------------------------
% COMPILE PARAMETER
%-----------------------------

%--
% pack current sound spectrogram parameters
%--

parameter.specgram = context.sound.specgram;

%--
% compute current clip spectrograms
%--

clip = parameter.templates.clip;

for k = 1:length(clip)
	
	[clip(k).spectrogram, clip(k).mask, clip(k).freq_ix] = template_spectrogram(clip(k), context.sound, parameter);

	% NOTE: this is the number of bins in the template

	clip(k).pixels = sum(clip(k).mask(:));

end

parameter.templates.clip = clip;

%-----------------------------
% CONFIGURE SCAN PAGING
%-----------------------------

%--
% return if there is no scan to configure
%--

if ~isfield(context, 'scan')
	return;
end

%--
% compute required page overlap
%--

% NOTE: the required overlap if half the maximum template duration

dt = specgram_resolution(context.sound.specgram, get_sound_rate(context.sound));

for k = 1:length(clip)
	max_width = max(1, size(clip(k).spectrogram, 2));
end

overlap = 0.5 * (max_width * dt);

% NOTE: overlap is expressed as a fraction of a page

context.scan.page.overlap = overlap / context.scan.page.duration;

