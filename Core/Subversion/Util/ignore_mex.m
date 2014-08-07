function ignore_mex

root = fullfile(xbat_root, 'Core');

update = scan_dir(root, @(p)(ternary(string_contains(p, 'private'), p, [])));

% iterate(@disp, update);

for k = 1:numel(update)
	svn('propset', 'svn:ignore', '-F ignore_mex.txt', update{k});
end
