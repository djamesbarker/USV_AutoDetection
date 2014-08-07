function ext = get_active_detector(varargin)

% get_active_detector - get browser active detector
% -------------------------------------------------
%
% ext = get_active_detector(par,data)
%
% Input:
% ------
%  par - parent browser
%  data - parent state
%
% Output:
% -------
%  ext - active detector extension

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
% $Revision: 2173 $
% $Date: 2005-11-21 18:26:27 -0500 (Mon, 21 Nov 2005) $
%--------------------------------

ext = get_active_extension('detector',varargin{:});
