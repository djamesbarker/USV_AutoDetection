function str = seconds_to_time(secs)

%----------------------------
% HANDLE INPUT
%----------------------------

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

%--
% handle array input recursively
%--

if (numel(secs) > 1)
	
	str = cell(size(secs));
	
	for k = 1:numel(secs)
		
		if (iscell(secs))
			sec = secs{k};
		else
			sec = secs(k);
		end
		
		str{k} = seconds_to_time(sec);
		
	end	
	
	return;	
	
end

%----------------------------
% COMPUTE TIME STRING
%----------------------------

%--
% compute minutes and seconds
%--

mins = floor(secs / 60); secs = secs - mins * 60;

%--
% get minutes and seconds label
%--

if (secs ~= 1)
	sec_str = 'seconds';	
else
	sec_str = 'second';
end

if (mins ~= 1)
	min_str = 'minutes';
else
	min_str = 'minute';
end

%--
% put together time string
%--

if (mins == 0)
	str = [num2str(secs) ' ' sec_str];
elseif (secs == 0)
	str = [num2str(mins) ' ' min_str];	
else
	str = [num2str(mins) ' ' min_str ', ' num2str(secs) ' ' sec_str];	
end

