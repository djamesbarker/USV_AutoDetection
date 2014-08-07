function root = mingw_root(in)

% mingw_root - set and get root of mingw compiler
% -----------------------------------------------
%
% root = mingw_root(root)
%
% Input:
% ------
%  root - root to set
%
% Output:
% -------
%  root - value of mingw root

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
% handle set, get, and error
%--

switch nargin

	%--
	% get root
	%--

	case 0

		%--
		% get environment variable and try to set default if empty
		%--
		
		root = get_env('mingw_root');
		
		if isempty(root)
			
			% NOTE: this is the recommended installation path
			
			% TODO: consider checking for the default 'C:\' install path
			
			root = [xbat_root, filesep, 'Tools', filesep, 'MinGW'];
			
			if exist(root,'dir')
				set_env('mingw_root', root);
			else
				root = '';
			end
			
		end
		
		if isempty(root)
			
			root = 'C:\MinGW';
			
			if exist(root, 'dir') == 7
				set_env('mingw_root', root);
			else
				root = '';
			end
			
		end

	%--
	% set root
	%--

	% NOTE: this works like set verify

	case 1

		%--
		% check input 
		%--
		
		if ~ischar(in)
			error('Proposed path must be string.');
		end
		
		if ~exist(in, 'dir')
			error('Proposed path does not seem to exist.');
		end
		
		%--
		% set path
		%--
		
		root = in; set_env('mingw_root', root);
		
	%--
	% error
	%--

	otherwise, error('Improper number of input arguments.');

end
