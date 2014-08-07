function [out, status, result] = latex_image(in, out, opt)

% latex_image - create image from latex expression
% ------------------------------------------------
%
% [out, status, result] = latex_image(in, out, opt)
%
% Input:
% ------
%  str - latex expression
%  out - output file name
%  opt - image creation options
%
% Output:
% -------
%  out - image created, empty on failure
%  status - last helper status
%  result - last helper result

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

% TODO: factor cache file code as needed

% TODO: create images for a variety of 'dpi', add this to name

% TODO: add any options, such as font package to hash

% TODO: allow for additional inclusion of macros file

%-------------------
% SETUP
%-------------------

persistent ELEMENTS;

if isempty(ELEMENTS)
	
	%--
	% get tools
	%--
	
	ELEMENTS.texify = miktex_tools('texify.exe'); 
	
	ELEMENTS.dvipng = miktex_tools('dvipng.exe');
	
	%--
	% load fragments
	%--
	
	ELEMENTS.pre = file_readlines(which('pre.tex'));
	
	ELEMENTS.post = file_readlines(which('post.tex'));

end

% NOTE: reality-check, return if we don't have basic tool

if isempty(ELEMENTS.texify)
	out = ''; return;
end

%-------------------
% HANDLE INPUT
%-------------------

%--
% set and possibly output default options
%--

if nargin < 3
	
	opt.text = ''; opt.body = ''; opt.dpi = '';
	
	if ~nargin
		out = opt; return;
	end
	
end

%--
% check input and pack string in cell if needed
%--

if ~ischar(in) && ~iscellstr(in)
	error('Improper input.');
end

if ischar(in)
	lines = {in};
else
	lines = in;
end

%-------------------
% GET IMAGE
%-------------------

%--
% get cache directory
%--

cache = create_dir([fileparts(mfilename('fullpath')), filesep, 'Cache']);

if isempty(cache)
	error('Failed to create cache directory.');
end

%--
% create color options string
%--

if ~isempty(opt.text)
	fg = ['-fg ', latex_color(opt.text), ' '];
else
	fg = '';
end

if ~isempty(opt.body)
	bg = ['-bg ', latex_color(opt.body), ' '];
else 
	bg = '';
end

%--
% create cache name using expression and options hash
%--

% NOTE: consider string normalization

if ~ischar(lines)
	hash = md5([lines{:}, fg, bg]);
else
	hash = md5([lines, fg, bg]);
end

cached_name = [cache, filesep, hash];

%--
% check for cached image
%--

cached_out = [cached_name, '.png'];

if (nargin < 2) || isempty(out)
	out = cached_out;
end

% NOTE: if the file exists we copy cached file to output file if needed

if exist(cached_out, 'file')
	
	if ~strcmp(cached_out, out)
		copyfile(cached_out, out); 
	end
	
	return;
	
end

%--
% create latex input file
%--

cached_in = [cached_name, '.tex'];

in = get_fid(cached_in, 'wt');

file_process(in.fid, ELEMENTS.pre);

file_process(in.fid, strcat({'  '}, lines));

file_process(in.fid, ELEMENTS.post);

fclose(in.fid);

%--
% move macros file
%--

macros = [cache, filesep, 'macros.tex'];

if ~exist(macros, 'file') 
	copyfile(which('macros.tex'), macros);
end 

%--
% process file to get image
%--

pi = pwd; cd(cache);

str = ['"', ELEMENTS.texify.file, '" --clean --batch "', cached_in, '"']; 

[status, result] = system(str);

if status
	out = ''; return;
end

str = ['"', ELEMENTS.dvipng.file, '" -D 300 -T tight ', fg, bg, '"', cached_name, '.dvi"'];

% NOTE: we do this so we can handle missing font problems

for k = 1:4
	[status, result] = system(str);
end

if status
	out = ''; return;
end

% NOTE: this resolves renaming that 'dvipng' does so we can find cached image

file = dir([hash, '*.png']); copyfile(file.name, cached_out); delete(file.name);

cd(pi);

if ~strcmp(cached_out, out)
	copyfile(cached_out, out);
end

%--
% clean up
%--

try
	delete(cached_in); delete([cached_name, '.dvi']);
end



%----------------------
% LATEX_COLOR
%----------------------

function str = latex_color(color)

%--
% get color value string
%--

if ~ischar(color)
	
	str = num2str(color, 1);
	
else
	
	switch lower(color)
		
		case 'white', str = '1.0 1.0 1.0';
			
		case 'gray', str = '0.5 0.5 0.5';
			
		case 'black', str = '0.0 0.0 0.0';
			
		otherwise, error(['Unrecognized color name ''', color, '''.']);
			
	end 

end

%--
% prefix and wrap string
%--

str = ['"rgb ', str, '"'];
