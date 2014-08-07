function image_to_html(X,C,opt)

% image_to_html - display image in browser
% ----------------------------------------
%
%   f = image_to_html(X,C,opt)
% opt = image_to_html
%
% Input:
% ------
%  X - image
%  C - colormap
%  opt - various display options
%
% Output:
% -------
%  f - filename

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

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 132 $
% $Date: 2004-12-02 15:58:47 -0500 (Thu, 02 Dec 2004) $
%--------------------------------

%--
% get figure userdata
%--

data = get(h,'userdata');

%--
% move to last save directory
%--

pi = pwd;

if (~isempty(save_path))
	cd(save_path);
end

%--
% get path and set filename
%--

[f,p] = uiputfile( ...
	[fig_name(h) '.' data.image_menu.p.format], ...
	'Save Image As:');

%--
% move to destination directory and update save_path
%--

cd(p);

save_path(p);

%--
% get image data and colormap
%--

X = uint8(lut_range(image_crop));
map = get(h,'colormap');

%--
% write image file
%--

switch (data.image_menu.p.format)

	case ('jpg')

		switch (ndims(X))

			case (2)
				imwrite(X,map,f, ...
					'jpeg', ...
					'Quality',data.image_menu.p.jpeg_quality);

			case (3)
				imwrite(X,f, ...
					'jpeg', ...
					'Quality',data.image_menu.p.jpeg_quality);

		end

		if (strcmp(computer,'MAC2'))
			filetype(f,'JPEG','GKON');
		end

	case ('tif')

		imwrite(X,map,f, ...
			'tiff', ...
			'Compression',data.image_menu.p.compression);

		if (strcmp(computer,'MAC2'))
			filetype(f,'TIFF','GKON');
		end

end

%--
% create and view html
%--

if (data.image_menu.p.create_html)

	[m,n,d] = size(X);

	%--
	% set document colors
	%--
	
	S = ['<BODY' ...
		' BGCOLOR=' rgb_to_hex([0 0 0]) ...
		' ALINK=' rgb_to_hex([1 1 0]) ...
		' LINK=' rgb_to_hex([1 1 1]) ...
		' VLINK=' rgb_to_hex([1 1 1]) ...
		' TEXT=' rgb_to_hex([1 1 1]) ...
		' > \n'];

	%--
	% axes title
	%--
	
	if (~isempty(title_edit))
		S = [S '<P ALIGN=CENTER>' title_edit '</P>\n'];
	end

	%--
	% image at full size
	%--
	
	S = [S '<P ALIGN=CENTER> \n'];
	S = [S '<IMG SRC="' f ...
		'"' ' HEIGHT=' num2str(m) ' WIDTH=' num2str(n) '> \n'];
	S = [S '</P> \n'];

	%--
	% xlabel
	%--

	if (~isempty(xlabel_edit))
		S = [S '<P ALIGN=CENTER>' xlabel_edit '</P>\n'];
	end

	S = [S '</BODY>'];

	%--
	% create html file
	%--

	f = file_ext(f,'html');

	str_to_file(S,f);

	if (strcmp(computer,'MAC2'))
		filetype(f,'TEXT','MSIE');
	end

	%--
	% display image in browser
	%--

	if (data.image_menu.p.view_html)
		web(['file:///' strrep([p f],':','/')]);
	end

end

%--
% return to original directory
%--

cd(pi);
