function range = range_create(type,varargin)

% range_create - create range structure
% -------------------------------------
%
%  range = range_create
%
% Output:
% -------
%  range - range structure

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
% CREATE RANGE STRUCTURE
%---------------------------------------------------------------------

%--------------------------------
% RANGE TYPE
%--------------------------------

% NOTE: types are 'colon', 'strings', 'interval', 'ray'

range.type = type;

%--------------------------------
% RANGE DATA FIELDS
%--------------------------------

% NOTE: other ranges possible are: polygons and dynamic trajectories

% TODO: consider the case of a list of values and the empty range

switch (type)

	%--------------------------------
	% uniformly spaced vector
	%--------------------------------

	case ('colon')

		% NOTE: equivalent to '0:0.1:1'

		range.data.start = 0;
		range.data.inc = 0.1;
		range.data.end = 1;
		
	%--------------------------------
	% vector
	%--------------------------------

	case ('vector')
		
		% NOTE: types are 'real' and 'integer'
		
		range.data.vector = 1:10;
		range.data.type = 'integer';
		
	%--------------------------------
	% string sets
	%--------------------------------

	% NOTE: perhaps this should always be a cell array

	case ('strings')

		range.data.string = [];

	%--------------------------------
	% intervals and rays
	%--------------------------------

	case ('interval')

		% NOTE: equivalent to the closed unit interval '(0,1)'

		% NOTE: types are 'open', 'left_open', 'right_open', 'closed'
		
		range.data.ends = [0,1];
		range.data.type = 'open';
		
	case ('ray')
		
		% NOTE: equivalent to the open ray '(0,inf)'
		
		% NOTE: types are 'left_open', left_closed', 'right_open', 'right_closed'
		
		range.data.point = 0;
		range.data.type = 'left_open'

	%--------------------------------
	% unrecognized range type
	%--------------------------------

	otherwise

		disp(' ');
		error(['Unrecognized range type ''' type '''.']);

end

%--------------------------------
% USERDATA FIELD
%--------------------------------

range.userdata = [];

%---------------------------------------------------------------------
% SET FIELDS IF PROVIDED
%---------------------------------------------------------------------

if (length(varargin))
	
	%--
	% try to get field value pairs from input
	%--
	
	% NOTE: that we apply this function to the data branch of the structure
	
	range.data = parse_inputs(range.data,varargin{:});
	
	%--
	% check range type
	%--
	
	% NOTE: this is redundant, the above switch takes care of this
	
	TYPE = { ... 
		'colon','strings','interval','ray' ...
	};

	if (isempty(find(strcmp(TYPE,range.type))))
		disp(' ');
		error('Unrecognized range type.');
	end 
	
	%--
	% check interval and ray types
	%--
	
	switch (range.type)
		
		case ('interval')
			
			INT_TYPE = { ...
				'open','left_open','right_open','closed' ...
			};
		
			if (isempty(find(strcmp(INT_TYPE,range.data.type))))
				disp(' ');
				error('Unrecognized interval type.');
			end 
			
		case ('ray')
			
			RAY_TYPE = { ...
				'left_open','left_closed','right_open','right_closed' ...
			};
		
			if (isempty(find(strcmp(RAY_TYPE,range.data.type))))
				disp(' ');
				error('Unrecognized ray type.');
			end 
			
	end

end


