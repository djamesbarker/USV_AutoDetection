function gpl_xbat

% gpl_xbat - add GPL preamble to all XBAT M files
% -----------------------------------------------

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

dirs = scan_dir(xbat_root);

for k = 1:length(dirs)
	
	content = no_dot_dir(dirs{k}); content = strcat(dirs{k}, filesep, {content.name});
	
	for j = 1:length(content)
		
		if add_gpl(content{j}); 
			disp(['Added license to ', strrep(content{j}, xbat_root, '$XBAT_ROOT')]);
		end
		
	end
	
end
