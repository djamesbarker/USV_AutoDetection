function SE = create_se(param)

% create_se - structuring element from extension parameters
% ---------------------------------------------------------
%
% SE = create_se(param)
%
% Input:
% ------
%  param - morphological base parameters
%
% Output:
% -------
%  SE - structuring element

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
% $Revision: 1.0 $
% $Date: 2003-06-11 18:22:03-04 $
%--------------------------------

%--
% allow some flexibility in style
%--

% NOTE: we accept a string or a cell container as well as insignificant space

if (iscell(param.style))
	param.style = param.style{1};
end 

style = lower(strtrim(param.style));

%--
% compute based on style
%--

% NOTE: there are remaining options for 'se_ball' not exposed

switch (style)

	case ('rectangle')
		SE = ones(2 * param.height + 1,2 * param.width + 1);

	case ('disc')
		SE = se_ball([param.width, param.height],2);

	case ('diamond')	
		SE = se_ball([param.width, param.height],1);

	case ('star')
		SE = zeros(2 * param.height + 1,2 * param.width + 1); 
        SE(param.height + 1,:) = 1; SE(:,param.width + 1) = 1;
		
end
