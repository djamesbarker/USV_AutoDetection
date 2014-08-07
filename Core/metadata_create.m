function metadata = metadata_create(varargin)

% metadata_create - create metadata structure
% -------------------------------------------
%
% metadata = metadata_create
%
% Output:
% -------
%  metadata - XBAT metadata structure

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
% CREATE METADATA STRUCTURE
%---------------------------------------------------------------------

persistent METADATA_PERSISTENT;

if (isempty(METADATA_PERSISTENT))

	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	metadata.name = ''; % name of metadata
	
	metadata.fun = []; % function implementing metadata, function handle
	
	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	metadata.author = ''; % author of metadata, string or function handle (classifier)
	
	metadata.created = now; % creation date 
	
	metadata.modified = []; % modification date
	
	%--------------------------------
	% METADATA FIELDS
	%--------------------------------
	
	metadata.value = []; % metadata values computed
	
	metadata.parameter = []; % paremeters used in metadata computation
	
	%--------------------------------
	% USERDATA FIELDS
	%--------------------------------
	
	metadata.userdata = []; % system independent user data field
	
	%--
	% set persistent metadata
	%--
	
	METADATA_PERSISTENT = metadata;
	
else 
	
	%--
	% copy persistent metadata and update creation date
	%--
	
	metadata = METADATA_PERSISTENT;
	
	metadata.created = now;
	
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	metadata = parse_inputs(metadata,varargin{:});
end
