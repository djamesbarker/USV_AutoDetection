function build_private

% build_private - build then move to private sibling directory
% ------------------------------------------------------------
%
% Move to 'MEX directory and call 'build_private' to build contents
% and move to a 'private' sibling directory.

build;

eval(['movefile *.', mexext, ' ..', filesep, 'private', filesep, '.']);
