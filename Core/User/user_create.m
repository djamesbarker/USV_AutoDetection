function user = user_create(varargin)

% user_create - create user structure
% -----------------------------------
%
% user = user_create
%
% Output:
% -------
%  user - user structure

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
% $Revision: 1869 $
% $Date: 2005-09-28 16:45:31 -0400 (Wed, 28 Sep 2005) $
%--------------------------------

% NOTE: user data is typically stored in a mat file in user folder within users

%---------------------------------------------------------------------
% CREATE USER STRUCTURE
%---------------------------------------------------------------------

%--------------------------------
% PRIMITIVE FIELDS
%--------------------------------

user.type = 'user';

user.id = round(rand * 10^12);

%--------------------------------
% USER FIELDS
%--------------------------------

% NOTE: consider adding further contact information

user.name = '';

user.alias = '';

user.organization = '';

user.email = '';

user.url = '';

% NOTE: use of this field is not currently defined

user.prefs = [];

%--------------------------------
% LIBRARY FIELDS
%--------------------------------

% NOTE: library paths are stored here, using it further information can be obtained.

% TODO: check availability of libraries on user load

user.library = {}; % path to libraries used

user.default = []; % index to default library

user.active = []; % index to active library

%--------------------------------
% ADMINISTRATIVE FIELDS
%--------------------------------

% NOTE: what changes induce modification date change

user.created = now; % creation date

user.modified = []; % modification date

%--------------------------------
% METADATA FIELDS
%--------------------------------

% user.annotation = annotation_create; % array of annotation structures
% 
% user.measurement = measurement_create; % array of measurement structures

%--------------------------------
% USERDATA FIELD
%--------------------------------

user.userdata = []; % userdata field is not used by system

	
%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if length(varargin)
	
	user = parse_inputs(user, varargin{:});
	
	% NOTE: check for the type integrity of given data, movin closer to objects
	
	%--------------------------------
	% CHECK FIELDS
	%--------------------------------
	
	%--------------------------------
	% COMPUTE FIELDS
	%--------------------------------
	
	%--
	% alias is name
	%--
	
	% TODO: this way of computing alias leads to obscure choices
	
	if isempty(user.alias) && ~isempty(user.name)
		user.alias = user.name;
	end
	
end
