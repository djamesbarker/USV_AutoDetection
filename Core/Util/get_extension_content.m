function content = get_extension_content(source, ext, pat)

% get_extension_content - get directory contents by extension
% -----------------------------------------------------------
%
% content = get_extension_content(source, ext, pat)
%
% Input:
% ------
%  source - directory
%  ext - extensions to scan for
%  pat - further pattern to match for name
%
% Output:
% -------
%  content - directory contents

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
% handle input
%--

if nargin < 3 
	pat = '';
end

%--
% initialize content and record initial directory
%--

init = pwd; content = [];

try
	
	%--
	% move to source directory
	%--
	
	cd(source);
	
	%--
	% loop over extensions
	%--
	
	% NOTE: pack single extension into cell if needed
	
	if ischar(ext)
		ext = {ext};
	end 

	for k = 1:length(ext)

		%--
		% get extension content
		%--
		
		ext_content = dir(strrep([pat, ext{k}], '**', '*'));

		if isempty(ext_content)
			continue;
		end
		
		%--
		% append extension content
		%--
		
		if ~isempty(content)
			content = [content; ext_content];
		else
			content = ext_content;
		end

	end
	
catch
	
	content = [];

end

%--
% return to initial directory 
%--

cd(init);
