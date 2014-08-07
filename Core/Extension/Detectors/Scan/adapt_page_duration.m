function scan = adapt_page_duration(scan,elapsed)

% adapt_page_duration - update context scan page duration to achieve goal
% ------------------------------------------------------------------------
%
% scan = adapt_page_duration(scan,elapsed)
%
% Input:
% ------
%  scan - scan
%  elapsed - elapsed time for last page
%
% Output:
% -------
%  scan - updated scan

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

% TODO: set percent tolerance

%----------------------------
% HANDLE INPUT
%----------------------------

%--
% return if no elapsed or known adapt mode
%--

if (nargin < 2)
	return;
end

modes = {'response','speed'};

if (~ismember(scan.adapt,modes))
	return;
end

%----------------------------
% ADAPT
%----------------------------

%--
% update page duration to acheve adaptation goal
%--

switch (scan.adapt)

	%--
	% achieve response time
	%--
	
	case ('response')

		target = 0.25;
		
		if abs(elapsed - target) <= (scan.tol * target)
			return;
		end
		
		factor = 1.25;
		
		if (elapsed > target)
			factor = 1/factor;
		end
		
		scan.page.duration = factor * scan.page.duration;
	
	%--
	% achieve speed
	%--
	
	case ('speed')

		% NOTE: we need a sequence of relevant values, we evaluate change

end



