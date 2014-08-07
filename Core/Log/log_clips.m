function f = log_clips(log,ix,dt,ch,p)

% log_clips - create sound clips from log file
% --------------------------------------------
%
% f = log_clips(log,ix,dt,ch,p)
%
% Input:
% ------
%  log - input log
%  ix - log event indices
%  dt - padding of clips in seconds (def: 1)
%  ch - channels clipped 'single' or 'all' (def: 'single')
%  p - location of files and file format

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
% $Date: 2005-01-14 19:10:10 -0500 (Fri, 14 Jan 2005) $
% $Revision: 385 $
%--------------------------------

%----------------------------------------------
% HANDLE INPUT
%----------------------------------------------

%--
% set event indices
%--

if ((nargin < 2) | isempty(ix))
	
	%--
	% default to all events in log
	%--
	
	ix = 1:length(log.event);
	
else
	
	%--
	% check for out of bounds indices
	%--
	
	[a,b] = fast_min_max(ix);
	if ((a < 1) | (b > length(log.event)))
		disp(' '); 
		error('Event indices are out of bounds.');
	end
	
end

%--
% get location of files and filename format
%--

%--
% set channels
%--

if ((nargin < 4) | isempty(ch))
	
	ch = 'single';
	
else
	
	if (isempty(find(strcmp(ch,{'single','all'}))))
		disp(' ');
		error('Channel selection type must be ''single'' or ''all''.');
	end
	
end

%--
% set padding duration
%--

if ((nargin < 3) | isempty(dt))
	
	%--
	% get event durations
	%--
	
	tmp = struct_field(log.event,'duration');
	
	%--
	% compute bounds and meadian of event duration
	%--
	
	[l,u] = fast_min_max(tmp);
	
	m = fast_median(tmp);
	
	
end
