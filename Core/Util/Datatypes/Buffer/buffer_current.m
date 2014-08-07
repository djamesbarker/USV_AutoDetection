function [content,updated] = buffer_current(buf)

% buffer_current - get current buffer entry 
% ----------------------------------------
%
% [content,updated] = buffer_current(buf)
%
% Input:
% ------
%  buf - buffer
%
% Output:
% -------
%  content - content of current entry
%  updated - time current entry was updated

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

% get content at current index

content = buf.content{buf.index};

% get when content was updated if needed

if (nargout > 1) 
	updated = buf.updated(buf.index);
end
