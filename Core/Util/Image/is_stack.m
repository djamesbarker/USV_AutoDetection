function t = is_stack(X)

% is_stack - check for image stack
% --------------------------------
%
% t = is_stack(X)
%
% Input:
% ------
%  X - input image
%
% Output:
% -------
%  t - stack indicator

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
% input is not cell array
%--

if (~iscell(X))
	
	t = 0;
	
%--
% check size of planes
%--

else

	%--
	% get first plane shape
	%--
	
	s = size(X{1});
	d = length(s);
	
	%--
	% produce tentative indicator based on plane shape
	%--
	
	switch (d)
		
	% vector cell array, not stack
	
	case (1)
		t = 0;
		return;
	
	% grayscale image stack
	
	case (2)
		t = 1;
	
	% color image stack
	
	case (3)
		t = 2;
	
	% multiple plane image stack
	
	otherwise
		t = 3;
		
	end
	
	%--
	% compare plane shapes
	%--
	
	for k = 2:length(X)
		
		sk = size(X{k});
		dk = length(sk);
		
		if ((d ~= dk) | any(s ~= sk))
			t = 0;
			break;
		end
		
	end

end
