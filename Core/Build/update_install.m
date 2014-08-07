function update_install(file)

%--
% setup
%--

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

persistent ROOT1 ROOT2;

if isempty(ROOT1)
	
	ROOT1 = xbat_root; 
	
	ROOT2 = create_dir(fullfile(xbat_root, 'MEX', [upper(computer), '_', mexext]));

	if isempty(ROOT2)
		error('Unable to create install root.');
	end
	
end

%--
% append file move commands to file
%--

for k = 1:length(file)
	
	output = strrep(file{k}, ROOT1, ROOT2); 
	
	if isempty(create_dir(fileparts(output)))
		continue;
	end
	
	try
		copyfile(file{k}, output);
	catch
		continue;
	end
	
end
