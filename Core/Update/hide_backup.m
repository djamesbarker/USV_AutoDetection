function out = hide_backup(state)

% hide_backup - set hiding of backup directories in libraries
% -----------------------------------------------------------
%
% out = hide_backup(state)
%
% Input:
% ------
%  state - hiding state 'on' or 'off'
%
% Output:
% -------
%  out - directories affected by state change

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
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

%------------------------------------
% HANDLE INPUT
%------------------------------------

if (nargin < 1)
	state = 'on';
end

%------------------------------------
% SCAN LIBRARY DIRECTORIES
%------------------------------------

%--
% get libraries
%--

libs = get_unique_libraries; 

%--
% scan libraries updating backup directories
%--

for k = 1:length(libs)
	p{k} = scan_dir(libs(k).path,{@hide_update,state},1);
end

%--
% remove empty cells and concatenate directories
%--

out = cell(0);

for k = 1:length(libs)
	ix = cellfun('isempty',p{k}); p{k}(ix) = []; out = {out{:}, p{k}{:}};
end

% for k = 1:length(out)
% 	disp(out{k});
% end


%------------------------------------
% HIDE_UPDATE (SCAN CALLBACK)
%------------------------------------

function p = hide_update(p,state)

%--------------------------------
% Author: Harold Figueroa
%--------------------------------
% $Revision: 1180 $
% $Date: 2005-07-15 17:22:21 -0400 (Fri, 15 Jul 2005) $
%--------------------------------

%--
% get name of leaf directory
%--

[par,leaf] = path_parts(p);

if (~strcmpi(leaf,'__BACKUP'))
	p = ''; return;
end

%--
% update hidden state of backup directories
%--

switch (state)
	
	case ('on')
		fileattrib(p,'+h');
		
	case ('off')
		fileattrib(p,'-h');
		
end
