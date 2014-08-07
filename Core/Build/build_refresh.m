function build_refresh

root = fullfile(xbat_root, 'Core', 'Build');

delete(fullfile(root, 'Magic', '*.o'));

delete(fullfile(root, 'Magic', '*.a'));
