function exts = get_extension_children(ext)

% get_extension_children - get extensions that are children
% ---------------------------------------------------------
%
% exts = get_extension_children(ext)
%
% Input:
% ------
%  ext - parent extension
%
% Output:
% -------
%  exts - children extensions

%--
% get child extensions
%--

% TODO: consider this as a function, we need to make sure we don't become stale

% NOTE: we need to persistently store a last modified timestamp with the extensions cache

% persistent CHILD;
% 
% if isempty(CHILD)
% 	
% 	CHILD = get_extensions;
% 	
% 	for k = length(CHILD):-1:1
% 		if isempty(CHILD(k).parent), CHILD(k) = []; end
% 	end 
% 	
% end
% 	
% exts = CHILD;

exts = get_extensions;

%--
% remove non-child extensions
%--

parent = ext.fun.main;

for k = length(exts):-1:1
	
	if isempty(exts(k).parent) || (exts(k).parent.main ~= parent)
		exts(k) = [];
	end
	
end

if numel(exts) > 1
	[ignore, ix] = sort({exts.name}); exts = exts(ix);
end
