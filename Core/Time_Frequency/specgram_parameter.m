function parameter = specgram_parameter

% specgram_parameter - create spectrogram parameters struct
% ---------------------------------------------------------
%
% parameter = specgram_parameter
%
% Output:
% -------
%  parameter - spectrogram parameters

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
% fft length and advance
%--

parameter.fft = 512;

parameter.hop = 0.5;

parameter.hop_auto = 1;

%--
% window options
%--

[win_types, ignore, ix] = window_to_fun;

parameter.win_type = win_types{ix};

parameter.win_param = [];

parameter.win_length = 1;

%--
% summary options
%--

parameter.sum_type = 'mean';

parameter.sum_quality = 'low';

parameter.sum_length = 1;

parameter.sum_auto = 1;
