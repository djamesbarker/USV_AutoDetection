function [event, context] = compute(page, parameter, context)

% DATA TEMPLATE - compute

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

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% check for any clips
%--

event = empty(event_create);

% NOTE: there is nothing to look for, so nothing was found

if isempty(parameter.templates) || isempty(parameter.templates.clip)
	return;
end

%----------------------------
% SETUP
%----------------------------

%--
% create base event
%--

base = event_create; 

base.annotation = simple_annotation;

ht = specgram_resolution(parameter.specgram, get_sound_rate(context.sound));

%-------------------------------------------------------
% CORRELATION
%-------------------------------------------------------

%--
% compute signal spectrogram
%--

% TODO: make use of filtered signal optional

% TODO: consider computing both when active and explaining

if ~isempty(page.filtered)
	page.samples = page.filtered;
end

B = fast_specgram(page.samples, [], 'norm', parameter.specgram);

%-------------------------------------------------------
% LOOP OVER TEMPLATES
%-------------------------------------------------------

%--
% get templates
%--

clips = parameter.templates.clip;

%--
% correlate and find template matches
%--

for kk = 1:length(clips)
	
	%-------------------------------------------------------
	% NORMALIZED CORRELATION
	%-------------------------------------------------------
	
	%--
	% extract clip band from signal spectrogram
	%--
	
	Bk = B(clips(kk).freq_ix,:);
	
	%--
	% configure normalized correlation
	%--

	% NOTE: we copy masking option from detector parameters

	opt = image_corr; 
	
	opt.pad_row = 0; opt.pad_col = 1; opt.mask = parameter.mask;

	%--
	% compute normalized correlation
	%--
	
	C0 = image_corr(clips(kk).spectrogram, Bk, opt);

	%-------------------------------------------------------
	% PROCESS CORRELATION
	%-------------------------------------------------------

	% NOTE: considering only peaks implements non-maximum supression

	%--
	% create filter conmesurate with clip width 
	%--
	
	F = filt_binomial(1, size(clips(kk).spectrogram, 2));
	
	%--
	% smooth correlation
	%--

	C = linear_filter(C0, F, 2);

	C(isnan(C)) = 0; % NOTE: this should not be needed

	%--
	% find peaks in correlation sequence and smooth
	%--

	p0ix = fast_peak_valley(C0, 1)';

	[pix, ph, pw] = fast_peak_valley(C, 1);

	pix = pix';

	%--
	% match peaks in smooth with best nearby peak in actual correlation
	%--

	% NOTE: this implements scale-space ideas of peak tracking across scale

	tmp = zeros(size(pix));

	for k = length(pix):-1:1

		%--
		% select candidate peaks in correlation sequence
		%--

		% NOTE: peak matching scope is given by width of the smooth peak

		d = p0ix - pix(k);

		c0ix = find((d > -pw(1,k)) & (d < pw(2,k)));

		%--
		% select best peak in the neighborhood
		%--

		if (~isempty(c0ix))

			%--
			% get candidate peak values and select the max
			%--

			[ignore, ix] = max(C0(p0ix(c0ix)));

			%--
			% store matching raw peak index
			%--

			tmp(k) = p0ix(c0ix(ix));

			%--
			% select best value in zone
			%--

			% NOTE: this is typically anomalous behavior and needs work

		else

			%--
			% get maximum value in zone
			%--

			ix1 = pix(k) - pw(1,k); ix2 = pix(k) + pw(2,k);

			[ignore,ix] = max(C0(ix1:ix2));

			tmp(k) = ix1 + ix - 1;

		end

	end

	% NOTE: these are the raw peak indices corresponding to the smooth peaks

	p0ix = tmp;

	%--
	% compute center and spread of correlation
	%--

	% NOTE: median based computation is significantly more robust

	% TODO: resolve whether to use smooth or raw center and deviation

	[s, c] = fast_mad(C0);

	s = 1.4826 * s;

	%-------------------------------------------------------
	% DECISION
	%-------------------------------------------------------

	% NOTE: at the moment this is all based on value thresholding

	if ~isempty(pix)

		%--
		% get peak values
		%--

		% NOTE: both values could be used in a more complex decision

		p0v = C0(p0ix);

		pv = C(pix);

		%--
		% perform deviation test
		%--

		if parameter.deviation_test
			test1 = ((p0v - c) ./ s) >= parameter.deviation;
		else
			test1 = ones(size(pv));
		end

		%--
		% perform threshold test
		%--

		if parameter.thresh_test
			test2 = p0v >= parameter.thresh;
		else
			test2 = ones(size(pv));
		end

		%--
		% logically combine tests
		%--

		ix = find(test1 & test2);

		%--
		% select peak locations and values
		%--

		% smooth corelation

		pix = pix(ix);

		pv = pv(ix);

		pw = pw(:,ix);

		% actual correlation

		p0ix = p0ix(ix);

		p0v = p0v(ix);

	end

	%-------------------------------------------------------
	% CREATE EVENTS
	%-------------------------------------------------------

	%--------------------
	% COMMON FIELDS
	%--------------------
	
	%--
	% set channel
	%--
	
	base.channel = page.channels;

	%--
	% common box elements
	%--
	
	base.duration = clips(kk).event.duration;

	base.freq = clips(kk).event.freq;

	%--
	% tags
	%--
	
	code = clips(kk).code;
	
	mode = clips(kk).mode;
	
	% NOTE: we still set the annotation for backwards compatability
	
	base.annotation.value.code = clips(kk).code;
	
	base = set_tags(base, {code});

	%--------------------
	% UNIQUE FIELDS
	%--------------------

	for k = 1:length(p0ix)

		%--
		% time selection
		%--

		time = (p0ix(k) * ht); half = 0.5 * base.duration;

		base.time = [time - half, time + half];

		%--
		% set score
		%--
		
		% NOTE: at the moment the score is the normalized correlation value
		
		base.score = p0v(k);
		
		%--
		% store computed values
		%--

		value.corr = p0v(k);

		value.corr_moment = [c,s];

		value.clip = kk;

		value.code = code;
		
		value.mode = mode;
		
		base.userdata = mode;

		base.detection.value = value;

		%--
		% add detection to event array
		%--
		
		event(end + 1) = base;

	end
	
	%-------------------------------------------------------
	% COLLECT EXPLAIN DATA 
	%-------------------------------------------------------
	
	if context.explain.on
		
		data.clip{kk} = clips(kk);
		
		data.correlation{kk} = C0; 
		
		data.smooth{kk} = C;
		
		data.smooth_peaks{kk} = pix;
		
		data.actual_peaks{kk} = p0ix;
		
	end
	
end

%-------------------------------------------------------
% KEEP BEST OF INTERSECTING EVENTS
%-------------------------------------------------------

%--
% discard lower quality events
%--

if length(event)

	discard = discard_lower_quality(event, 1:length(event));

	if ~isempty(discard)
		event(discard) = [];
	end

end

%-------------------------------------------------------
% PACK EXPLAIN DATA
%-------------------------------------------------------
	
if (context.explain.on)
	
	data.time = [page.start, page.start + page.duration];
	
	context.explain.data = data;
	
end		
