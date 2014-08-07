function [ix,n,ch] = get_sound_extent(sound,mode,x,dx,ch)

% get_sound_extent - get sound extent from input
% ----------------------------------------------
%
% [ix,n,ch] = get_sound_extent(sound,mode,x,dx,ch)
%
% Input:
% ------
%  sound - sound 
%  mode - reading mode
%  x - starting index or time
%  dx - number of samples or duration
%  ch - channels to read

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
% set default read mode
%--

if isempty(mode)
	mode = 'samples';
end

if ~ischar(mode)
	error('Read mode must be string.');
end

if ~ismember(mode,{'samples','time'})
	error(['Unrecognized read mode ''', mode, '''.']);
end

%--
% set starting index
%--

if isempty(x)
	
	ix = 0;

else

	if strcmpi(mode,'time')
		ix = x * sound.samplerate;
	else
		ix = x;
	end
	
	ix = floor(ix);
	
end

%--
% set number of samples to read
%--

if isempty(dx)

	%--
	% set remaining samples as default
	%--
	
	if strcmpi(sound.type,'file')
		n = sound.samples - ix;
	else
		n = sound.cumulative(end) - ix;
	end
	
else

	if strcmpi(mode,'time')
		n = dx * sound.samplerate;
	else
		n = dx;
	end

	n = floor(n);
	
	%--
	% check that we have requested number of samples in sound
	%--
	
% 	if (strcmpi(sound.type,'file'))
% 		
% 		if (n > (sound.samples - ix))
% 			disp(' ');
% 			error('Number of desired samples exceeds available samples.');
% 		end
% 		
% 	else
% 		
% 		if (n > (sound.cumulative(end) - ix))
% 			disp(' ');
% 			error('Number of desired samples exceeds available samples.');
% 		end
% 		
% 	end

end

%--
% set and check channels
%--

% NOTE: default is to select all available channels, reconsider this

if isempty(ch)

	ch = [1:sound.channels];

else

	%--
	% check that we have requested channels
	%--
	
	% NOTE: channels requested may not be unique
	
	flag = numel(unique(ch)) > numel(intersect(1:sound.channels,ch));
	
	if (flag)
		error('Selected channels are unavailable.');
	end

end
