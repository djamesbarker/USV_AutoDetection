function pal = refresh_extension(callback, context)

% refresh_extension - update browser extension state
% --------------------------------------------------
%
% pal = refresh_extension(callback, context)
%
% Input:
% ------
%  callback - callback context
%  context - extension context
%
% Output:
% -------
%  pal - new extension palette

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

% NOTE: this function may use 'set_browser_extension'

%-----------------------------
% SETUP
%-----------------------------

%--
% unpack input
%--

pal = callback.pal; par = callback.par; 

ext = context.ext;

%-----------------------------
% REFRESH EXTENSION
%-----------------------------

%--
% close palette
%--

close(pal.handle);

%--
% refresh extension
%--

% TODO: figure out where to put a refresh of the system extension cache

data = get_browser(par.handle);

[ext, ix] = get_browser_extension(ext.subtype, par.handle, ext.name, data);

data.browser.(ext.subtype).ext(ix) = extension_initialize(ext, context);

set(par.handle, 'userdata', data);

%--
% open palette
%--

pal = extension_palettes(par.handle, ext.name, ext.subtype);
