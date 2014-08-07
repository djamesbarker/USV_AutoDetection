function ix = range_select(value,range,op)

% range_select - select values in range
% -------------------------------------
%
% ix = range_select(value,range,op)
%
% Input:
% ------
%  value - array of values
%  range - range structure
%  op - logical operator applied to range sequence (def: 'and')
%
% Output:
% -------
%  ix - indices of selected values

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

% TODO: implement logical operator for range sequences

%------------------------------------
% HANDLE INPUT 
%------------------------------------

%--
% set default logical operator
%--

if (nargin < 3)
	op = 'and';
end 

%--
% handle string input
%--

if (isstr(range))
	range = str_to_range(range);
end

%--
% handle cell array of strings input
%--

if (iscellstr(range))
	
	str = range; clear range;
	
	for k = 1:length(str)
		range(k) = str_to_range(str{k});
	end
	
end

%------------------------------------
% MUTTIPLE RANGE SELECTION
%------------------------------------

if (isstruct(range) && (length(range) > 1))
	
	%--
	% compute depending on logical operator
	%--
	
	switch (op)
		
		%--
		% intersection of ranges
		%--
		
		case ({'and','intersect'})
			
			%--
			% perform selection incrementally
			%--

			N = length(value);

			ixs{1} = 1:N;

			for k = 2:length(range)

				ixs{k} = range_select(value(ixs{k - 1}),range(k));

				if (isempty(ixs{k}))
					k = k - 1;
					break;
				end

			end

			%--
			% de-reference iterated index sequence to get input indices
			%--


			ix = ix{n};

			for j = (n - 1):-1:1
				ix = ix{j}(ix);
			end
			
		%--
		% union of ranges
		%--
		
		case ({'or','union'})
			
	end
	
	return;
	
end

%------------------------------------
% PERFORM RANGE SELECTION
%------------------------------------

% TODO: optimize the performance of incremental selects

switch (range.type)
		
	%------------------------------------
	% interval selection
	%------------------------------------
	
	case ('interval')

		%--
		% compute depending on interval type
		%--
		
		% TODO: consider efficiency and the use of a mex
		
		b = range.data.ends;
		
		switch (range.data.type)
			
			case ('open')
				ix = find((value > b(1)) & (value < b(2)));

			case ('left_open')
				ix = find((value >= b(1)) & (value < b(2)));

			case ('right_open')
				ix = find((value > b(1)) & (value <= b(2)));

			case ('closed')
				ix = find((value >= b(1)) & (value <= b(2)));
				
		end
		
	%------------------------------------
	% ray selection
	%------------------------------------
	
	case ('ray')

		%--
		% compute depending on interval type
		%--
		
		% TODO: consider efficiency and the use of a mex
		
		b = range.data.point;
		
		switch (range.data.type)
			
			case ('left_open')
				ix = find(value > b);

			case ('left_closed')
				ix = find(value >= b);

			case ('right_open')
				ix = find(value < b);

			case ('right_closed')
				ix = find(value <= b);
				
		end
		
	%------------------------------------
	% colon sequence selection
	%------------------------------------
	
	% TODO: implement efficient integer sequence selection
	
	case ('colon')
	
		%--
		% compute incrementally
		%--
		
		% NOTE: we can prune the value array at each step if we want
		
		b = range.data;
		
		ix = [];
		
		for b = b.start:b.inc:b.end
			ix = [ix, find(value == b)]; 
		end
		
		ix = unique(ix);
		
	%------------------------------------
	% set range
	%------------------------------------
	
	case ('strings')
		
		%--
		% compute incrementally
		%--
			
end
