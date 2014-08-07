function [ix,id] = filter_events(event,varargin)

% filter_events - filter events based on field values
% ---------------------------------------------------
%
% [ix,id] = filter_events(event,'field',value, ...)
%
% Input:
% ------
%  events - array of events
%  field - field name
%  value - field values
%
% Output:
% -------
%  ix - event indices
%  id - event id numbers

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
% get and check field value pairs
%--

n = length(varargin);

if (mod(n,2))
	disp(' ');
	error('Input fields and values must come in pairs.');
end

p = n/2;

for k = 1:p
	field{k} = varargin{2*k - 1};
	value{k} = varargin{2*k};
end

for k = 1:p
	if (~isstr(field{k}))
		disp(' ');
		error('Field names must be strings.');
	end
end

%--
% apply event selection
%--

for k = 1:p
	
	switch (field{k})
		
		case ('channel')
		
		case ('start_time')
			
		case ('end_time')
			
		case ('duration')
			
		case ('start_freq')
			
		case ('end_freq')
						
		case ('bandwidth')
			
		otherwise
			
	end
	
end
