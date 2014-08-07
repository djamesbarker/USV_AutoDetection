function [B, freq, time] = fast_specgram(X, rate, out, parameter)

% fast_specgram - spectrogram computation
% ---------------------------------------
%
%   [B, freq, time] = fast_specgram(X, rate, out, parameter)
%
% parameter = fast_specgram
%
% Input:
% ------
%  X - input signal
%  rate - sampling rate of input signal
%  out - output type 'complex', 'power', or 'norm'
%  parameter - spectrogam computation options
%
%    parameter.fft - length of fft
%    parameter.hop - hop length as fraction of fft
%
%    parameter.win_type - window type
%    parameter.win_param - window parameters
%    parameter.win_length - length of window 
%
%    parameter.sum_length - number of slices to summarize
%    parameter.sum_type - summary type 'average' or 'median'
%
% Output:
% -------
%  B - computed spectrogram
%  freq - frequency grid
%  time - time grid
%  parameter - spectrogram computation parameter structure

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

%-------------------------
% HANDLE INPUT
%-------------------------

%--
% set and possibly output default parameters
%--

if (nargin < 4) || isempty(parameter)

	% TODO: allow this function to take sound input
	
	parameter = specgram_parameter;
	
	if ~nargin
		B = parameter; return;
	end
	
end

%--
% set output type
%--

if (nargin < 3) || isempty(out)
	out = 'norm';
end

%--
% set sampling rate
%--

% NOTE: the default samplerate of 2 suggests normalized frequency

if (nargin < 2) || isempty(rate)
	rate = 2;
end

%--------------------------------------------------
% SETUP
%-------------------------------------------------

[h, n] = get_window(parameter);

N = parameter.fft;

overlap = round(N * (1 - parameter.hop));

%--------------------------------------------
% HANDLE VARIOUS OPTIONS
%--------------------------------------------

%--
% handle float or double input
%--

switch class(X)
	
	case 'double'
		fun = @fast_specgram_mex_double;
		single_flag = 0;
		
	case 'single'
		fun = @fast_specgram_mex_single; h = single(h);
		single_flag = 1;
		
end
		
%--
% get computation option from option name
%--

switch out
	
	case 'norm'	
		comp_type = 0;
		
	case 'power'
		comp_type = 1;
		
	case 'complex'
		comp_type = 2;
		
	otherwise 
		error(['Unknown output type ''', out, '''.']);
	
end

%--
% get summary codes
%--

sum = get_summary(parameter);

%-------------------------
% COMPUTE SPECTROGRAM
%-------------------------

%--
% compute a spectrogram for each channel
%--

% TODO: cast float to double for the moment

for k = 1:size(X, 2)
	B{k} = fun(X(:,k), h, N, overlap, comp_type, sum.length, sum.type, sum.quality);
end

%--
% output frequency and time grid
%--

if nargout > 1
    freq = (0:size(B{1}, 1) - 1)' * rate / N;
end

if nargout > 2
	time = (1 + (0:(size(B{1}, 2) - 1)) * (n - overlap))' / rate;
end    
   
%--
% handle single precision data
%--

if single_flag
	
	for k = 1:length(B)
		B{k} = double(B{k});
	end
	
end

%--
% output matrix in single channel case
%--

if length(B) == 1
	B = B{1};
end



