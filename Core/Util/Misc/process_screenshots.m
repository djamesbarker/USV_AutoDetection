function out = process_screenshots(screen)

% process_screenshots - process screenshots for web
% -------------------------------------------------
%
% out = process_screenshots(screen)
%
% Input:
% ------
%  screen - screen size vector
%
% Output:
% -------
%  out - image files created

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
% $Revision: 3951 $
% $Date: 2006-02-27 13:26:53 -0500 (Mon, 27 Feb 2006) $
%--------------------------------

%-------------------------------------------
% HANDLE INPUT
%-------------------------------------------

%--
% get screen size if needed
%--

if (nargin < 1)
	screen = get(0,'screensize');
end

%-------------------------------------------
% SETUP
%-------------------------------------------

%--
% set root directory
%--

root = create_dir([xbat_root, filesep, 'Screenshots']);

if (isempty(root))
	disp('Unable to create root.'); return;
end

%--
% get files to process
%--

content = what_ext(root,'png');

if (isempty(content.png))
	disp('No files to process.'); return;
end

%--
% get file info, remove file from list on failure
%--

for k = length(content.png):-1:1
	try
		info(k) = imfinfo([root, filesep, content.png{k}]);
	catch
		disp(['Failed to get file info for ''', content.png{k}, '''.']); content.png(k) = [];
	end
end

%-------------------------------------------
% PROCESS
%-------------------------------------------

out = cell(0);

for k = 1:length(content.png)
	
	disp([content.png{k}, ' (', int2str(info(k).Width), ' x ', int2str(info(k).Height), ')']);
	
	%--
	% process screen capture
	%--
	
	% NOTE: this is the processing for full screen captures
	
	if (is_screenshot(info(k),screen))
		this_out = process_screen(info,output); continue;
	end
	
	%--
	% process other captures
	%--
	
	% NOTE: this should apply to palettes and windows
	
	this_out = process_capture(info);
	
	%--
	% concatenate output
	%--
	
	out = [out{:}, this_out{:}];
	
end


%-------------------------------------------
% IS_SCREENSHOT
%-------------------------------------------

function value = is_screenshot(info,screen)

% is_screenshot - test that image is full screen capture
% ------------------------------------------------------
%
% value = is_screenshot(info,screen)
%
% Input:
% ------
%  info - image file info
%  screen - screen size vector
%
% Output:
% -------
%  value - result of test

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 3951 $
% $Date: 2006-02-27 13:26:53 -0500 (Mon, 27 Feb 2006) $
%--------------------------------

%--
% check that image dimensions match screen dimensions
%--

if ((info.Width == screen(3)) && (info.Height == screen(4)))
	value = 1;
else
	value = 0;
end


%-------------------------------------------
% PROCESS_SCREEN
%-------------------------------------------

function out = process_screen(info)

in = info.Filename

out = in;


%-------------------------------------------
% PROCESS_CAPTURE
%-------------------------------------------

function out = process_capture(info)

in = info.Filename

out = in;
