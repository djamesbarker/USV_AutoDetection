function exts = get_extension_ancestry(varargin)

% get_extension_ancestry - unravel extension ancestry
% ---------------------------------------------------
%
% exts = get_extension_ancestry(ext)
%
% Input:
% ------
%  ext - extension
%
% Output:
% -------
%  exts - ancestry
%
% NOTE: the ancestry list starts with the input extension

%--
% handle input
%--

% TODO: factor something like this to a parse input type function, it is used in various places

% NOTE: sometimes the length 2 case just builds a duck

switch length(varargin)
	
	case 1, ext = varargin{1};
		
	% NOTE: the input consists of the extension type and name
	
	case 2, ext = get_extensions(varargin{1}, 'name', varargin{2});
		
end

%--
% ancestors
%--

% NOTE: children contain their parent handle, they can reconsitute the parent

exts = ext;

while ~isempty(exts(end).parent)
	exts(end + 1) = exts(end).parent.main();
end

