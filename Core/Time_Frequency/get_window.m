function [h, n] = get_window(parameter)

% get_window - compute window from parameters
% -------------------------------------------
%
% [h, n] = get_window_and_overlap(parameter)
%
% Input:
% ------
%  parameter - spectrogram parameters
%
% Output:
% -------
%  h - window vector
%  n - actual window length, no padding

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
% rename fft and window length
%--

N = parameter.fft;

n = round(N * parameter.win_length); 

%--
% get window function and test for parameter
%--

fun = window_to_fun(parameter.win_type);

if isempty(fun)
	parameter.win_type = 'hann'; fun = window_to_fun(parameter.win_type);
end

param = window_to_fun(parameter.win_type, 'param');

%--
% compute base window
%--

if isempty(param)
	h = fun(n);
else
	h = fun(n, parameter.win_param);
end

%--
% zero pad window to fft length if needed
%--

if (n < N)
	h((n + 1):N) = 0;
end



