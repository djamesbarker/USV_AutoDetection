function root = xbat

% xbat - start xbat
% -----------------
%
% xbat
%
% NOTE: this function starts the XBAT environment

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

%-------------------------------
% SETUP
%-------------------------------

%--
% set matlab properties
%--

% NOTE: name warning currently triggers on private functions

warning('off', 'MATLAB:dispatcher:nameConflict');

%--
% take care of some settings for linux
%--

if isunix
    
	% NOTE: this is voodoo, it may not work in the future
	
	setappdata(0, 'UseNativeSystemDialogs', false);
	
    % NOTE: this color was empirically derived
    
	set(0, 'DefaultFigureColor', [0.91, 0.89, 0.85]); 
	
    set(0, 'DefaultUicontrolBackgroundColor', [0.91, 0.89, 0.85]); 
    
end

% NOTE: we can set delete to use the recycling bin

recycle('off');

%-------------------------------
% INITIALIZE PATH
%-------------------------------

[root, init_path] = initialize_path;
    
%--
% install platform and version appropiate MEX files 
%--

install_mex;

%--
% set XBAT root
%--

% NOTE: we wait to set the root until we append the path

update = ~isempty(get_env('xbat_root'));

set_env('xbat_root', root); 

% NOTE: we can effectively use many XBAT functions after this point

%-------------------------------
% SET GRAPHICS PROPERTIES
%-------------------------------

%--
% set figure properties
%--

set(0, 'DefaultFigureMenubar', 'none');

%--
% set text properties
%--

fonts = get_simple_fonts; font.name = fonts{1}; font.size = 8;

set_text_properties(font);

%-------------------------------
% CONFIGURE PALETTES
%-------------------------------

%--
% palette size
%--

% NOTE: allowed values are: 'smaller', 'small', 'medium', 'large', and 'larger'

height = get(0, 'screensize'); height = height(4);

palette_size = 'small';

if height <= 1050
	palette_size = 'smaller';
end
	
if height <= 768
	palette_size = 'smallest';
end

set_env('palette_size', palette_size);

%--
% other palette options
%--

% NOTE: allowed values are 'on' and 'off'

set_env('palette_gradient', 'on');

set_env('palette_sounds', 'on');

set_env('palette_tooltips', 'on');

% TODO: consider revealing the hover behavior here

%-------------------------------
% SHOW SPLASH 
%-------------------------------

%--
% create splash
%--

% NOTE: determine the number of displayed startup steps, these are the ticks

ticks = 2 * 6 + length(get_extension_names) + length(get_formats);

% NOTE: we do this here because splash uses palette properties

% TODO: use different images for initial load and refresh

if ~update
	splash = splash_wait('', ticks);
else
	clear('functions'); splash = splash_wait('', ticks);
end

%--
% display fictitious yet informative messages
%--

first_steps = {'computing path', 'appending path', 'setting root', 'configuring gui'};

for k = 1:length(first_steps)
	splash_wait_update(splash, [first_steps{k}, ' ...']);
end

%------------------------------------------
% CONSIDER ROOT CHANGE
%------------------------------------------

splash_wait_update(splash, 'updating users ...');

users_root_update;

%------------------------------------------
% REFRESH EXTENSIONS
%------------------------------------------

get_formats(1);

% NOTE: consider allowing number input for this function

get_extensions('!');

%------------------------------------------
% OPEN XBAT PALETTE
%------------------------------------------

splash_wait_update(splash, 'opening xbat palette ...');

% NOTE: this is where the extensions get loaded

xbat_palette; 

pause(0.5); close(splash);

set_env('palette_sounds', 'on');

%------------------------------------------
% MISC 
%------------------------------------------

%--
% PREFERENCES AND MODES
%--

% NOTE: this sets an environment variable used by other functions

%--
% user options
%--

show_desktop 1;

show_other_sounds 0;

%--
% developer options
%--

xbat_developer 1;

pcode_refresh('clear');

%--
% start palette daemon
%--

stop(palette_daemon); start(palette_daemon);

% NOTE: this suppresses output display

if ~nargout
	clear root;
end

%--
% check for updates
%--

% xbat_update('startup');

%--
% handle migration on first use, when system seems empty
%--

users = get_users;

% if (length(users) == 1) && (length(users(1).library) == 1) && isempty(get_library_sounds)
% 	
% 	result = quest_dialog( ...
%         {'Would you like to migrate ', 'Users and libraries from ', 'an old version of XBAT?'}, ...
%         'Import Old Version' ...
% 	);
% 	
% 	if strcmp(result, 'Yes')
% 		migrate_xbat;
% 	end
% 	
% end

%--
% try to initialize wavelab
%--

% TODO: figure out where to put this code

pi = pwd;

if ~isempty(toolbox_which('WavePath'))
	
	try
		cd(fullfile(toolbox_root('Wavelab'), 'Wavelab850')); startup;
	catch
		nice_catch(lasterror, 'Failed to initialize ''Wavelab''.');
	end
	
end

cd(pi);
	

%--------------------------------
% GET_PATH_STR
%--------------------------------

function str = get_path_str(root, mode)

% get_path_str - add directories to path
% ----------------------------------
%
% str = get_path_str(root, 'flat')
%     = get_path_str(root, 'rec')
%
% Input:
% ------
%  root - initial directory
%
% Output:
% -------
%  str - string appended to path

%-----------------
% HANDLE INPUT
%-----------------

if nargin < 2
	mode = 'flat'; 
end 

%-----------------
% SETUP
%-----------------

% NOTE: the order is MATLAB, XBAT, Tools, and MISC

EXCLUDE_DIRS = { ...
	'Patches', ...
	'private', ...
	'Presets', ...
	'Users', ...
	'RadRails', ...
	'apache', ...
	'iconv', ...
	'share', ...
	'rails_apps', ...
	'phpmyadmin', ...
	'ruby', ...
	'MSYS', ...
	'CVS' ...
};

%-----------------
% BUILD STRING
%-----------------

out = what_ext(root);
		
str = out.path;

for k = 1:length(out.dir)

	%--
	% skip dot and method, then excluded directories
	%--

	if (out.dir{k}(1) == '.') || (out.dir{k}(1) == '@')
		continue;
	end

	if ~isempty(find(strcmp(out.dir{k}, EXCLUDE_DIRS), 1))
		continue;
	end

	%--
	% handle add mode
	%--
	
	switch mode

		case 'flat'
			part = [root, filesep, out.dir{k}];

		case 'rec'
			part = get_path_str([root, filesep, out.dir{k}], 'rec');

	end
	
	%--
	% append partial path string to path string
	%--
	
	str = [str, pathsep, part];

end


%--------------------------------
% WHAT_EXT
%--------------------------------

function out = what_ext(source, varargin)

% what_ext - get directory content information using extensions
% -------------------------------------------------------------
%
% out = what_ext(source, ext1, ..., extN)
%
% Input:
% ------
%  source - source directory 
%  ext - desired file extensions
%
% Output:
% -------
%  out - structure with path, file extensions, and dir

%-----------------
% HANDLE INPUT
%-----------------

%--
% set directory
%--

if (nargin < 1) || isempty(source)
	source = pwd;
end

%--
% set extensions to search
%--

if length(varargin) < 1
	ext = [];
else
	ext = varargin;
end

%-----------------
% GET CONTENTS
%-----------------

%--
% output path field 
%--

out.path = source;

%--
% get directory contents
%--

content = dir(source); 

% NOTE: this removes self and parent directory references

content = content(3:end); 

%--
% get children directory contents
%--

D = {};

for k = length(content):-1:1
	
	if content(k).isdir
		D{end + 1} = content(k).name; content(k) = [];
	end
	
end

out.dir = flipud(D(:));

if isempty(ext)
	return;
end

%--
% get files with specified extensions
%--

for i = 1:length(ext)
	
	%--
	% create list of selected filenames
	%--
	
	L = {};
	
	for k = length(content):-1:1
		
		%--
		% get extension from name
		%--
		
		ix = findstr(content(k).name, '.');
		
		% NOTE: file has no extension in name
		
		if isempty(ix)
			continue;
		end
		
		r = content(k).name(ix(end) + 1:end);
		
		%--
		% select file based on extension
		%--
		
		% NOTE: consider making this case insensitive, at least optional
		
		if strcmp(r, ext{i})
			L{end + 1} = content(k).name; content(k) = [];
		end
		
	end
	
	L = flipud(L(:));
		
	%--
	% put cell array into field
	%--
	
	out.(ext{i}) = L;

end


%--------------------------------
% SET_TEXT_PROPERTIES
%--------------------------------

function set_text_properties(font)

% set_text_properties - set default text properties
% -------------------------------------------------
%
% set_text_properties(font)
%
% Input:
% ------
%  font - font structure

%--
% figure properties
%--

set(0, 'DefaultTextInterpreter', 'none');

%--
% axes properties
%--

set(0, ...
	'DefaultAxesFontName', font.name, ...
	'DefaultAxesFontSize', font.size ...
);

%--
% text properties
%--

set(0, ...
	'DefaultTextFontName', font.name, ...
	'DefaultTextFontSize', font.size ...
);

%--
% uicontrol properties
%--

set(0, ...
	'DefaultUicontrolFontName', font.name, ...
	'DefaultUicontrolFontSize', font.size ...
);


%--------------------------------
% GET_SIMPLE_FONTS
%--------------------------------

function fonts = get_simple_fonts

% get_simple_fonts - get available simple fonts
% ---------------------------------------------
%
% fonts = get_simple_fonts
%
% Output:
% -------
%  fonts - available simple fonts

%--
% declare simple fonts
%--

% NOTE: this is the preferred order

simple = { ...
	'Comic Sans MS', ...
	'comic sans ms', ...
	'Lucida Sans MS', ...
	'lucidasans', ...
	'Trebuchet MS', ...
	'trebuchet ms', ...
	'Century Gothic', ...
	'gothic', ...
	'Arial', ...
	'Lucida Console', ...
	'Tahoma', ...
	'Palatino Linotype', ...
	'Times New Roman', ...
    'Times', ...
    'Courier', ...
	'Verdana' ...
};

%--
% get available simple fonts
%--

[fonts, ix] = intersect(simple, listfonts); 

if isempty(ix)
	error('Unable to find any of the simple fonts.');
end

fonts = simple(sort(ix))';


%-------------------------------
% INITIALIZE_PATH
%-------------------------------

function [root, start_path] = initialize_path

%--
% get xbat path
%--

root = fileparts(mfilename('fullpath'));

xbat_path = get_path_str(root, 'rec'); 

%--
% get initial path
%--

start_path = path;

init_path = strread(path, '%s', 'delimiter', pathsep);

init_path = setdiff(init_path, strread(xbat_path, '%s', 'delimiter', pathsep));

%--
% restore default if possible
%--

if ~isempty(which('restoredefaultpath'))

    try
	    restoredefaultpath;
    catch
        disp(['NOTE: Failed to restore default path, this is a minor problem in this version of MATLAB.']); 
    end       
    
end

default_path = strread(path, '%s', 'delimiter', pathsep);

%--
% get user path
%--

user_path_set = setdiff(init_path, default_path);

user_path = '';

for k = 1:length(user_path_set)
	user_path = [user_path, user_path_set{k}, pathsep];
end

%--
% concatenate paths together, making sure that the user path is under xbat
%--

path(path, xbat_path);

path(path, user_path);

%--
% display message if path is changed
%--

if numel(user_path_set)
	
% 	str = ' WARNING: XBAT has modified the MATLAB path.';
% 	
% 	n = max(64, length(str) + 1); line = str_line(n, '_');
%
% 	disp(' ')
% 	
% 	disp(line);
% 	disp(' ');
% 	disp(str);
% 	disp(line);
% 	
% 	disp(' ');
% 
% 	disp(' MESSAGE:'); 
	disp(' ');
	disp(' To ensure proper execution, XBAT has moved the following to the end of the MATLAB path:');
	disp(' ');
    
	for k = 1:numel(user_path_set)
		disp([' ', int2str(k), '. ', user_path_set{k}]);
	end
	
	disp(' ');
	disp(' To restore the previous path, restart MATLAB.');
	disp(' ');
	
% 	disp(line);
% 	disp(' ');
% 
% 	disp(' ');
	
end

