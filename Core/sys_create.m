function sys = sys_create(varargin)

% sys_create - create system interaction structure
% ------------------------------------------------
%
%  sys = sys_create
%
% Output:
% -------
%  sys - system interaction structure

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
% $Revision: 4926 $
% $Date: 2006-05-03 16:37:18 -0400 (Wed, 03 May 2006) $
%--------------------------------

% TODO: consider further information to include in system interaction structure

% THIS IS RELATED TO CONTEXT, CONSIDER MERGE

%---------------------------------------------------------------------
% CREATE SYS STRUCTURE
%---------------------------------------------------------------------

%--------------------------------
% BASIC
%--------------------------------

sys.parent = [];			% calling parent handle

% NOTE: current run modes are 'batch' and 'active', 'listener' will be another

sys.mode = []; 				% mode running mode extension

sys.return_time = []; 		% return time for computation

sys.return_events = []; 	% return after processing so many events

sys.timeout = []; 			% timeout computation

%--------------------------------
% CONDITIONING
%--------------------------------

% NOTE: keeping this generic should work as filtering develops

sys.signal_filter = [];		% signal filter state

sys.image_filter = [];		% image filter state

%--------------------------------
% USERDATA
%--------------------------------

sys.userdata = []; 			% userdata field is not used by system


%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	
	sys = parse_inputs(sys,varargin{:});
	
	% TODO: perform consistenc checks
	
end


