function fail = safer_eval(str)

% safer_eval - evaluate string with some concern
% ----------------------------------------------
%
% fail = safer_eval(str)
%
% Input:
% ------
%  str - string to evaluate
%
% Output:
% -------
%  fail - failure indicator
% 
% NOTE:
% -----
% This only works if string evaluated does not use or modify caller variables.

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

% NOTE: this is an experiment to see what may be possible

%--
% check string for unsafe commands
%--

censored = {'quit', 'close', 'delete', 'stop', 'set', 'figure', 'uicontrol'};

for k = 1:numel(censored)
	
	if strfind(str, censored{k})
		str = ''; break;
	end
	
end

%--
% evaluate string
%--

try
	eval(str);
catch
	if ~nargout
		xml_disp(lasterror);
	end
end
