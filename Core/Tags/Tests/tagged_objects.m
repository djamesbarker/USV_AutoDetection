function obj = tagged_objects(n, tags)

% tagged_objects - create a set of randomly tagged objects
% --------------------------------------------------------
%
% [obj, tags] = tagged_objects(n, tags)
%
% Input:
% ------
%  n - number of objects
%  tags - tags used
%
% Output:
% -------
%  obj - tagged objects
%  tags - tags used

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

%-----------------------
% HANDLE INPUT
%-----------------------

%--
% set default tags
%--

if (nargin < 2)
	tags = {'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'cat', 'dog', 'duck'};
end

%--
% check tags
%--

if ~is_tags(tags)
	error('Input tags are not valid.');
end

%--
% set default number of objects
%--

if (nargin < 1)
	n = 10;
end

%-----------------------
% TAGGED OBJECTS
%-----------------------

% NOTE: we create a 'base' taggable object, thin tags, and set tags

base.tags = {};

for k = 1:n
	obj(k) = set_tags(base, thin_tags(tags));
end
