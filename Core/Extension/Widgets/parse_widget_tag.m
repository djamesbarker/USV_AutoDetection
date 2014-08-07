function info = parse_widget_tag(tag)

% parse_widget_tag - parse widget tag to get info
% -----------------------------------------------
%
% info = parse_widget_tag(tag)
%
% Input:
% ------
%  tag - widget figure tag
% 
% Output:
% -------
%  info - widget info

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
% configure and parse tag
%--

sep = '::'; fields = {'header', 'type', 'name', 'user', 'library', 'sound', 'listen'};

info = parse_tag(tag, sep, fields);

%--
% parse listen string to make event information explicit
%--

info.listen = parse_listen(info.listen);


%-------------------------------
% PARSE_LISTEN
%-------------------------------

function listen = parse_listen(str)

% parse_listen - parse listener binary indicator string
% -----------------------------------------------------
%
% listen = parse_listen(str)
%
% Input:
% ------
%  str - indicator binary string
%
% Output:
% -------
%  listen - event listener indicator struct

%--
% setup
%--

event = get_widget_events;

% NOTE: does this break for other character sets?

value = double(str) - double('0');

%--
% parse listen into struct
%--

listen = struct; 

for k = 1:length(event)
	listen.(event{k}) = value(k);
end

% NOTE: this is currently the most expensive line

listen = collapse(listen);
