function obj = update_tags(mode, obj, tags, reps)

% update_tags - perform various tag update operations
% ---------------------------------------------------
%
% out = update_tags(mode, obj, tags, reps)
%
% Input:
% ------
%  mode - tags update mode
%  obj - taggable objects
%  tags - update tags (def: {})
%  reps - replace tags for replace update
%
% Output:
% -------
%  out - tagged objects

% Copyright (C) 2002-2012 Cornell University

%
% This file is part of XBAT.
% 
% XBAT is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% XBAT is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with XBAT; if not, write to the Free Software
% Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

%-------------------------------
% HANDLE INPUT
%-------------------------------

% NOTE: mode and input objects are required

%--
% check mode input
%--

% NOTE: consider output of update modes list

modes = {'set', 'get', 'has', 'add', 'subtract', 'replace'}; mode = lower(mode);

if ~ismember(mode, modes)
	error(['Unrecognized tags update mode ''', mode, '''.']);
end

%--
% check input is taggable
%--

if ~is_taggable(obj)
	error('Input objects are not taggable.');
end

% NOTE: tags are optional for various modes

%--
% set and check tags input
%--

if (nargin < 3)
	tags = {};
end

if ~is_tags(tags)
	error('Input tags are not valid tags.');
end

% NOTE: wrap string tags into cell to simplify further code

if ischar(tags)
	tags = {tags};
end
		
%-------------------------------
% UDPATE TAGS
%-------------------------------

% NOTE: tags are stored as a string cell array

switch mode

	%--
	% set tags
	%--
	
	case 'set'
		
		for k = 1:numel(obj)
			obj(k).tags = unique(tags(:));
		end

	%--
	% get tags
	%--
	
	case 'get'
		
		if numel(obj) == 1
			
			out = obj.tags;

			% NOTE: this should not be needed, the tags should be stored as as a cell array
			
			if ischar(out)
				out = {out};
			end
		else
			out = cell(size(obj));

			for k = 1:numel(obj)
				out{k} = obj(k).tags;
			end
		end
		
		obj = out;
		
	%--
	% has tag
	%--
	
	case 'has'
		
		out = zeros(size(obj));
		
		switch length(tags)

			% has any tags
			
			case 0
				for k = 1:numel(obj)
					out(k) = ~isempty(obj(k).tags);
				end

			% has specific tag
			
			case 1
				for k = 1:numel(obj)
					out(k) = ismember(tags, obj(k).tags);
				end

			% error
			
			otherwise
				error('Multiple tags are not allowed in ''has'' test, use ''find_tags''.');
		
		end
		
		obj = out;
		
	%--
	% add tags
	%--
	
	case 'add'
		
		if isempty(tags)
			return;
		end 
		
		for k = 1:numel(obj)
			obj(k).tags = union(obj(k).tags, tags)';
		end

	%--
	% subtract tags
	%--
	
	case 'subtract'
		
		if isempty(tags)
			return;
		end
		
		for k = 1:numel(obj)
			obj(k).tags = setdiff(obj(k).tags, tags)';
		end
		
	%--
	% replace tags
	%--
	
	case 'replace'
		
		% NOTE: replacement tags here are only used here, so they are handled here
		
		if ~is_tags(reps)
			error('Replacement tags are not valid tags.'); 
		end
		
		if ischar(reps)
			reps = {reps};
		end
		
		if numel(tags) ~= numel(reps)
			error('Replacement tags and tags must be of the same size.');
		end
		
		for k = 1:numel(obj)
			for j = 1:numel(tags)
				obj(k).tags = strrep(obj(k).tags, tags{j}, reps{j});
			end
		end
end

