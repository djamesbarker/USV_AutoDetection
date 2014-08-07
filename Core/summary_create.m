function summary = summary_create(varargin)

% summary_create - create generation summary structure
% ----------------------------------------------------
%
%  summary = summary_create
%
% Output:
% -------
%  summary - generation summary structure

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
% CREATE SUMMARY STRUCTURE
%---------------------------------------------------------------------

persistent SUMMARY_PERSISTENT;

if (isempty(SUMMARY_PERSISTENT))
	
	%--------------------------------
	% PRIMITIVE FIELDS
	%--------------------------------
	
	summary.type = 'summary';
	
% 	rand('state',sum(100*clock));
% 	
% 	summary.id = round(rand * 10^16); 		% id for summary
			
	%--------------------------------
	% DATA FIELDS
	%--------------------------------
	
	summary.preset = []; 					% state of computating extension
			
	summary.events = []; 					% events created or modified as result of computation
	
	summary.etime = []; 					% time elapsed during computation

	%--------------------------------
	% ADMINISTRATIVE FIELDS
	%--------------------------------
	
	summary.author = ''; 					% user requesting computation
	
	summary.created = now; 					% creation date
	
	summary.modified = []; 					% modification date

	%--------------------------------
	% USERDATA FIELD
	%--------------------------------
	
	summary.userdata = []; % userdata field is not used by system
	
	%--
	% set persistent scan
	%--
	
	SUMMARY_PERSISTENT = summary;
	
else
	
	%--
	% copy persistent scan and update creation date
	%--
	
	summary = SUMMARY_PERSISTENT;
	
	summary.created = now;
	
end

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	
	%--
	% try to get field value pairs from input
	%--
	
	summary = parse_inputs(summary,varargin{:});

end


