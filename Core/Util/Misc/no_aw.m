function no_aw

% TODO: add exclusion rule for top sponsored links

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

% TODO: make rules important

%--
% create exclusion rule
%--

% NOTE: there should be a more concise way of doing this

rule = '';

for k = 1:99
	rule = [rule, '#aw', int2str(k), ','];
end	

rule = [rule, '.a {display: none;}'];

%--
% save file
%--

[file,path] = uiputfile('no_aw.css','Save ...');

if (~ischar(file))
	return;
end

fid = fopen([path, file],'wt')

fprintf(fid,'%s',rule); 

fclose(fid);
