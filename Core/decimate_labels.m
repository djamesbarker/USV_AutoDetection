function str = decimate_labels(str)

% decimate_labels - decimate label strings if needed
% --------------------------------------------------
%
% str = decimate_labels(str)
%
% Input:
% ------
%  str - input string cell array of labels
%
% Output:
% -------
%  str - decimated string cell array of labels

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
% $Revision: 879 $
% $Date: 2005-03-31 18:20:23 -0500 (Thu, 31 Mar 2005) $
%--------------------------------

%--
% check that input is cell array
%--

% there is a single label and no need for decimation, return

if (~iscell(str))
	str = {str};
	return;
end

%--
% get number of labels
%--

n = length(str);

%--
% set decimation factor
%--

% TODO: there is some tuning to be done here

if (n <= 8)
	return;
elseif (n <= 10)
	d = 2;
elseif (n <= 20)
	d = 4;
elseif (n <= 60)
	d = 12;
elseif (n <= 100)
	d = 24;
elseif (n <= 200)
	d = 48;
else
	d = 64;
end

%--
% decimate labels if needed
%--

for k = 1:n
	if (mod(k - 1,d))
		str{k} = '';
	end
end	
