function out = collapse_cell(in)

%--
% check for cell input
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

if ~iscell(in)
	error('Input must be cell array');
end

if numel(in) == 0
    out = []; return;
end

%--
% remove empty cells and align content arrays
%--

for k = numel(in):-1:1
	
	if isempty(in{k})
		in(k) = []; continue;
	end

	% NOTE: make contents row vector to permit simple collapse
	
	in{k} = in{k}(:)';

end

%--
% collapse content arrays and output
%--

% NOTE: why are we using the transpose here?

out = [in{:}]';
