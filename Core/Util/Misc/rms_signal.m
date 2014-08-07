function Y = rms(X, N, W, f)

% rms - coarse RMS estimate
% -------------------------

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

% GOAL: to compute an RMS signal measure in pure MATLAB efficiently

% IDEA: compute windowed block estimates using reshape and matrix
% operations, then shift the computation and stack the results, then
% reshape again to concatenate the overlapping RMS estimates

% NOTE: consider implementing spectrogram in a similar way. in fact, this
% blocking pattern can describe a variety of temporally coarse features.
% the pattern should be carefully profiled and the fundamental elements
% optimized. a fine time resolution version of this kind of computation
% most likely requires MEX computation.

%--------------------
% HANDLE INPUT
%--------------------

%--
% set defaults
%--

if nargin < 4
	f = 0.5; 
end

if nargin < 3
	W = [];
end

if nargin < 2
	N = 256;
end

%--
% check consistency 
%--

if ~isempty(W) && (length(W) ~= N)
	error('Non-empty window length must match block size.');
end

%--------------------
% COMPUTE
%--------------------

%--
% pad signal
%--

S = size(X, 1); blocks = floor(S / N); pad = S - (blocks * N);

if pad
	blocks = blocks + 1; Y(S + 1: S + pad, :) = 0;
end

%--
% apply to each channel
%--

Y = zeros(blocks, ch)

for k = 1:ch
	Y(:, k) = overlapped_rms(X, N, W, f);
end


%-----------------------------------------------
% OVERLAPPED_RMS
%-----------------------------------------------

function Y = overlapped_rms(X, N, W, f)

% overlapped_rms - compute RMS estimate in overlapping segments
% -------------------------------------------------------------
%
% Y = overlapped_rms(X, N, W, f)
%
% Input:
% ------
%  X - signal
%  N - block size
%  W - window
%  f - fraction of block size to advance
%
% Output:
% -------
%  Y - RMS estimates signal

%-----------------------
% SETUP
%-----------------------

Y = zeros(blocks, p); 

%-----------------------
% COMPUTE
%-----------------------

Xk = X; n = f * N;

for k = 1:p	
	Y(k, :) = simple_rms(Xk, N, W); Xk = shift_signal(Xk, n); 	
end

% NOTE: vectorize matrix to interleave row sequences and recover a column

Y = vec(Y);


%-----------------------------------------------
% SIMPLE_RMS
%-----------------------------------------------

function Y = simple_rms(X, N, W)

% simple_rms - single channel windowed RMS estimate
% -------------------------------------------------
%
% Y = simple_rms(X, N, W);
% 
% Input:
% ------
%  X - signal
%  N - block size
%  W - window
%
% Output:
% -------
%  Y - RMS estimates signal

% NOTE: this function takes in a column and outputs a row

%-----------------------
% HANDLE INPUT
%-----------------------

blocks = floor(length(X) / N);

if round(blocks) ~= blocks
	error('Signal length must be a multiple of block size.');
end

%-----------------------
% COMPUTE
%-----------------------

Y = reshape(X, N, blocks);

% NOTE: the left diagonal window matrix multiply creates the desired window effect

if ~isempty(W);
	Y = diag(W(:)) * Y;
end

Y = sqrt(sum(Y.^2, 1));


%-----------------------------------------------
% SHIFT_SIGNAL
%-----------------------------------------------

function X = shift_signal(X, n, p)

% shift_signal - shift signal a number of samples
% -----------------------------------------------
%
% Y = shift_signal(X, n, p)
%
% Input:
% ------
%  X - signal
%  n - number of samples to shift
%  p - pad value (def: 0)
% 
% Output:
% -------
%  Y - shifted signal

%-----------------------
% HANDLE INPUT
%-----------------------

if nargin < 3
	p = 0;
end

if n == 0
	return;
end

%-----------------------
% SHIFT
%-----------------------

% NOTE: for most computations we are only interested in positive shifts

if n > 0
	X(1:(end - n)) = X((n + 1):end); X((end - n + 1):end) = p;
else 
	X(1:n) = p; X((n + 1):end) = X(1:(end - n + 1));
end
