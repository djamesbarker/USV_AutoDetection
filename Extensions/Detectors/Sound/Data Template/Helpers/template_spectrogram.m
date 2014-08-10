function [Bt, Bn, ixf] = template_spectrogram(clip, sound, parameter)

% template_spectrogram - produce template spectrogram and normalization box
% -------------------------------------------------------------------------
%
% [Bt, Bn, ixf] = template_spectrogram(clip, sound, parameter)
% 
% Input:
% ------
%  clip - control palette handle
%  sound - sound we are scanning
%  parameter - detector parameter structure (contains clip)
%
% Output:
% -------
%  Bt - template spectrogram
%  Bn - normalization filter
%  ixf - frequency bin indices

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
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1000 $
% $Date: 2005-05-03 19:36:26 -0400 (Tue, 03 May 2005) $
%--------------------------------

%---------------------------------
% CREATE TEMPLATE SPECTROGRAM
%---------------------------------
	
% NOTE: there are problems when the event band is not available in the sound

%--
% rename clip data for convenience
%--

y = clip.data;

f1 = clip.event.freq(1);

f2 = clip.event.freq(2);

duration = clip.event.duration;

%--
% resample clip
%--

% TODO: look at the resampling function (signal processing toolbox) more closely

if (clip.samplerate ~= sound.samplerate)
	
	%% NEW CODE %%
	
	% NOTE: compute rational approximation to resampling ratio and resample
		
% 	ratio = get_sound_rate(sound) / clip.samplerate; [p,q] = rat(ratio); y = resample(y,p,q);
	
	%% OLDER CODE %%
	
	%--
	% compute smaller up and down sampling rates
	%--
	
	P = 0.1 * sound.samplerate; Q = 0.1 * clip.samplerate;
	
	if ((P ~= floor(P)) || (Q ~= floor(Q)))
		
		% NOTE: display warning of some kind
		
	end
	
	P = round(P); Q = round(Q); y = resample(y,P,Q);
	
end

%--
% pad out to correct number of samples
%--

n_samples = ceil(specgram_duration(sound.specgram, sound.samplerate, duration) * sound.samplerate);

if numel(y) < n_samples
	y = [y(:); zeros(n_samples - numel(y), 1)];
elseif numel(y) > n_samples
	y(n_samples + 1:end) = [];
end

%--
% compute template spectrogram
%--

[Bt,fg,tg] = fast_specgram(y ,sound.samplerate, 'norm', sound.specgram);

%--
% enforce odd number of columns
%--

% NOTE: we pad with a zero column at end if needed

if (~mod(size(Bt,2),2))
	Bt(:,end + 1) = 0;
end

%---------------------------------
% TRIM COMPUTATION
%---------------------------------

%--
% find indices of desired frequencies
%--

% ix1 = max(find(fg <= f1));
% 
% ix2 = min(find(fg >= f2));

ix1 = find(fg <= f1,1,'last');

if isempty(ix1)
	ix1 = 1;
end

ix2 = find(fg >= f2,1,'first');

if isempty(ix2)
	ix2 = length(fg);
end

ixf = ix1:ix2;

%--
% try to enforce odd number of rows
%--

% NOTE: we try to conserve the high frequencies

if (mod(length(ixf),2) == 0)
	
	if ((ix2 + 1) < size(Bt,1))
		ixf = ix1:(ix2 + 1);
	elseif (ix1 > 1)
		ixf = (ix1 - 1):ix2;
	end
	
end

%--
% trim and possibly mask template
%--

Bt = Bt(ixf,:);

if (parameter.mask)
	
	%--
	% create masking options structure and set mask percentile
	%--
	
	opt = template_mask;

	opt.blur = 5;
	
	opt.open = 2.1;
	
	opt.percentile = parameter.mask_percentile;
	
	%--
	% compute masked template and mask 
	%--
		
	[Bt,Bn] = template_mask(Bt,opt);

else
	
	Bn = ones(size(Bt));

end

%--
% center and normalize template spectrogram
%--

ix = find(Bn > 0);

Bt(ix) = Bt(ix) - mean(Bt(ix));

Bt = Bt ./ sqrt(sum(Bt(:).^2));
