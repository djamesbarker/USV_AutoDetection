function content = cached_scan_dir(root)

% cached_scan_dir - simple directory scan is cached
% -------------------------------------------------
%
% content = cached_scan_dir(root)
%
% Input:
% ------
%  root - of scan
%
% Output:
% -------
%  content - of root, directories
%
% See also: scan_dir

%--
% handle input
%--

if ~nargin
	root = pwd;
end

%--
% setup persistent store
%--

persistent CACHED_SCAN;

if isempty(CACHED_SCAN)
	CACHED_SCAN = struct;
end

%--
% scan or retrieve cached scan
%--

% TODO: use modification date to expire cache

key = get_key(root);

if isfield(CACHED_SCAN, key)
	content = CACHED_SCAN.(key);
else
	content = scan_dir(root); CACHED_SCAN.(key) = content;
end


%--------------------
% GET_KEY
%--------------------

function key = get_key(source)

key = ['key_', hash(source)];
