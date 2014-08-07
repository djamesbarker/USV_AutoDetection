function X = stream_read(r,mode,x,dx,ch)

% stream_read - get sound samples from a recording stream
% -------------------------------------------------------
%
% X = stream_read(r,mode,x,dx,ch)
%
% Input:
% ------
%  r - audiorecorder structure
%  mode - reading mode, 'samples' or 'time' (sec)
%  x - starting index or time (def: 0)
%  dx - number of samples or time duration (sec) (def: remaining sound data)
%  ch - channels to read (def: all available channels)
% 
% Output:
% -------
%  X - samples from selected channels

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
% set read mode
%--

if (nargin < 2)
	mode = 'samples';
end
	
%--
% set starting index and convert time to samples
%--

if ((nargin < 3) | isempty(x))
    ix = 0;
else
    if (strcmp(mode,'time'))
        ix = round(x * r.samplerate);
	else
		ix = x;
	end
end

%--
% set number of samples and convert time duration to samples
%--

if ((nargin < 4) | isempty(dx))
	
    n = (f.totalsamples - ix);
	
else
    
    if (strcmp(mode,'time'))
        n = round(dx * r.samplerate);
	else
		n = dx;
	end
    
    if (n > (r.totalsamples - ix))
        error('Number of desired examples exceeds available samples.');
    end 
	
end

%--
% set channels
%--

if (nargin < 5)
    ch = 1:r.numberofchannels;
else
	ch = sort(ch);
    if (ch(end) > r.numberofchannels)
        error('Channels to read exceeds number of channels in file.');
    end	
end

%--
% get data from recorder
%--

% all samples

r.pause;
X = r.getaudiodata;
r.resume;

% select channels and then samples

X = X(:,ch);
X = X((ix + 1):(ix + n),:);

