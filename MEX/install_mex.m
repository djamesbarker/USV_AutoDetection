function install_mex(mode)

% install_mex - install MEX files appropiate to platform and version
% ------------------------------------------------------------------
%
% install_mex(mode)
%
% Install:
% --------
%  mode - for install 'lazy' (default) or 'force'
%
% NOTE: 'lazy' checks whether MEX files are available, 'force' reinstalls
% 
% See also: build_all

% TODO: consider forcing version, make 'current' an input

%--
% set lazy install default
%--

if ~nargin
	mode = 'lazy';
end

modes = {'force', 'lazy'};

if ~ismember(mode, modes)
	error(['Unrecognized MEX install mode ''', mode, '''.']);
end

%--
% check if we need to install
%--

% NOTE: compare currently required MEX package with most recently installed

[current, str] = get_current;

if isempty(current)
	error(str);
end

% NOTE: return if there is no last installed is same as current

if strcmp(mode, 'lazy') && strcmp(get_last, current)
	return;
end

%--
% install MEX package and create record of package installed
%--
	
disp(' ');
disp(['Installing platform and version appropriate MEX files (', current, ') ...']);
disp(' ');

start = clock;

installed = install_current(current);

if installed
	set_last(current);
end

elapsed = etime(clock, start);
	
% TODO: this must be moved after the install script runs

disp(' ');
disp(['Done. (', num2str(elapsed), ' sec)']);
disp(' ');


%-------------------
% GET_CURRENT
%-------------------

function [current, str] = get_current

%--
% initialize output
%--

current = ''; str = '';

%--
% consider matlab version
%--

ver = get_version;

if ver.major < 7
	str = 'XBAT is not supported on MATLAB versions earlier than 7.'; return;
end
		
%--
% select current MEX package to install considering architecture and version (unfortunately)
%--

switch computer
	
	% NOTE: generally the approach used here is correct, the other cases arise in special circumstances
	
	case 'PCWIN'
        current = [computer, '_', mexext];

% 		if ver >= 7.3
% 			current = 'PCWIN_mexw32';
% 		else
% 			current = 'PCWIN_dll';
% 		end
	
	case 'PCWIN64'
		current = 'PCWIN64_mexw64';
		
	case 'GLNX86'
		current = 'GLNX86_mexglx';
        
    case 'GLNXA64'
        current = 'GLNXA64_mexa64';
		
	case 'MACI'
		if ver.minor < 4
			str = 'XBAT is not supported on MATLAB versions earlier than 7.4 on Intel Mac.'; return;
        end
		
    	current = 'MACI_mexmaci';
        
    case 'MACI64'
        current = 'MACI64_mexmaci64';
		
	otherwise
		str = 'XBAT is not currently supported on this platform. You can contact the developers through ''xbat.org''.'; return;
			
end


%-------------------
% INSTALL_CURRENT
%-------------------

function installed = install_current(current)

installed = 1;

%--
% make sure we have an unzipped package
%--

file = source_root(current);

if ~exist(file, 'dir')
	
	if ~exist([file, '.zip'], 'file')
		installed = 0; return;
	end
	
	unzip([file, '.zip'], source_root);
end

%--
% scan package to install
%--

% NOTE: this is paranoid, we should not have any loaded MEX files when this is called

clear functions;

source = get_source_dirs(file); cuda_source = {};

for k = 1:length(source)
	
	destination = strrep(source{k}, source_root(current), install_root);
	
	if ~string_contains(destination, ['private', filesep, 'CUDA'])
		
		target = destination; destination = create_dir(destination);

		if isempty(destination)
			disp(['Failed to create destination ''', target, '''.']); continue;
		end
		
		clean_destination(destination);
	end
	
	try
		% TODO: factor as 'copy_files'
		
		content = dir(source{k});
		
		for j = 1:length(content)
			
			if content(j).isdir
				if strcmpi(content(j).name, 'cuda')
					cuda_source{end + 1} = fullfile(source{k}, content(j).name); %#ok<AGROW>
				end
				
				continue;
			end

			file = fullfile(source{k}, content(j).name); disp([' ', strrep(file, source_root(current), '(app_root)')]);
			
			copyfile(file, destination, 'f');		
		end
		
	catch
		installed = 0;
	end
	
end

%--
% install CUDA MEX files
%--

% NOTE: the cuda MEX files that examine capability have already been installed

% NOTE: if we have found no special directories return

% NOTE: disable CUDA install for stable release

% if isempty(cuda_source)
% 	return;
% end
% 
% try
% 	[available, level] = has_cuda;
% 	
% 	% TODO: figure out the right solution, probably allowing the user to indicate a version
% 	
% 	if numel(level) > 1 && numel(unique(level)) > 1
% 		
% 		error('CUDA devices have diverse capabilities. We cannot decide which helpers to install.');
% 	else
% 		level = level(1);
% 	end 
% 
% 	% NOTE: if cuda hardware is not available return, note that we've been able to test here
% 	
% 	if ~available
% 		return;
% 	end
% 	
% 	disp(' ');
% 	disp(['CUDA level ', num2str(level), ' hardware is available, installing CUDA MEX files ...']);
% 	disp(' ');
% 	
% 	level = supported_cuda_level(level);
% 	
% 	for k = 1:numel(cuda_source)
% 		current = fullfile(cuda_source{k}, num2str(level));
% 		
% 		if k > 1
% 			disp(' ');
% 		end
% 		
% 		disp([' From ', current, ':']);
% 		
% 		content = no_dot_dir(current);
% 		
% % 		db_disp; cuda_source{k}, current, disp(content)
% 		
% 		for j = 1:numel(content)
% 			% NOTE: this is the file we have to move
% 						
% 			file = fullfile(current, content(j).name);
% 			
% 			destination = strrep(current, source_root(current), install_root);
% 			
% 			% NOTE: the source contains two additional directory levels, the 'CUDA' indicator and the 'level' directory
% 			
% 			destination = fileparts(fileparts(destination));
% 		
% 			disp([' ', strrep(fullfile(destination, content(j).name), source_root(current), '(app_root)')]);
% 			
% % 			db_disp cuda-install; disp(file); disp(destination);
% 			
% 			copyfile(file, destination, 'f');
% 		end
% 	end
% 	
% catch
% 	% NOTE: in this case we were unable to test for the presence of the CUDA device
% 	
% 	nice_catch(lasterror, 'Machine does not have a CUDA device, or appropriate drivers are not installed.');
% end


%-------------------
% GET_LAST
%-------------------

function last = get_last

% NOTE: retrieve last-install package name from file if available

if ~exist(last_file, 'file')
	last = '';
else
	fid = fopen(last_file, 'rt'); last = fgetl(fid); fclose(fid);
end


%-------------------
% SET_LAST
%-------------------

function set_last(current)

% NOTE: store current package name to last-install file

fid = fopen(last_file, 'wt'); fprintf(fid, '%s\n', current); fclose(fid);


%-------------------
% LAST_FILE
%-------------------

function file = last_file

% NOTE: the name of the file we use to store the last-install package name

file = fullfile(source_root, 'last-install.txt');


%-------------------
% SOURCE_ROOT
%-------------------

function root = source_root(current)

% NOTE: this function is in the MEX root directory

root = fileparts(mfilename('fullpath'));

if nargin
	root = fullfile(root, current);
end

%---------------------
% SUPPORTED_CUDA_LEVEL
%---------------------

function supported_level = supported_cuda_level(level)

if level >= 1.3
	supported_level = 1.3;
else
	if level >= 1.1
		supported_level = 1.1;
	else
		supported_level = -1.0;	% Not supported
	end
end
	

%-------------------
% INSTALL_ROOT
%-------------------

function root = install_root

% NOTE: this function is in the MEX root directory

root = fileparts(source_root);


%-------------------
% NO_DOT_DIR
%-------------------

function content = no_dot_dir(root, dirs)

% NOTE: get children directories that do not have names starting with dot or underscore

%--
% handle input
%--

if nargin < 2
	dirs = 0;
end

if ~nargin
	root = pwd;
end

%--
% get and filter content
%--

content = dir(root);

for k = length(content):-1:1
    
	% NOTE: discard non-directory content if asked to
	
	if dirs && ~content(k).isdir
		content(k) = []; continue;
	end
	
	% NOTE: discard directories that start with dot or underscore
	
	if content(k).name(1) == '.' || content(k).name(1) == '_'
		content(k) = [];
	end  
end


%-------------------
% GET_SOURCE_DIRS
%-------------------

function dirs = get_source_dirs(root)

%--
% get contained directories
%--

content = no_dot_dir(root, 1); 

% NOTE: return empty when there is no content

if isempty(content)
	dirs = {}; return;
end

%--
% check for source directories recursively
%--

dirs = strcat(root, filesep, {content.name}); 

part = cell(size(dirs));

for k = 1:length(dirs)
	part{k} = get_source_dirs(dirs{k}); 	
end

for k = length(dirs):-1:1
	
	if ~has_files(dirs{k})
		dirs(k) = [];
	end	
end

for k = 1:length(part)
	dirs = {dirs{:}, part{k}{:}};
end

dirs = dirs(:);


%-------------------
% HAS_FILES
%-------------------

function value = has_files(root)

content = no_dot_dir(root);

value = any(~[content.isdir]);


%-------------------
% CLEAN_DESTINATION
%-------------------

function clean_destination(root)

exclude = {'.c', '.m', '.mat', '.txt'};

content = no_dot_dir(root);

for k = 1:length(content)
	
	if content(k).isdir
		continue;
	end 
	
	[ignore, ext] = strtok(content(k).name, '.'); %#ok<ASGLU>
	
	if ismember(ext, exclude)
		continue;
	end
	
	file = fullfile(root, content(k).name);
	
	try
		delete(file);
	catch
		
	end	
end


%-------------------
% GET_VERSION
%-------------------

function ver = get_version

ver = struct;

[ver.major, rest] = strtok(version, '.'); ver.major = eval(ver.major);

[ver.minor, rest] = strtok(rest, '.'); ver.minor = eval(ver.minor);

ver.build = strtok(rest, '.'); ver.build = eval(ver.build);




