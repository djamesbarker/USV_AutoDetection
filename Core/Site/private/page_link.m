function link = page_link(site, page, target, varargin)

% PAGE_LINK link to site page
%
% link = page_link(site, page, target, varargin)

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
% get build root relative name for target
%--

name = strrep(page_file(site, target), [build_root(site), filesep], '');

url = [level_prefix(page.level), strrep(name, '\', '/')];

%--
% get attributes and options
%--

[attr, opt] = parse_tokens('a', varargin);

% NOTE: we may get a link text from the tokens, typically we use target name

if isfield(opt, 'label')
	label = opt.label;
else
	label = prepare_label(target.name);
end 

link = ['<a href="', url, '"', attr, '>', label, '</a>'];
