function [caller, str] = get_caller(fun)

% get_caller - get caller context
% -------------------------------
%
% [caller, str] = get_caller(fun)
%
%
% Input:
% ------
%  fun - function called
%
% Output:
% -------
%  caller - caller, decorated 'dbstack' entry
%  str - linked caller string

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

% TODO: figure out what the meaning and intended use of this function is

%-----------------
% HANDLE INPUT
%-----------------

%--
% get caller from stack
%--

if (nargin < 1) || isempty(fun)
	
	% NOTE: this function and actual caller are the first two stack elements

	stack = dbstack('-completenames');

	% NOTE: return if we were called from the command line

	if length(stack) < 3
		caller = []; return;
	end

	caller = stack(3);
	
%--
% set caller
%--

else
	
	% NOTE: this could change if the stack object entries change
	
	caller.file = which(fun);
	
	caller.name = fun;
	
	caller.line = 0;

end

%--
% output caller string
%--

if nargout > 1
	str = stack_line(caller);
end

%-----------------
% DECORATE
%-----------------

%--
% parse caller file to get extension location
%--

% NOTE: caller is an extension if it exists within an 'Extensions' directory

% TODO: the following code works on windows, encapsulate to avoid this

loc = strread(caller.file, '%s', 'delimiter', '/')

ix = find(strcmp(loc, 'Core')); 

if isempty(ix)
	caller.loc = []; return;
end

caller.loc = loc((ix + 1):(end - 1));



