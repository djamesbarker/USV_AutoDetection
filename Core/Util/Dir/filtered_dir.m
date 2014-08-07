function content = filtered_dir(root, filter, scan, verb)

% filtered_dir - content
% ----------------------
%
% content = filtered_dir(root, filter, scan, verb)
%
% Input:
% ------
%  root - for content
%  filter - for content
%  scan - root recursively (def: false)
%  verb - verbose display (def: false)
%
% Output:
% -------
%  content - filtered
%
% NOTE: for best results the filter should work with a 'content' array

%--
% handle input
%--

if nargin < 4
	verb = false; 
end

if nargin < 3
	scan = false;
end

if nargin < 2
	filter = []; 
end

if ~nargin
	root = pwd; 
end

% NOTE: use directory scan and iteration to a tree

if scan	
	content = iterate(mfilename, scan_dir(root), filter, false, verb); return;
end

%--
% get full direcory content
%--

content = dir(root);

for k = 1:numel(content)
	content(k).path = root;
end

if isempty(filter)
	if verb && ~isempty(content)
		iterate(@disp, strcat({content.path}, filesep, {content.name}))
	end
	
	return;
end

%--
% apply filter to listing
%--

% NOTE: allow for the filter to be vectorized, we use try along with an output check

try
	select = apply_filter(content, filter);
	
	if ~isequal(numel(select), numel(content))
		error('Filter is not vectorized.');
	end
catch
	for k = 1:numel(content)
		select(k) = apply_filter(content(k), filter);
	end
end
	
% TODO: consider the possibility that 'keep' or 'delete' might be better

content(~select) = [];

if verb && ~isempty(content)
	iterate(@disp, strcat({content.path}, filesep, {content.name}))
end


%--------------------
% APPLY_FILTER
%--------------------

% NOTE: we allow for simple or cell callbacks

function select = apply_filter(content, filter)

if iscell(filter)
	select = filter{1}(content, filter{2:end});
else
	select = filter(content);
end

	
	
