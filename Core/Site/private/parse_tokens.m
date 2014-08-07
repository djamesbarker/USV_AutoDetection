function [str, opt] = parse_tokens(tag, tok)

% PARSE_TOKENS parse field value tokens to get attributes string and options
%
% [str, opt] = parse_tokens(tag, tok)

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

%--
% initialize output
%--

str = ' '; opt = struct;

% NOTE: return if there is nothing to parse

if isempty(tok)
	return;
end

%--
% get known tag attributes
%--

attr = get_tag_attr(tag); 

%--
% parse tokens
%--

% NOTE: we get known attributes, other tokens are considered as options

for k = 1:length(tok)
	
	% NOTE: this is the simple token parser
	
	part = str_split(tok{k}, '=>'); 
	
	% TODO: handle failure to parse here, when we only get one part
	
	if ismember(part{1}, attr)
		
		str = [str, part{1}, '="', part{2}, '" '];
		
	else

		field = part{1};
		
		try
			value = eval(part{2});
		catch
			value = part{2};
		end
		
		opt.(field) = value;

	end
	
end


%------------------------------
% GET_TAG_ATTR
%------------------------------

function attr = get_tag_attr(type)

% GET_TAG_ATTR get attributes for tag type
% 
% attr = get_tag_attr(type)

%--
% list common tag attributes, there are available to image
%--

% NOTE: the basic attributes are tags and events

attr = { ...
	'class', 'id', 'title', ...
	'onclick', 'ondblclick', 'onfocus', 'onkeydown', 'onkeypress', 'onkeyup', ...
	'onmousedown', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup' ...
};

%--
% handle specific tags for attributes
%--

% NOTE: the type specific are display related or structural

switch type
	
	case {'img', 'images'}, attr = {attr{:}, 'alt'};
		
	% NOTE: these are not the typical links, they are 'head' links
	
	case {'script', 'scripts'}, attr = {};
		
	case {'style', 'styles'}, attr = {'media'};
		
end
