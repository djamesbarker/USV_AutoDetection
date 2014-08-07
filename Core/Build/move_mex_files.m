function move_mex_files(source, destination)

%--
% handle input
%--

if ~nargin
    source = fullfile(xbat_root, 'MEX', [computer, '_', mexext]);
end

%--
% scan for MEX files and move to destination
%--

in = scan_dir_for(mexext, source);

for k = 1:numel(in)
    
    target = strrep(in{k}, source, destination);

    place = create_dir(fileparts(target));
    
    if isempty(place)
        error('Failed to create destination place for MEX file.');
    end
    
    copyfile(in{k}, target);
end
