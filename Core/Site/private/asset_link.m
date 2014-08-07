function link = asset_link(data, type, name, varargin)

% ASSET_LINK link asset from page
%
% link = asset_link(data, type, name, varargin)

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
% get asset to link
%--

site = data.model.site;

asset = get_asset(site, type, name);
		
%--
% handle missing asset
%--

if isempty(asset)

	if strcmp(type, 'images')
		
		% NOTE: the image name is used by the template
		
		data.name = name;
		
		link = file_readlines( ...
			which('missing_image_warning.html'), {@process_callback, data} ...
		);
	
	else
		
		link = {}; disp(['WARNING: ', title_caps(type) , ' ''', name, ''' not found in ''', site, '''.']);
	
	end

end

%--
% copy asset to build asset directory
%--

root = [build_root(site), filesep, type];

file = [root, filesep, name];

% TODO: compare file modification dates

if ~exist(file, 'file') && ~isempty(create_dir(root))
	
	disp(['Copying ', type(1:end - 1), ' ''', name, ''' to build ...']);
	
	switch type
	
		% NOTE: processing the style file allows us to use variables
		
		case 'styles'
			file_process(file, asset, {@process_callback, data});
			
		otherwise
			copyfile(asset, file);
			
	end
	
end

%--
% create url and attribute strings for assets
%--

page = data.page;

url = [level_prefix(page.level), type, '/', name];

[attr, opt] = parse_tokens(type, varargin);

%--
% create link
%--

switch type
	
	case 'styles'
		
		link = ['<link rel="stylesheet" href="', url, '"', attr, '/>'];
		
	case 'scripts'
		
		link = ['<script type="text/javascript" src="', url, '"', attr, '></script>'];
	
	case 'images'
		
		if ~isfield(opt, 'thumb')
			
			%--
			% simple image display
			%--
			
			if ~isfield(opt, 'image')
				link = ['<img alt="', name,'" src="', url, '"', attr, '/>']; return;
			end
			
			%--
			% resized image display
			%--
			
			resized = get_resized_image(site, name, opt.image);
			
			url = [level_prefix(page.level), type, '/', resized];
			
			link = ['<img alt="', name,'" src=', url, '"', attr, '/>']; return;
			
		end
		
		%--
		% zoomable thumb image display
		%--
		
		thumb = get_resized_image(site, name, opt.thumb);
		
		if isfield(opt, 'image')
			name = get_resized_image(site, name, opt.image);
		end
		
		%--
		% create zoom page
		%--
		
		% NOTE: the zoom page is named according to the resized image
		
		out = [fileparts(page_file(site, page)), filesep, name, '-zoom.html'];
		
		file_process(out, which('image_zoom_page.html'));
		
% 		data.style = 'new.css';
		
		data.image = name;
		
		process_page_file(out, data);
		
		%--
		% link thumb image and then link to zoom page
		%--
		
		linki = asset_link(data, 'images', thumb);
		
		link = ['<a href="', name, '-zoom.html', '">', linki, '</a>'];
		
end
