function [status, result] = build_mex(files, libs, opt)

% build_mex - build a mex file from C source using MinGW if needed
% ----------------------------------------------------------------
%
% [status, result] = build_mex(files, libs, opt)
%
% opt = build_mex
%
% Input:
% ------
%  files - to build
%  libs - cell array or space-separated string list of library dependancies
%  opt - options
%
% Output:
% -------
%  status - numeric exit code from gcc
%  result - result from gcc
%  opt - default

%--
% handle input
%--

if nargin < 3
    opt.prefix = libs_root(); opt.cflags = ''; opt.ldflags = ''; opt.outname = ''; opt.verbose = true;
end

if nargin < 2 || isempty(libs)
    libs = [];
end

if ~nargin  
    status = opt; result = []; return;  
end

% NOTE: here process template files if needed

if ~iscell(files)
    files = str_split(files);
end

for k = 1:numel(files)

	if ~string_ends(files{k}, '.template')
		continue;
    end
    	
	result = generate_typed_mex(files{k});
	
	files{k} = fullfile(result.root, result.name);
end

%%%%%%%% MEX %%%%%%%%%

if isempty(libs)
	% TODO: integrate options into 'mex' call, this only includes 'outname' and 'verbose' at the moment
	
	for k = 1:numel(files)
		mex(files{k});
	end
	
	return;
end

%%%%%%% MinGW %%%%%%%%

%--
% setup
%--

if ~iscell(libs)
    libs = str_split(libs);
end

if ispc && isempty(mingw_root)
	error('Unable to find MinGW in "%s".', mingw_root);
end

if ispc
    [ignore, mex_libs] = create_import_libs(fullfile(opt.prefix, 'lib')); %#ok<ASGLU>
else
    mex_libs = {'libmat', 'libmex', 'libmx'};
end

%--
% get compiler
%--

switch computer
    case {'PCWIN', 'PCWIN32'}
		gcc = get_mingw_tool('gcc.exe');

    case 'PCWIN64'
        gcc = get_tool('x86_64-w64-mingw32-gcc.exe');
        
    otherwise
        gcc = get_tool('gcc');
end    

if isempty(gcc)
    error('''get_tool'' can''t find gcc.');
end

%--
% build compiler command
%--

name = [ternary(isempty(opt.outname), file_ext(files{1}), opt.outname), '.', mexext];

clear(name);

include_paths = { ...
    '.', ...
    fullfile(opt.prefix, 'include'), ...
    fullfile(matlabroot, 'extern', 'include') ...
};

if ispc
    lib_paths = { ...
        fullfile(opt.prefix, 'lib'), ...
        fullfile(matlabroot, 'extern', 'lib') ...
        };
else
    lib_paths = { ...
        fullfile(opt.prefix, 'lib') ...
        };
end

command = [ ...
    '"', gcc.file '" -shared -Wall -o ', name, ' ', str_implode(files), ' -DMATLAB_MEX_FILE ', ...
    str_implode(opt.cflags), ' ', str_implode(opt.ldflags), ' ', ...
    gcc_search_path(include_paths, '-I'), gcc_search_path(lib_paths, '-L'), ...
    gcc_lib_shortcut(mex_libs), gcc_lib_shortcut(libs) ...
];

if opt.verbose
    disp(command);
end

%--
% run it
%--

[status, result] = system(command);

if status && nargout < 2	
	disp(' ');
	
	lines = file_readlines(result);
	
	for k = 1:numel(lines)
		disp(['   ', lines{k}]);
	end
	
	if ~nargout 
		disp(' '); clear status result;
	end
end


%--------------------------------------------------------
% GCC_LIB_SHORTCUT 
%--------------------------------------------------------

% NOTE: a library linking shorthand for a cell array of libraries

function str = gcc_lib_shortcut(libs)

if ~iscell(libs)
    libs = str_split(libs);
end

str = '';

for k = 1:length(libs)
    [ignore, n] = fileparts(libs{k}); str = [str, strrep(n, 'lib', '-l'), ' ']; %#ok<ASGLU,AGROW>
end


%--------------------------------------------------------
% GCC_SEARCH_PATH
%--------------------------------------------------------

% NOTE: get gcc switch for lib or include search path

function str = gcc_search_path(paths, type)

if ~iscell(paths)
    paths = str_split(paths);
end

str = '';

for k = 1:length(paths)
    str = [str, type, '"', paths{k}, '" ']; %#ok<AGROW>
end

