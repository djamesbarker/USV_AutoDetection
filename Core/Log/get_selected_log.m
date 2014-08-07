function [log, lib] = get_selected_log(pal)

% get_selected_log - get log selected in XBAT palette
% ---------------------------------------------------
%
% [sound, lib] = get_selected_log(pal)
%
% Input:
% ------
%  pal - palette
%
% Output:
% -------
%  log - the log
%  lib - library containing log

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

if ~nargin || isempty(pal)	
	pal = get_palette(0, 'XBAT');
end

if isempty(pal)
	return;
end

lib = get_active_library;

log = {}; lib = [];

%--
% get selected logs from names
%--

string = get_control(pal, 'Logs', 'value');

for k = 1:length(string)

	name = parse_tag(string{k}, filesep, {'sound', 'log'});

	log{k} = get_library_logs('logs', lib, name.sound, name.log);

end

log = [log{:}];

