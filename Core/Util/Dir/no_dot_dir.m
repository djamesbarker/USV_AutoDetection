function content = no_dot_dir(root, only_dirs)

% no_dot_dir - get children directories that do not start with dot
% ----------------------------------------------------------------
%
% content = no_dot_dir(root, only_dirs, filter)
%
% Input:
% ------
%  root - root
%  only_dirs - indicator, set to -1 for only files
%
% Output:
% -------
%  child - children

% TODO: consider adding only files or directories option

%--
% set all content default
%--

if nargin < 2
	only_dirs = 0;
end

%--
% set current directory default
%--

if ~nargin
	root = pwd;
end

%--
% get children directories without dots
%--

content = dir(root);

for k = length(content):-1:1
    
	% NOTE: we always skip 'dot' elements, we also skip method directories
	
	if content(k).isdir && (content(k).name(1) == '.' || content(k).name(1) == '@' || content(k).name(1) == '_')
		content(k) = []; continue;
	end
	
	% NOTE: in this case we only get directory children
	
	if (only_dirs == 1) && ~content(k).isdir
		content(k) = []; continue;
	end
	
	% NOTE: in this case we only get file children
	
	if (only_dirs == -1) && content(k).isdir
		content(k) = []; continue;
	end
	
end
