function build

% build - build mex files in a 'MEX' directory
% --------------------------------------------
% 
% Move to a 'MEX' directory and call build to build contents

% NOTE: this is very paranoid, consider something smarter and faster

clear('*_mex');

%--
% check we are in MEX directory
%--

here = pwd;

if here(end) == filesep
    here(end) = [];
end

if ~strncmp(fliplr(here), 'XEM', 3)
	disp(' ');
	disp('This is not a ''MEX'' directory, there is nothing to build!'); 
	disp(' ');
	return;
end

%--
% build using custom build scipt
%--

private = fullfile(here, 'private');

if exist(fullfile(private, 'build.m'), 'file')
    
    try
        cd(private); build; cd(here); return;
    catch
        cd(here); disp(['custom build script failed for "', here, '": ', lasterr]);
    end
    
end

%--
% build generically
%--

content = dir; names = {content.name};

if isempty(names)
	return;
end

%--
% get linker flags from file if possible
%--

linkflags = {};

if any(strcmp(names, 'deps.txt'))
    
    deps = file_readlines('deps.txt');
    
    for k = 1:length(deps)
        linkflags{k} = strrep(deps{k}, 'lib', '-l');
    end
    
end

disp(' ');

for ix = 1:length(names)
    
	if string_ends(names{ix}, '_mex.c') || string_ends(names{ix}, '_.c')
		disp(['Building ''' names{ix} ''' ...']); build_mex(names{ix}, linkflags{:});
	end
	
end	 

disp(' ');

disp('Moving files to private folder.');

movefile(['*.', mexext], '../private');

