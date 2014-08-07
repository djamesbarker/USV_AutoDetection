function [M, sounds] = average_call(source, opt)

%--
% handle input
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

if nargin < 2
	opt = fast_specgram;
end

if ~nargin 
	source = uigetdir;
end

%--
% get files from directory
%--

files = dir(source); files([files.isdir]) = []; 

files = {files.name};

%--
% create sounds from files
%--

opt.attributes = 0;

for k = 1:length(files)
	disp(['Creating sound for clip ''', files{k}, '''.']);
	sounds(k) = sound_create('file', [source, filesep, files{k}], opt);
end

%--
% create spectrograms
%--

M = sound_read(sounds(1));

for k = 2:length(files)
	M = M + detrend(sound_read(sounds(k)));
end

M = M ./ length(files);

%--
% display average spectrogram
%--

fig; imagesc(fast_specgram(M, opt)); axis('xy');
