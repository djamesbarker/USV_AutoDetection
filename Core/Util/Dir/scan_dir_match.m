function dirs = scan_dir_match(pat, root, fun)

% scan_dir_match - scan for directories matching pattern
% ------------------------------------------------------
%
% dirs = scan_dir_match(pat, root, fun)
%
% Input:
% ------
%  pat - to match
%  root - for scan
%  fun - pattern matching helper (def: @strcmpi, insensitive)
%
% Output:
% -------
%  dirs - matching
% 
% See also: scan_dir

%--
% handle input
%--

if nargin < 3
	fun = @strcmpi;
end

if nargin < 2
	root = pwd;
end

% NOTE: no pattern means select all

if ~nargin
	pat = '';
end

%--
% scan and select on match
%--

if isempty(pat)
	dirs = scan_dir(root);
else
	dirs = scan_dir(root, {@match, pat, fun});
end


%--------------------
% MATCH
%--------------------

function file = match(file, pat, fun)

% NOTE: get directory name and match with pattern using fun

[ignore, name] = fileparts(file); %#ok<ASGLU>

if ~fun(name, pat)
	file = [];
end

