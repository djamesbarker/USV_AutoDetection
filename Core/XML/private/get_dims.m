function [d,nd,str] = get_dims(in)

% get_dims - get dimension information from an array
% --------------------------------------------------
%
% [d,nd,str] = get_dims(in)
%
% Input:
% ------
%  in - input variable
%
% Output:
% -------
%  d - size vector
%  nd - number of dimensions (different from 'ndims')
%  str - dimensions description string

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
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%-----------------------------------------
% GET SIZE AND DIMENSIONS
%-----------------------------------------

%--
% get size array
%--

d = size(in);

%--
% compute dimensions based on size
%--

if (max(d) == 1)

	nd = 0; % scalar

elseif (min(d) == 1) 
	
	nd = 1; % vector

else 

	nd = length(d); % matrices and higher dimensional arrays

end

%--
% create dimensions description string
%--

% NOTE: this is used in the  array wrappers in the xml representation

str = '';

if (nd)	
	
	for k = 1:length(d)
		str = [str, int2str(d(k)), ' '];
	end

	str = str(1:(end - 1));

end
