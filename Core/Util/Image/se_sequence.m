function [SE,n] = se_sequence(SE)

% se_sequence - ensure proper structuring element sequence
% --------------------------------------------------------
%
% [SE,n] = se_sequence(SE)
%
% Input:
% ------
%  SE - input structuring element sequence
%
% Output:
% -------
%  SE - actual structuring element sequence
%  n - lenghth of sequence

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
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
% $Revision: 132 $
%--------------------------------

%--	
% cell array of scale parameters, sequence of scale parameters (scalar or structuring elements)
%--

if (iscell(SE))
	
	% get length of sequence
	
	n = length(SE);
	
	% convert scales to structuring elements if needed
	
	for k = 1:n
		if (isempty(se_rep(SE{k})))
			SE{k} = se_ball(SE{k});
		end
	end
	
% 	% output single strucuring element if needed
% 	
% 	if (n == 1)
% 		SE = SE{1};
% 	end

%--
% array of scale parameters, sequence of scalar scale parameters
%--

elseif (isempty(se_rep(SE)) && (min(size(SE)) == 1))
	
	% get length of sequence
	
	n = length(SE);
	
	% convert scales to structuring element
	
	for k = 1:n
		tmp{k} = se_ball(SE(k));
	end
	SE = tmp;
	
% 	% output single strucuring element if needed
% 	
% 	if (n == 1)
% 		SE = SE{1};
% 	end

%--
% structuring element
%--

else
	
	% wrap structuring element into cell array
	
	tmp = SE;
	clear SE;
	SE{1} = tmp;
	
	% length of sequence
	
	n = 1;
	
end
