function annotation = annotation_create(varargin)

% annotation_create - create annotation structure
% -----------------------------------------------
%
% annotation = annotation_create
%
% Output:
% -------
%  annotation - empty annotation structure

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
% CREATE ANNOTATION STRUCTURE
%---------------------------------------------------------------------

persistent ANNOTATION_PERSISTENT;

if (isempty(ANNOTATION_PERSISTENT))
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	annotation.name = ''; % name of annotation 
	
	annotation.fun = ''; % function implementing annotation
	
	
	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	annotation.author = ''; % author of annotation
	
	annotation.created = now; % creation date
	
	annotation.modified = []; % modification date
	
	
	%--------------------------------
	% METADATA FIELDS
	%--------------------------------
	
	annotation.value = []; % annotation field values
	
	
	%--------------------------------
	% METADATA FIELDS
	%--------------------------------
	
	annotation.userdata = []; % userdata is not used by system
	
	
	%--
	% set persistent annotation
	%--
	
	ANNOTATION_PERSISTENT = annotation;
	
else 
	
	%--
	% copy persistent annotation and update creation date
	%--
	
	annotation = ANNOTATION_PERSISTENT;
	
	annotation.created = now;
	
end


%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	event = parse_inputs(event,varargin{:});
end
