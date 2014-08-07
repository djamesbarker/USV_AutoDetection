function wait = waitbar_create(varargin)

% waibar_create - create waitbar structure
% ----------------------------------------
%
% wait = waitbar_create(field1,value1, ... ,fieldn,valuen)
%
% Input:
% ------
%  field - waitbar field name
%  value - waitbar field value
%
% Output:
% -------
%  wait - waitbar structure

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
% $Revision: 3168 $
% $Date: 2006-01-11 16:54:20 -0500 (Wed, 11 Jan 2006) $
%--------------------------------

%---------------------------------------------------------------------
% CREATE WAITBAR STRUCTURE
%---------------------------------------------------------------------

persistent WAITBAR_PERSISTENT;

if (isempty(WAITBAR_PERSISTENT))
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	wait.name = ''; % name of wait
	
	wait.type = ''; % waitbar type 'def' or 'indef' (eventually support indefinite waitbars)
	
	%--------------------------------
	% WAITBAR FIELDS
	%--------------------------------
	
	wait.head = ''; % alias 'name' to be used as label when available
	
	wait.message = ''; % style of uicontrol object
		
	wait.value = 0; % value of uicontrol object
	
	wait.cancel = 0; % supports cancel
	
	%--------------------------------
	% LAYOUT AND DISPLAY FIELDS
	%--------------------------------
	
	wait.lines = 1; % number of lines for waitbar or edit box in tiles
	
	wait.color = [];
	
	%--------------------------------
	% USERDATA FIELD
	%--------------------------------
	
	wait.userdata = []; % userdata field is not used by system
	
	%--
	% set persistent wait
	%--
	
	WAITBAR_PERSISTENT = wait;
	
else
	
	%--
	% copy persistent wait and update creation date
	%--
	
	wait = WAITBAR_PERSISTENT;
		
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	wait = parse_inputs(wait,varargin{:});
end
