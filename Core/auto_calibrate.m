function c = auto_calibrate(cl)

% auto_calibrate - compute a reasonable calibration value
% -------------------------------------------------------
%
% c = auto_calibrate(cl)
%
% Input:
% ------
%  cl - decibel range for channel (one per row)
%
% Output:
% -------
%  c - calibration values for each channel

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% get maximum decibel for all channels
%--

D = max(cl(:,2));

%--
% set calibration values to match this maximum in other channels
%--

c = D - cl(:,2);

%--
% ignore channels that seem to be empty
%--

ix = find(cl(:,2) < -10);
c(ix) = 0;
