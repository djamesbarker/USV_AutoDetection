function step = inc_to_step(varargin)

% inc_to_step - compute sliderstep from slider_inc
% ------------------------------------------------
%
% step = inc_to_step(control)
%
%      = inc_to_step(r,inc,step)
%
% Input:
% ------
%  control - slider control
%  r - slider value range
%  inc - desired increments
%  step - default sliderstep values, when setting fails
%
% Output:
% -------
%  step - sliderstep value

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
% $Revision: 1472 $
% $Date: 2005-08-05 20:01:05 -0400 (Fri, 05 Aug 2005) $
%--------------------------------

%----------------------------------------
% HANDLE INPUT
%----------------------------------------

switch (nargin)
	
	%--
	% control structure input
	%--
	
	case (1)
		
		control = varargin{1};
		
		r = control.max - control.min; 
		
		inc = control.slider_inc; step = control.sliderstep;
	
	%--
	% range and increment input OR handle and increment input
	%--
	
	% NOTE: here we set the default sliderstep
	
	case (2)
		
		if (~ishandle(varargin{1}))
			
			r = varargin{1}; 
			
			inc = varargin{2}; step = [0.01, 0.1];
			
		else
			
			g = varargin{1};
			
			r = get(g,'max') - get(g,'min'); 
			
			inc = varargin{2}; step = get(g,'sliderstep');
			
		end
	
	%--
	% range, increment, and default sliderstep input
	%--
	
	case (3)
		
		r = varargin{1}; 
		
		inc = varargin{2}; step = varargin{3};
		
end

%----------------------------------------
% COMPUTE STEP FROM INCREMENT
%----------------------------------------

%--
% check the increment values
%--

% NOTE: the first two tests may happen as honest mistakes

if 1 % db_disp

	if (any(inc > r))
		disp('WARNING: Slider increment values exceed slider range.'); return;
	end

	if (inc(1) > inc(2))
		disp('WARNING: Minor slider increment must be smaller than major increment.'); return;
	end

	% if (any(inc <= 0))
	% 	disp('WARNING: Slider increment values must be positive.'); return;
	% end

end

%--
% convert increment to step
%--

step = inc ./ r;
