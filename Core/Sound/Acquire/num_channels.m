function [N names IDs] = num_channels(ai_obj)

%--------------------------------------------
% [N names IDs] = num_channels(ai_obj)
%
% ai_obj - a standard data acquisition toolbox analog input object
%
% N - the number of available channels
%
% names - the names of each channel, in a cell array
%
% IDs - channel identifiers, the channel IDs are guarateed to be unique and
% have similar indexing properties for all analog input adapter types.
%
% Author: Matt Robbins
% $Date$
% $Revision$

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

info = daqhwinfo(ai_obj);

N = info.TotalChannels;

IDs = info.SingleEndedIDs;

if strcmpi(get(ai_obj, 'InputType'), 'differential');

	N = N/2;
	
	IDs = info.DifferentialIDs;
	
end

names = cell(N, 1);

for ix = 1:N
	
	names{ix} = ['channel ' num2str(IDs(ix))];
	
end
	
