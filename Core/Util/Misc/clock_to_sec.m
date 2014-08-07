function t = clock_to_sec(str)

% clock_to_sec - convert time string to seconds
% ---------------------------------------------
%
% t = clock_to_sec(str)
%
% Input:
% ------
%  str - clock time strings
%
% Output:
% -------
%  t - times in seconds

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
% $Date: 2005-02-24 21:18:55 -0500 (Thu, 24 Feb 2005) $
% $Revision: 609 $
%--------------------------------

% TODO: make this simpler and more efficient, too many exceptions

% TODO: replace 'str2double' with 'str_to_double' when it's implemented

% TODO: allow for 'hh:mm' strings, this assumes the input constitutes leading digits

%--
% loop over time strings
%--

if (iscell(str))
	t = zeros(size(str));
else
	str = {str};
	t = 0;
end

for k = 1:numel(t)
	
	tmp = str{k};
	ix = findstr(tmp,':');
	
	if (length(ix) ~= 2)
		
% 		disp(' ');
% 		warning('Improper clock string, missing colons.');

		t(k) = nan;
		break;
		
	end
	
	try
		
		tt(3) = str2double(tmp((ix(2) + 1):end));
		tt(2) = str2double(tmp((ix(1) + 1):(ix(2) - 1)));
		tt(1) = str2double(tmp(1:(ix(1) - 1)));
		
	catch
		
% 		disp(' ');
% 		warning('Improper clock string, improper number strings.');

		t(k) = nan;
		break;
		
	end
	
	if (length(tt) < 3)
		
% 		disp(' ');
% 		warning('Improper clock string, improper number strings.');

		t(k) = nan;
		break;
		
	end
	
	t(k) = (3600 * tt(1)) + (60 * tt(2)) + tt(3);
	
end

%--
% return empty on error
%--

if ((length(t) == 1) && isnan(t))
	t = [];
end
