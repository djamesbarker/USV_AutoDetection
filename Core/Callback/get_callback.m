function [callback, count] = get_callback(handle)

% get_callback - get callbacks from handle
% ----------------------------------------
%
% [callback, count] = get_callback(handle)
%
% Input:
% ------
%  handle - handle
%
% Output:
% -------
%  callback - handle callbacks struct
%  count - available callback count

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
% handle input
%--

if isempty(handle) || ~ishandle(handle)
	callback = struct; count = 0; return;
end

%--
% get handle callbacks and count them
%--

callback = get_callbacks(handle);

count = length(fieldnames(callback));


%------------------------------
% GET_CALLBACKS
%------------------------------

function callback = get_callbacks(handle)

fields = get_callback_fields(handle);

callback = struct;

for k = 1:length(fields)
	callback.(fields{k}) = get(handle, fields{k});
end


%------------------------------
% GET_CALLBACK_FIELDS
%------------------------------

function fields = get_callback_fields(handle)

fields = fieldnames(get(handle));

for k = length(fields):-1:1
	
	if ~isempty(strfind(lower(fields{k}), 'fcn')) || strcmpi(fields{k}, 'callback')
		continue;
	end

	fields(k) = [];
	
end
