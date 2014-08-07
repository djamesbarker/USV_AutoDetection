function caller = get_caller(fun, context)

% get_caller - get caller context
% -------------------------------
%
% caller = get_caller(fun, context)
%
%
% Input:
% ------
%  fun - extension function
%  context - relevant context
%
% Output:
% -------
%  caller - caller info structure, decorated 'dbstack' structure

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
% $Revision: 2014 $
% $Date: 2005-10-25 17:43:52 -0400 (Tue, 25 Oct 2005) $
%--------------------------------

% TODO: remove vestiges from specific extensions framework use

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% get caller from stack
%--

if ((nargin < 1) || isempty(fun))
	
	%--
	% get stack
	%--
	
	% NOTE: this function and actual caller are the first two stack elements

	stack = dbstack('-completenames');

	% NOTE: return if we were called from the command line

	if (length(stack) < 3)
		caller = []; return;
	end

	%--
	% get caller
	%--
	
	caller = stack(3);
	
else
	
	%--
	% fill caller structure
	%--
	
	% NOTE: this could change if the stack object changes
	
	caller.file = which(fun);
	
	caller.name = fun;
	
	caller.line = 0;

end

%-----------------------------------
% HANDLE INPUT
%-----------------------------------

%--
% parse caller file to get extension location
%--

% TODO: the following code works on windows, encapsulate to avoid this

loc = strread(caller.file, '%s', 'delimiter', '\\');

% NOTE: caller is an extension if it exists within an 'Extensions' directory

ix = find(strcmp(loc,'Extensions')); 

if isempty(ix)
	caller.loc = []; return;
end

caller.loc = loc((ix + 1):(end - 1));

% disp(' '); disp(sprintf(to_xml(caller)));
