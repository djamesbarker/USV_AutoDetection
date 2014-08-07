function [helpers, root, type] = get_helpers(ext, type)

% get_helpers - get names of helper functions provided by extension
% -----------------------------------------------------------------
%
% [helpers, root, type] = get_helpers(ext, type)
%
% Input:
% ------
%  ext - extension
%  type - helper type
%
% Output:
% -------
%  helpers - names
%  root - helpers root

%--
% set default type
%--

if nargin < 2
	type = 'public';
end

%--
% get helpers of type
%--

switch type
	
	case 'public'

		root = [extension_root(ext), filesep, 'Helpers'];

		helpers = sort(file_ext(get_field(what_ext(root, 'm'), 'm')));
	
	case 'private'
		
		root = [extension_root(ext), filesep, 'private'];

		content = file_ext(get_field(what_ext(root, 'm'), 'm'));

		helpers = setdiff(content, extension_signatures(ext.subtype, ext.fun.main));
		
end
