function [str] = schedule_info_str(schedule)

% schedule_info_str - get string list for recording schedule
% ----------------------------------------------------------
%
% str = schedule_info_str(schedule)
%
% Inputs:
% -------
%  schedule - array of scheduled sessions
%
% Outputs:
% --------
%  str - each session is in its own cell

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
% $Revision: 1982 $
% $Date: 2005-10-24 11:59:36 -0400 (Mon, 24 Oct 2005) $
%--------------------------------

for k = 1:length(schedule)
	
	str{k} = ['[', sec_to_clock(schedule(k).start), ' - ', sec_to_clock(schedule(k).end), ']'];
	
end
