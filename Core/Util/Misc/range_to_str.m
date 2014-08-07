function str = range_to_str(range)

% range_to_str - convert range structure to string
% ------------------------------------------------
%
% str = range_to_str(range)
%
% Input:
% ------
%  range - range structure
%
% Output:
% -------
%  str - string to parse

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

%--
% convert range depending on type
%--

switch (range.type)
	
	%--
	% interval range
	%--
	
	case ('interval')
		
		%--
		% get end points
		%--
		
		b = range.data.ends;
		
		%--
		% consider interval type
		%--
		
		switch (range.data.type)
			
			case ('open')
				str = ['(' num2str(b(1)) ',' num2str(b(2)) ')'];
				
			case ('left_open')
				str = ['(' num2str(b(1)) ',' num2str(b(2)) ']'];
				
			case ('right_open')
				str = ['[' num2str(b(1)) ',' num2str(b(2)) ')'];
				
			case ('closed')
				str = ['[' num2str(b(1)) ',' num2str(b(2)) ']'];
				
		end
		
	%--
	% set range
	%--
	
	% NOTE: this is the trickiest of the ranges
	
	case ('set')
		
		%--
		% get set elements
		%--
		
		element = range.data.element;
		
		%--
		% create set string
		%--
		
		% NOTE: the output is normalized in the sense that we get commas
		
		str = '{';
		
		for k = 1:(length(element) - 1)
			if (isstr(element{k}))
				str = [str, element{k}, ', '];
			else
				str = [str, num2str(element{k}) ', '];
			end
		end
		
		if (isstr(element{end}))
			str = [str, element{end}, '}'];
		else
			str = [str, num2str(element{end}) '}'];
		end
		
	%--
	% colon range
	%--
	
	case ('colon')
		
		%--
		% get colon data
		%--
		
		colon = range.data;
		
		str = [ ...
			num2str(colon.start) ':' ...
			num2str(colon.inc) ':' ...
			num2str(colon.end) ...
		];
	
end
				
