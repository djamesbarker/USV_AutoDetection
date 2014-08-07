function selected = selected_create(varargin)

% selected_create - create selected event set structure
% -----------------------------------------------------
% 
% selected = selected_create
%
% Output:
% -------
%  selected - XBAT selected event set structure

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

%---------------------------------------------------------------------
% CREATE SELECTED STRUCTURE
%---------------------------------------------------------------------

persistent SELECTED_PERSISTENT;

if (isempty(SELECTED_PERSISTENT))

	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	selected.type = 'selected';
	
	selected.name = ''; % name of selected

	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	selected.created = []; % selected set creation date
	
	selected.modified = ''; % selected set modification date
	
	selected.author = ''; % author of selected set
	
	%--------------------------------
	% RULE FIELDS
	%--------------------------------
	
	selected.rule = []; % required sound attributes
	
	%--------------------------------
	% EVENT FIELDS
	%--------------------------------
	
	selected.id = []; % selected event ids
	
	%--------------------------------
	% USERDATA FIELDS
	%--------------------------------
	
	selected.userdata = [];
	
	%--
	% set persistent selected
	%--
	
	SELECTED_PERSISTENT = selected;
	
else 
	
	%--
	% copy persistent selected
	%--
	
	selected = SELECTED_PERSISTENT;
		
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	selected = parse_inputs(selected,varargin{:});
end
