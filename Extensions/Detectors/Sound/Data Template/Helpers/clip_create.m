function clip = clip_create(event, rate, data, code, mode, id)

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

if nargin < 6
	id = [];
end

% NOTE: the default value is the code for 'Keep (Exclusive)'

if nargin < 5 || isempty(mode)
	mode = 2;
end

if nargin < 4 || isempty(code)
	code = '';
end

if nargin < 3 || isempty(data)
	data = [];
end

if nargin < 2 || isempty(rate)
	rate = [];
end

if ~nargin || isempty(event)
	event = empty(event_create);
end


clip.event = event;

clip.samplerate = rate;

%--
% read enough samples to fully re-generate the event spectrogram (2x event duration)
%--

clip.data = data;

clip.code = code;

% NOTE: the default value is the code for 'Keep (Exclusive)'

clip.mode = mode; 

clip.id = id;
