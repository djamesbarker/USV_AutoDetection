function h = match_tag_prefix(g,str,fast)

% match_tag_prefix - select handles by matching tag prefix
% --------------------------------------------------------
%
% h = match_tag_prefix(g,str)
%
% Input:
% ------
%  g - input handles
%  str - prefix string
%
% Output:
% -------
%  h - selected handles

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
% $Revision: 513 $
% $Date: 2005-02-09 21:06:29 -0500 (Wed, 09 Feb 2005) $
%--------------------------------

%---------------------------------------------
% HANDLE INPUT
%---------------------------------------------

%--
% set default fast flag
%--

if (nargin < 3)
	fast = 0;
end

%--
% check input is handles
%--

if (~fast)
	if (any(~ishandle(g)))
		disp(' ')
		error('First input to this function must consist only of handles.');
	end
end

%---------------------------------------------
% GET AND MATCH TAGS
%---------------------------------------------

%--
% get object tags
%--

N = numel(g);

% NOTE: pack single figure tag into cell array

if (N == 1)
	tag = {get(g,'tag')};
else
	tag = get(g,'tag');
end

%--
% get length of prefix
%--

n = length(str);

%--
% match tag prefix
%--

% NOTE: initialize counter and output array for speed

j = 0;
h = zeros(size(g));

for k = 1:N
	
	% NOTE: check length of tag before comparing for speed
	
	if ((length(tag{k}) >= n) && strncmp(tag{k},str,n))
		j = j + 1;
		h(j) = g(k);
	end

end	

%--
% output only selected handles
%--

h = h(1:j);
