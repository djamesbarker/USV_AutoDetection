function [X, opt] = read_mp3(info, ix, n, ch, opt)

% read_mp3 - read samples from sound file
% ---------------------------------------
%
% X = read_mp3(f, ix, n, ch)
%
% Input:
% ------
%  info - file info struct
%  ix - initial sample
%  n - number of samples
%  ch - channels to select
%  opt - conversion request options
%
% Output:
% -------
%  X - samples from sound file
%  opt - conversion request options

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
% $Revision: 587 $
% $Date: 2005-02-22 23:28:55 -0500 (Tue, 22 Feb 2005) $
%--------------------------------

%--
% get samples from file
%--

X = sound_read_mex(info.file, ix, n, 2); 

X = X(:, ch);

	
