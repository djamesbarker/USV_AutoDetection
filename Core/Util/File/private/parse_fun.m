function [fun, args] = parse_fun(in)

% parse_fun - parse file line processing input
% --------------------------------------------
%
% [fun, args] = parse_fun(in)
%
% Input:
% ------
%  in - process line input
%
% Output:
% -------
%  fun - process line function handle
%  args - arguments for process line function

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
% $Revision: 1600 $
% $Date: 2005-08-18 17:41:06 -0400 (Thu, 18 Aug 2005) $
%--------------------------------

%--
% consider form of fun input
%--

% NOTE: convert input function handle and argument based on class

switch class(in)
	
	case 'cell'
		args = in(2:end); fun = in{1};
		
	% NOTE: a string is a callback name, not a string to evaluate
	
	case 'char'
		args = []; fun = str2func(in);
		
	case 'function_handle'
		args = []; fun = in;
		
	otherwise
		error('Improper line processing input.');
		
end

%--
% check that fun is a function handle
%--

if ~isa(fun, 'function_handle')
	error('Improper function handle in line processing input.');
end
