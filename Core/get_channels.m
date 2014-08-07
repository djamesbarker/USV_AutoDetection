function ch = get_channels(C)

% get_channels - get channels in order from channel representation
% ----------------------------------------------------------------
%
% ch = get_channels(C)
%
% Input:
% ------
%  C - channel display matrix
%
% Output:
% -------
%  ch - displayed channels

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
% $Revision: 1730 $
% $Date: 2005-09-02 14:34:46 -0400 (Fri, 02 Sep 2005) $
%--------------------------------

%--
% get size and minimally check channel display matrix
%--

% NOTE: this is meant as a low level function so error checking will not be used

% [m,n] = size(C);
% 
% if (n ~= 2)
% 	disp(' ');
% 	error('Improper channel display matrix.');
% end
% 
% if (sum(C(:,2)) == 0)
% 	disp(' ');
% 	error('No channels displayed according to matrix.');
% end

%--
% get displayed channels from channel display matrix
%--

ch = C(find(C(:,2)),1); % get displayed channels list
