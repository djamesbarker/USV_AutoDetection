function extension_warning(ext, str, info)

% extension_warning - produce warning for extension failure
% ---------------------------------------------------------
%
% extension_warning(ext, str, info)
%
% Input:
% ------
%  ext - extension producing message
%  str - message string
%  info - error info struct as provided by 'lasterror'

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

% TODO: use nice catch logging for extensions, consider local and centralized stores

%--
% put warning together using extension
%--

type_str = upper(strrep(ext.subtype, '_', ' ')); 

name_str = upper(ext.name);

str = ['WARNING: In ', type_str, ' extension ''', name_str, '''. ', str];

%--
% call nice catch
%--

nice_catch(info, str);
	
