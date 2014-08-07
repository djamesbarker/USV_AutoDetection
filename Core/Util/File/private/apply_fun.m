function [line, state] = apply_fun(line, fun, args, state)

% apply_fun - apply line processing function
% ------------------------------------------
%
% [line, state] = apply_fun(line, fun, args, state)
%
% Input:
% ------
%  line - line to process
%  fun - process line function handle
%  args - arguments for process line function
%  state - processor state
%
% Output:
% -------
%  line - processed line
%  state - processor state

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
% return quickly on no processing
%--

if isempty(fun)
	return;
end

%--
% consider availability of arguments in evaluation
%--

try
	
	if nargin < 4

		% NO STATE
		
		if isempty(args)
			line = fun(line);
		else
			line = fun(line, args{:});
		end
		
	else

		% STATE
		
		if isempty(args)
			[line, state] = fun(line, state);
		else
			[line, state] = fun(line, state, args{:});
		end

	end
	
catch
	
	nice_catch(lasterror, 'WARNING: Failed to process line.');

end
