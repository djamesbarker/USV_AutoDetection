function str = duration_string(seconds)

% duration_string - get string description of time duration
% ---------------------------------------------------------
%
% str = duration_string(seconds)
%
% Input:
% ------
%  seconds - seconds
%
% Output:
% -------
%  str - duration string

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

str = 'really, really long';

times = get_times; mult = 1;

for k = 2:numel(times)
	
	mult = mult * times{k - 1}{2};
	
	next = mult * times{k}{2};
	
	if seconds < next
		str = sprintf(['%2.1f ' times{k - 1}{1}], seconds / mult); return;
	end
	
end


%-------------------
% GET_TIMES
%-------------------

function times = get_times()

times{1} = {'seconds', 1};

times{end + 1} = {'minutes', 60};

times{end + 1} = {'hours', 60};

times{end + 1} = {'days', 24};

times{end + 1} = {'weeks', 7};

times{end + 1} = {'months', 4};

times{end + 1} = {'years', 12};

times{end + 1} = {'decades', 10};

times{end + 1} = {'centuries', 10};

times{end + 1} = {'millenia', 10};


