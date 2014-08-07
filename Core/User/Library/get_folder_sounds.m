function sounds = get_folder_sounds(p, rec, fun, pal)

% get_folder_sounds - get sounds in folder
% ----------------------------------------
%
% sounds = get_folder_sounds(p, rec, fun)
%
% Input:
% ------
%  p - directory to search for sounds
%  rec - recursive search flag
%  fun - sound callback
%
% Output:
% -------
%  sounds - sounds found in path

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 2268 $
% $Date: 2005-12-13 12:19:40 -0500 (Tue, 13 Dec 2005) $
%--------------------------------

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% set empty callback
%--

if nargin < 3
	fun = [];
end

%--
% set recursive flag
%--

if (nargin < 2) || isempty(rec)
	rec = 1;
end

%--
% set starting directory
%--

if (nargin < 1) || isempty(p)
	p = pwd;
end

%--
% determine depth of scan
%--

L = length(scan_dir(p));

%--
% create waitbar if needed
%--

if (nargin < 4) || isempty(pal)
	
	pal = folder_sounds_wait('Adding Folder ...');
	
	d = get(pal, 'userdata'); d.N = L; d.n = 0;
	
	set(pal, 'userdata', d);
	
end

%-------------------------------------------------
% RECURSIVE SEARCH
%-------------------------------------------------

if rec
	
	%--
	% make recursive directory traverse using scan_dir
	%--
	
	sounds = scan_dir(p, {@get_folder_sounds, 0, fun, pal});
	
	%--
	% finish up the waitbar
	%--
	
	waitbar_update(pal,'PROGRESS', ...
		'value', 1, 'message', 'done' ...
	);
	
	delete(pal);
	
	return;	
	
end 

%-------------------------------------------------
% GET FOLDER SOUNDS
%-------------------------------------------------

%--
% update waitbar, catch closed waitbar with return
%--

try
	wait_bar_update(pal, p);
catch
	sounds = []; return;
end
	
%--
% get sound files in folder 
%--

[F, ext] = get_format_files(p);

%--
% check for mixed file formats
%--

all_files = struct2cell(F);

all_files = all_files(3:end);

test = ~cellfun('isempty', all_files);

types = sum(test);

%--
% get indices to non-empty file types
%--

ix = find(test == 1);

%--
% add sounds depending on the number of types
%--

switch (types)
	
	%--
	% no supported sound files in directory
	%--
	
	case (0)
		
		sounds = [];
		
	%--
	% a single file type in directory
	%--
	
	% TODO: consider some test to determine if files are a file stream
	
	case 1

		while F.path(end) == filesep
			F.path(end) = [];
		end	
		
		try 
			sounds = sound_create('file stream', F.path);
			
			callback_fun(sounds,fun);	
			
			wait_list_update(pal, sounds);	
		catch		
			err = lasterr; err = err(strfind(err, 'Files'):end);
			
			str = { ...
				err, 'Would you like to add the files individually?' ...
			};
		
			result = quest_dialog(str, 'Add Individual Files?');
			
			if strcmp(result, 'Yes')
				sounds = get_sounds(F, ext, ix, fun, pal);
			end	
		end
		
	%--
	% mixed file types
	%--
	
	otherwise
		
		sounds = get_sounds(F, ext, ix, fun, pal);
end

%--
% return empty if needed
%--

% NOTE: this could happen if all sound creation attempts fail

if ~exist('sounds','var')
	sounds = [];
end 

%--
% make sure sounds array is columnar (so that it works with scan_dir)
%--

sounds = sounds(:);


%---------------------------------------
% GET_SOUNDS
%---------------------------------------

function sounds = get_sounds(F, ext, ix, fun, pal)

%--
% loop over file non-empty file extensions
%--

sounds = empty(sound_create([]));

for k = 1:length(ix)

	% NOTE: we index into the list of types to extract the list of files

	files = F.(ext{ix(k)});

	%--
	% loop over files of a specific type
	%--

	for j = 1:length(files)

% 		filej = [F.path, filesep, files{j}];

		filej = fullfile(F.path, files{j});
		
		try
			sound = sound_create('file', filej);
			
			if ~isempty(sound)
				callback_fun(sound, fun);
				
				wait_list_update(pal, sound);
				
				sounds(end + 1) = sound;
			end	
		catch
			nice_catch(lasterror);
		end

	end

end


%---------------------------------------
% CALLBACK_FUN
%---------------------------------------

function out = callback_fun(in,fun)

out = [];

if isempty(fun)
	return;
end

try
	%--
	% handle callbacks with parameters
	%--
	
	if iscell(fun)
		args = fun(2:end); fun = fun{1};
	else
		args = [];
	end
		
	%--
	% handle callbacks with no output
	%--
	
	if nargout(fun)
		if isempty(args)
			out = fun(in);
		else
			out = fun(in, args{:});
		end
	else
		if isempty(args)
			fun(in);
		else
			fun(in, args{:});
		end
	end
catch
	
	nice_catch(lasterror); %#ok<LERR>
end


%----------------------------------------
% FOLDER_SOUNDS_WAIT
%----------------------------------------

function h = folder_sounds_wait(name)

%-----------------------------
% WAITBAR CONTROLS
%-----------------------------

%--
% progress waitbar
%--

control = control_create( ...
	'name', 'PROGRESS', ...
	'alias', 'Get Folder Sounds ...', ...
	'style', 'waitbar', ...
	'confirm', 1, ...
	'lines', 1.15, ...
	'space', 2 ...
);

control(end + 1) = control_create( ...
	'style', 'separator', ...
	'type', 'header', ...
	'string', 'Details' ...
);

control(end + 1) = control_create( ...
	'name','sound_list', ...
	'lines',4, ...
	'space',0, ...
	'confirm',0, ...
	'style','listbox' ...
);

%-----------------------------
% CREATE WAITBAR
%-----------------------------

h = waitbar_group(name, control);


%-----------------------------
% WAIT_BAR_UPDATE
%-----------------------------

function wait_bar_update(pal, p)

if isempty(pal)
	return;
end

data = get(pal, 'userdata');

n = data.n; N = data.N;

waitbar_update(pal, 'PROGRESS', ...
	'value', n/N, 'message', ['Scanning ''', p, ''' for sounds'] ...
);

data.n = data.n + 1;

set(pal, 'userdata', data);


%-----------------------------
% WAIT_LIST_UPDATE
%-----------------------------

function wait_list_update(pal, sound)

%--
% get relevant control handles
%--

handles = get_control(pal, 'sound_list', 'handles');

list = get(handles.obj, 'string');

value = get(handles.obj, 'value');

%--
% update sound list
%--

if ~iscell(list)
	value = 1; list = {sound_name(sound)};
end

list = {list{:}, sound_name(sound)};

%--
% update control
%--

set(handles.uicontrol.text, ...
	'string', ['Sounds (', int2str(length(list)), ')'] ...
);

set(handles.obj, ...
	'string', list, 'value', value + 1 ...
);

drawnow;
