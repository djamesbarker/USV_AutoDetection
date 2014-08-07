function ext = get_callback_extension(callback) 

% get_callback_extension - get extension from callback context
% ------------------------------------------------------------
%
% ext = get_callback_extension(callback)
%
% Input:
% ------
%  callback - callback context
%
% Output:
% -------
%  ext - extension in callback context

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
% get extension type from palette tag
%--

tag = parse_tag(callback.pal.tag, '::', {'ignore', 'type', 'ignore'});

type = lower(tag.type);

%--
% get extension from parent browser if possible
%--

if ~isempty(callback.par.handle)
	ext = get_browser_extension(type, callback.par.handle, callback.pal.name);
else
	ext = get_extension(type, callback.pal.name, callback.pal.handle);
end

