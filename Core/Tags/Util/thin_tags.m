function tags = thin_tags(tags, p)

% thin_tags - select tags with a certain probability
% --------------------------------------------------
%
% tags = thin_tags(tags, p)
%
% Input:
% ------
%  tags - tags to select from
%  p - probability of selection
%
% Output:
% -------
%  tags - thin tags

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

%--------------------------
% HANDLE INPUT
%--------------------------

%--
% set default thinning probability
%--

if (nargin < 2)
	p = 0.25;
end

%--
% check tags
%--

if ~is_tags(tags)
	error('Input tags are not valid.');
end

if ischar(tags)
	tags = {tags};
end

%--------------------------
% THIN TAGS
%--------------------------

%--
% get tag indices using probability
%--

ix = find(rand(size(tags)) < p);

%--
% select tags
%--

if isempty(ix)
	tags = {}; return;
end

% NOTE: sorted indices preserve the tag order

tags = tags(ix);
