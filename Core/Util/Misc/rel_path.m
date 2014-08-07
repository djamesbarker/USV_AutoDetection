function out = rel_path(in, root, name)

% rel_path - display relative path using token
% --------------------------------------------
%
% out = rel_path(in, root, name)
%
% Input:
% ------
%  in - absolute path
%  root - root path
%  name - root token name
%
% Output:
% -------
%  out - relative path

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
	name = '$XBAT_ROOT';
end

if nargin < 2
	root = xbat_root;
end

if iscellstr(in)
	
	% NOTE: the number of output arguments is used by the function
	
	if ~nargout
		for k = 1:numel(in)
			rel_path(in{k}, root, name);
		end
	else
		for k = 1:numel(in)
			out{k} = rel_path(in{k}, root, name);
		end
	end
	
	return;

end

%--
% perform replacement, possibly display
%--

out = strrep(in, root, name);

if ~nargout
	disp(out);
end
