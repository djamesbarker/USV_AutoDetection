function [B,f,t] = fast_pitchgram(x,nfft,fs,h,noverlap,opt)

% fast_pitchgram - short time fourier of fourier transform
% --------------------------------------------------------
% 
% [B,f,t] = fast_pitchgram(x,nfft,fs,h,noverlap,opt)
% 
% Input:
% ------
%  x - input signal
%  nfft - length of fft
%  fs - frequency of samples
%  h - window
%  noverlap - length of overlap 
%  opt - computation option ('specgram' (def),'power')
%  
% Output:
% -------
%  B - pitchgram matrix
%  f - computed frequencies of frequencies
%  t - computed times

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
% set default parameters
%--

% set fft length

if ((nargin < 2) || isempty(nfft))
    nfft = min(length(x),256);
elseif ((length(nfft) > 1) || (nfft < 2))
    error('Length of fft must be an scalar integer larger than 1.');
end

% set frequency of samples

if ((nargin < 3) || isempty(fs))
    fs = 2;
end

% set window or pad window is shorter than nfft

if ((nargin < 4) || isempty(h))
    h = hanning(nfft);
else
	nh = length(h);
	if (length(h) < nfft)
		h(nh:nfft) = 0;
	end
end 

% set noverlap

if ((nargin < 5) || isempty(noverlap))
    noverlap = ceil(length(h)/2);
end

% set computation option

if (nargin < 6)
    opt = 'specgram'; 
end

%--
% compute spectrogram or spectrogram power using mex
%--

switch (opt)
    
case ('power')
    B = fast_specgram_(x,h,nfft,noverlap,1);
% 	B = diff([B; zeros(1,size(B,2))],1,1);
	B = fast_specgram_(sqrt(B),h,nfft,0,1);
    
case ('specgram')
	B = fast_specgram_(x,h,nfft,noverlap,1);
% 	B = diff([B; zeros(1,size(B,2))],1,1);
	B = fast_specgram_(sqrt(B),h,nfft,0,2);
    
otherwise
    error('Unknown computation option.');
    
end

%--
% output frequency and time grid (from specgram)
%--

if (nargout > 1)
    f = (1:size(B,1) - 1)' * fs / nfft;   
end

if (nargout > 2)
	t = (1 + (0:(size(B,2) - 1)) * (length(h) - noverlap))' / fs;	
end    
    
