function G = get_profile_graph

%--
% get profile info
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

info = profile('info');

if (isempty(info))
	G = []; return;
end

%--
% extract graph from function table
%--

table = info.FunctionTable;

n = length(table);

G = sparse(n,n);

for k = 1:n
	
	% TODO: include number of calls information
	
	pix = cell2mat({table(k).Parents.Index}');
	
	if (~isempty(pix))
		G(k,pix) = 1;
	end
	
	cix = cell2mat({table(k).Children.Index}');
	
	if (~isempty(cix))
		G(cix,k) = 1;
	end
	
end


fig; spy(G);

p = colamd(G);
fig; spy(G(p,p));
