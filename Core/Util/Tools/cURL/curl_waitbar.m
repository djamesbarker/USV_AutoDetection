function pal = curl_waitbar(file, pal)

%--
% create waitbar if needed
%--

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

if nargin < 2

	control = control_create( ...
		'name', 'PROGRESS', ...
		'style', 'waitbar', ...
		'confirm', 1, ...
		'update_rate', [] ...
	);
	
	control(end + 1) = control_create( ...
		'name', 'close_on_completion', ...
		'style', 'checkbox', ...
		'value', 1 ...
	);
	
	pal = waitbar_group('CURL', control); curl_daemon(file, pal);
	
	waitbar_update(pal, 'PROGRESS', 'message', file.message);
	
end

%--
% update waitbar
%--

% TODO: this is the update for the 'download' modality of the function

info = dir(file.name);

if isempty(info)
    info(1).bytes = 0;
end

value = info.bytes / file.total;

waitbar_update(pal, 'PROGRESS', ...
	'value', value ...
);

% [bytes, unit] = get_unit_bytes(info.bytes); bytes = integer_unit_string(bytes, upper(unit), 0);

bytes = int2str(info.bytes);

waitbar_update(pal, 'PROGRESS', ...
	'message', [file.message, '  (', bytes, ')'] ...
);

%--
% consider if we need to close the waitbar
%--

close_on_completion = get_control_value(pal, 'close_on_completion');

if (value == 1) && ~isempty(close_on_completion) && close_on_completion
	close(pal);
end
