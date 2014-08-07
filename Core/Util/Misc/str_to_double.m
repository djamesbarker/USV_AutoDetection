function x = str_to_double(str)

% str_to_double - stripped down version of str2double
% ---------------------------------------------------
%
% x = str_to_double(str)
%
% Input:
% ------
%  str - string or string cell array
%
% Output:
% -------
%  x - double equivalent

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

% NOTE: this code gains roughly 20 percent over 'str2double'

% NOTE: consider writing this as mex as well

%--
% return on empty
%--

if (isempty(str))
	x = [];
	return;
end

%--
% handle strings
%--

% TODO: this should probably be rewritten as mex

if (ischar(str))

    lenS = length(str);
	
    % try to get 123, 123i, 123i + 45, or 123i - 45
	
	% NOTE: we only want to consider the first case
	
    [a,n,err,nix] = sscanf(str,'%f %1[ij] %1[+-] %f',4);
	
	%--
    % we only consider the simplest case of a double
	%--
	
    if ((n == 1) && (isempty(err)) && (nix > lenS))
        x = a;
        return;
	end

%--
% handle string cell arrays
%--

elseif (iscellstr(str))
	
    for k = numel(str):-1:1,
        x(k) = str_to_double(str{k});
	end
	
    x = reshape(x,size(str));
	
%--
% handle general cell arrays
%--

elseif (iscell(str))
	
	x = [];
	
	for k = numel(str):-1:1
		
		if iscell(str{k})
			x(k) = NaN;
		else
			x(k) = str_to_double(str{k});
		end
		
	end
	
    x = reshape(x,size(str));
	
%--
% input is not a string
%--

else
	
    x = NaN;
	
end
