function updates = xbat_update(event)

% xbat_update - check for and possibly get xbat updates
% -----------------------------------------------------
%
% xbat_update(event)
%
% Input:
% ------
%  event - update event string 'startup' or 'request'

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

% TODO: make sure that message links open in system browser, not the matlab browser

if ~nargin
	event = 'request';
end

% NOTE: a week

update_interval = 60 * 60 * 24 * 7;

%-------------------------------
% SETUP
%-------------------------------

%--
% get short xbat version string
%--

% NOTE: this is the current xbat version name!

current = xbat_version; 

ix = strfind(lower(current), '('); 

if ~isempty(ix) && (ix(1) > 1)
	current = strtrim(current(1:(ix(1) - 1)));
end

%--
% check svn status
%--

% NOTE: check if we are a working copy so we can use subversion updates

copy = is_working_copy(xbat_root);

%-------------------------------
% CHECK
%-------------------------------

% NOTE: the last update date is stored in text file next to this function

last_update = [fileparts(mfilename('fullpath')), filesep, 'xbat_update.txt'];
	
%--
% check last update when considering automatic update
%--

if strcmpi(event, 'startup')

	%--
	% read last update store, create if needed
	%--

	if ~exist(last_update, 'file')
		last = clock; file_writelines(last_update, {mat2str(last)}); first_time = 1;
	else
		first_time = 0; lines = file_readlines(last_update); last = eval(lines{1});
	end

	%--
	% return if we have updated recently
	%--
	
	% NOTE: currently we have a seven day hardcoded period on automatic updates
	
	if ~first_time && (etime(clock, last) < update_interval)
		return;
	end
	
end

%--
% create update query url
%--

% NOTE: 'version' returns a string with the matlab version

url = ['http://xbat.org/update/?', ...
	'xbat=', escape_get(current), '&svn=', int2str(copy), '&matlab=', escape_get(version), '' ...
];

%--
% query server for update info
%--

% TODO: handle failure and no update conditions

try
	updates = urlread(url);
catch
	updates = '';
end

if isempty(updates)
	return;
end

%--
% parse update info
%--

try
	
	updates = strread(updates, '%s', -1, 'delimiter', ';');

	info = struct;

	for k = 1:length(updates)

		[field, value] = strtok(updates{k}, ':');

		if ~isempty(value)
			value = strtrim(value(2:end));
		end

		info.(field) = value;

	end
	
	if isfield(info, 'devel')
		info.devel = eval(info.devel);
	end
	
catch 
	
	return;
	
end 

%--
% update last update request file
%--

file_writelines(last_update, {mat2str(clock)});

% NOTE: we don't need to update if this is the first time!

if strcmpi(event, 'startup') && first_time
	return;
end

%-------------------------------
% ASSIST UPDATE OR UPDATE
%-------------------------------

%--
% assist manual update
%--

if ~copy
	
	% TODO: compare the release name strings then do something!
	
%--
% update using subversion
%--

% NOTE: we skip the confirm dialog here, you can always roll back

% TODO: store previous revision rollback

else

    % NOTE: this is necessary if anything will be deleted during the update.
    
    cd(xbat_root);
    
    clear('functions');
	
	disp(' '); disp('Updating XBAT ...'); start = clock;
	
	if ~isempty(tsvn_root)
		
		tsvn_options('block', 1); status = tsvn('update', xbat_root);
		
	else
		
		svn('update', xbat_root); status = 0;
		
	end
	
	% NOTE: non-zero status indicates premature termination, no need for update

    if status
		disp(['Update not complete. (', sec_to_clock(etime(clock, start)), ')']); return;
	end
    
	disp(['Done. (' sec_to_clock(etime(clock, start)), ')']);
	
	%--
	% restart the system
	%--
	
	disp(' '); disp('Restarting XBAT session ...'); start = clock;
    
	[ignore, file] = save_session('update_session'); close('all');
	
	xbat; 
	
	if ~isempty(file)
		open_session('update_session');	delete(file);
	end
	
	disp(['Done. (' sec_to_clock(etime(clock, start)), ')']);

end


%-------------------------------
% ESCAPE_GET
%-------------------------------

function str = escape_get(str)

str = strrep(str, '  ', ' '); 

str = strrep(str, ' ', '%20');


%-------------------------------
% STR_LT
%-------------------------------

function value = str_lt(a, b)

% NOTE: this function puts the two strings in a cell sorts them to test order

if ~ischar(a) || ~ischar(b)
	value = []; return;
end

order = sort({a, b}); value = isequal(a, order{1});


%-------------------------------
% STR_LTI
%-------------------------------

function value = str_lti(a, b)

% NOTE: this function puts the two strings in a cell sorts them to test order

if ~ischar(a) || ~ischar(b)
	value = []; return;
end

a = lower(a); b = lower(b);

order = sort({a, b}); value = isequal(a, order{1});

	
