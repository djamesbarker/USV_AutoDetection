function build_release

if ~ispc
	error('Currently this only works on Windows.');
end

%--
% create release root
%--

% NOTE: we have to select this directory from 'Tortoise' for the script to work

disp(' '); disp('Creating release root ...'); start = clock;

output = create_dir(fullfile(get_desktop, 'RELEASE'));

if isempty(output)
	error('Unable to create release root.');
end

elapsed = etime(clock, start); disp(['Done. (', sec_to_clock(elapsed), ')']);

%--
% export
%--

disp(' '); disp('Exporting XBAT ...'); start = clock;

tsvn_options('block', 1);

tsvn('export', xbat_root);

elapsed = etime(clock, start); disp(['Done. (', sec_to_clock(elapsed), ')']);

%--
% clean MEX files from tree
%--

disp(' '); disp('Removing currently installed MEX files ...'); start = clock;

[ignore, name] = fileparts(xbat_root);

release_root = fullfile(output, name);

clean_mex(release_root);

elapsed = etime(clock, start); disp(['Done. (', sec_to_clock(elapsed), ')']);

%--
% zip MEX packages
%--

disp(' '); disp('Compressing MEX file packages ...'); start = clock;

package_root = fullfile(release_root, 'MEX');

content = no_dot_dir(package_root);

for k = 1:length(content)
	
	if ~content(k).isdir
		continue; 
	end
	
	zip(fullfile(package_root, [content(k).name, '.zip']), content(k).name, package_root);
	
end

elapsed = etime(clock, start); disp(['Done. (', sec_to_clock(elapsed), ')']);

%--
% remove uncompressed MEX file packages
%--

disp(' '); disp('Removing uncompressed MEX file packages ...'); start = clock;

for k = 1:length(content)
	
	if ~content(k).isdir
		continue; 
	end
	
	rmdir(fullfile(package_root, content(k).name), 's');
	
end

elapsed = etime(clock, start); disp(['Done. (', sec_to_clock(elapsed), ')']);
