function [param, slices] = update_time_resolution(sound, duration, param, slice_request, frac)

% update_time_resolution - update spectrogram time resolution
% -----------------------------------------------------------
%
% [param, slices] = update_time_resolution(sound, duration, param, slices)
%
% Input:
% ------
%  sound - an XBAT sound structure.
%  duration - a page duration (in seconds.)
%  param - input spectrogram options structure.
%  slices - the desired number of time slices
%
% Output:
% -------
%  param - modified spectrogram parameters
%  slices - the number of time slices

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

%--------------------------------
% Author: Matt Robbins
%--------------------------------
% $Revision: 2273 $
% $Date: 2005-12-13 18:12:04 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

% NOTE: the lower limits should be physically reasonable, re/consider the
% lower limit on the 'Advance' control in the 'Spectrogram' palette

%----------------------------------
% HANDLE INPUT
%----------------------------------

%--
% set default minimum precision 
%--

if ((nargin < 5) || isempty(frac))
	frac = 0.9;
end

%--
% number of desired time slices
%--

% TODO: consider the multiple screen problem, remembar mathworks does not
% support multiple screens

% NOTE: default is a fraction of the screensize

if ((nargin < 4) || isempty(slice_request))
	
	% NOTE: we asssume that the screensize comes from the 'main' screen
	
	monitorsize = get(0,'ScreenSize'); slice_request = floor(0.75 * monitorsize(3));
	
end

%--
% set default specgram parameters
%--

if ((nargin < 3) || isempty(param))
	param = specgram_parameter;
end

%-----------------------
% SETUP
%-----------------------

%--
% get free parameters from spectrogram parameters
%--

free = cell(0);

if (param.sum_auto)
	free{end + 1} = 'sum_length';
else
	param.sum_length = 1;
end

if (param.hop_auto)
	free{end + 1} = 'hop';
	param.hop = 0.5;
end

%--
% return if there are no free parameters
%--

if (isempty(free))
	return;
end

%--
% set up parameter ranges
%--

if isempty(sound.samplesize)
	sample_bytes = 2;
else
	sample_bytes = sound.samplesize/8;
end

%--
% maximum summary interval is dictated by the block size of the spectrogram
% computatation
%--

max_sum = floor((2^23 / (param.fft * sample_bytes * sound.channels))/4);

minhop = ceil(param.fft*0.01);

paramrange = struct(...
	'hop', [minhop, param.fft], ...
	'sum_length', [1, max_sum] ...
);

%--
% get the actual number of samples to work with
%--

samples = duration * get_sound_rate(sound); 

%--
% convert hop into samples
%--

param.hop = floor(param.hop * param.fft);

%--
% get starting conditions
%--

slices = floor(samples / (param.hop * param.sum_length));

ratio = slices / slice_request;

%---------------------------------------------------
% UPDATE SPECTROGRAM PARAMETERS
%---------------------------------------------------

ok = 0; n = 0; ix = 1;

while (~ok && (n < 5))
	
	%--
	% compute new parameter value based on desired number of slices
	%--
	
	new_value = floor(param.(free{ix}) * ratio);
	
	range = paramrange.(free{ix});
	
	param.(free{ix}) = enforce_range(new_value, range);
	
	%--
	% compute new number of slices
	%--
	
	slices = floor(samples / (param.hop * param.sum_length));

	ratio = slices / slice_request;
	
	%--
	% increment or decrement precedence index if not satisfied
	%--
	
	ix = enforce_range(ix + 1, [1 length(free)]);
	
	n = n + 1;
	
	%--
	% if the number of slices is ok, then finish.
	%--

	if (enforce_range(ratio, [frac, 1/frac]) == ratio)
		ok = 1;
	end

end

%--
% convert hop back into ratio
%--

param.hop = param.hop / param.fft;


%-----------------------------------------------------
% ENFORCE_RANGE
%-----------------------------------------------------

function a = enforce_range(a, range)

if a < range(1) 
	a = range(1); return;
end
	
if  a > range(2)
	a = range(2); return;	
end



