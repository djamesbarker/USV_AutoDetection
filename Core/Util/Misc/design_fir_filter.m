function [b, a, L] = design_fir_filter(F, A, D, L)

% design_fir_filter - design equiripple fir filter
% ------------------------------------------------
%
% [b, a] = design_fir_filter(F, A, D, L)
%
% Input:
% ------
%  F - band edges, not including 0 and nyquist
%  A - band amplitudes
%  D - band distortions
%  L - filter length
%
% Output:
% -------
%  b, a - filter coefficients ('a' is always 1 in this case)

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

%----------------
% HANDLE INPUT
%----------------

%--
% set default distortion
%--

if nargin < 3 || isempty(D)
	D = 0.01 * ones(size(A));
end

%--
% revert to lowpass
%--

if F(1) < 0
	F = F(3:end); A = A(2:end); D = D(2:end);
end

%--
% revert to highpass
%--

if F(end) > 1
	F = F(1:end - 2); A = A(1:end - 1); D = D(1:end - 1);
end

%--
% estimate order and prepare input for design function
%--

% NOTE: this maximum order constraint should not be hardcoded

if nargin < 4 || isempty(L)
	[L, F, A, W] = firpmord(F, A, D); L = min(L, 512);
else
	F = [0; F(:); 1]'; A = kron(A, [1 1]); W = (1 ./ D); W = W ./ min(W);
end

%--
% update length for highpass and bandstop if needed
%--

if A(end) && mod(L, 2)
	L = L + 1;
end

% TODO: there is a situation where we are getting an L of zero

L = max(L, 3);

%----------------
% DESIGN FILTER
%----------------

%--
% create persistent filter cache
%--

persistent FILTER_CACHE;

if isempty(FILTER_CACHE)
	FILTER_CACHE = struct;
end

%--
% get filter using cache if possible
%--

key = get_filter_key(L, F, A, W);

if isfield(FILTER_CACHE, key)
	b = FILTER_CACHE.(key);
else
	b = firpm(L, F, A, W); FILTER_CACHE.(key) = b;
end

a = 1;


%-----------------------
% GET_FILTER_KEY
%-----------------------

function key = get_filter_key(L, F, A, W)

% NOTE: prefix a digest of the key design parameters to build the key

key = ['key_', md5([L(:)', nan, F(:)', nan, A(:)', nan, W(:)'])];




