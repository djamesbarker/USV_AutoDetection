function m = get_browser_log_index(par, name, data)

% get_browser_log_index - get index of named log in browser log array
% -------------------------------------------------------------------
%
% m = get_browser_log_index(par, name, data)
%
% Input:
% ------
%  par - browser handle
%  name - log name
%  data - browser state
%
% Output:
% -------
%  m - log index

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

% NOTE: the log index affects display

%--
% get open log names
%--

% NOTE: the name is the file name without extension

names = file_ext(struct_field(data.browser.log, 'file'));

%--
% compare names to input to get index
%--

m = find(strcmp(names, name));
