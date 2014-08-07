function des = des_create(varargin)

% des_create - create value description
% -------------------------------------
%
% des = des_create
%
% Output:
% -------
%  des - value description structure

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

%---------------------------
% CREATE DESCRIPTION
%---------------------------

persistent DES_PERSISTENT;

if (isempty(DES_PERSISTENT))
	
	%--
	% name and alias
	%--
	
	% NOTE: name must be valid variable name
	
	des.name = '';
	
	des.alias = '';
	
	%--
	% type and range
	%--

	% NOTE: types are 'numerical', 'categorical', and 'ordinal'

	des.type = '';

	%--
	% range
	%--

	% NOTE: interval end points or value list

	des.range = [];

	% NOTE: interval type code, 0: open, 1: right closed, 2: left closed, 3: closed
	
	des.interval = [];
	
	%--
	% units
	%--

	% NOTE: units must be a string, eventually we may support known units

	des.units = '';

	%--
	% copy results to persistent store
	%--
	
	DES_PERSISTENT = des;
	
else
	
	des = DES_PERSISTENT;
	
end

%---------------------------
% SET FIELDS
%---------------------------
	
if (length(varargin))
	
	des = parse_inputs(des,varargin{:});

end

%---------------------------
% SOME VALIDATION
%---------------------------

%--
% validate and normalize type
%--

if (~isempty(des.type))
	
	if (~ischar(des.type))
		error('Description type must be character string.');
	end
	
	types = {'numerical','categorical','ordinal'};
	
	switch (lower(des.type(1)))
	
		case ('n'), des.type = types{1};
		
		case ('c'), des.type = types{2};
			
		case ('o'), des.type = types{3};
			
		otherwise, error('Unrecognized description type.');
			
	end
	
end

%--
% validate interval type
%--

if (~isempty(des.interval))
	
	switch (des.interval)
		
		case ({0,1,2,3})
			
		otherwise, error('Improper interval type code.');
		
	end
	
end

