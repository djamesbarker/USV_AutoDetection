function view = view_create(varargin)

% view_create - create view settings structure
% --------------------------------------------
%
% view = view_create
%
% Output:
% -------
%  view - view settings structure

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

% TODO: add signal and image filter fields to the view structure. these
% should be updated during sound_update

%---------------------------------------------------------------------
% CREATE VIEW SETTINGS STRUCTURE
%---------------------------------------------------------------------

persistent VIEW_PERSISTENT;

if (isempty(VIEW_PERSISTENT))
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
		
	%--
	% channel and start time fields
	%--
	
	view.channels = []; % channels displayed
	
	view.time = []; % start time of page
		
	%--
	% page and grid fields
	%--
	
	view.page = []; % page definition
	
	view.grid = []; % grid definition
	
	%--
	% colormap fields
	%--
	
	view.colormap = []; % colormap definition

	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	view.author = ''; % author of view
	
	view.created = now; % creation date
	
	view.modified = []; % modification date
	
	%--------------------------------
	% USERDATA FIELD
	%--------------------------------
	
	view.userdata = []; % userdata field is not used by system
	
	%--
	% set persistent view
	%--
	
	VIEW_PERSISTENT = view;
	
else
	
	%--
	% copy persistent view and update creation date
	%--
	
	view = VIEW_PERSISTENT;
	
	view.created = now;
	
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	view = parse_inputs(view,varargin{:});
end
