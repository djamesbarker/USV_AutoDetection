function [m,n] = specgram_size(opt,r,t)

% specgram_size - compute size of spectrogram image
% -------------------------------------------------
%
% [m,n] = specgram_size(opt,r,t)
%
% Input:
% ------
%  opt - spectrogram parameters
%  r - sample rate
%  t - page duration
%
% Output:
% -------
%  m - number of rows
%  n - number of columns

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
% $Revision: 4407 $
% $Date: 2006-03-28 19:01:25 -0500 (Tue, 28 Mar 2006) $
%--------------------------------

%--
% compute number of rows and columns
%--

m = floor(opt.fft / 2) + 1;

n = (t * r) / (opt.hop * opt.fft);

n = floor(n) + 1;

if ~isempty(opt.sum_length)
	n = round(n / opt.sum_length);
end


