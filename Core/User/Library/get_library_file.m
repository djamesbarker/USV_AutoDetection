function file = get_library_file(varargin)

% get_library_file - get library file name
% ----------------------------------------
%
% file = get_library_file(lib)
%
%      = get_library_file(root, name)
%
% Input:
% ------
%  lib - library
%  root - parent directory
%  name - library name
%
% Output:
% -------
%  file - library file

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
% compute depending on number of arguments
%--

switch nargin
	
	%--
	% build library file name from library
	%--
	
	case 1
		
		% NOTE: the library path should not include the trailing filesep, but it does

		lib = varargin{1};
		
		file = [lib.path, lib.name, '.mat'];
	
	%--
	% get library file from path and name information
	%--
		
	case (2)
		
		%--
		% handle input
		%--
		
		root = varargin{1}; name = varargin{2};
	
		if ~proper_filename(name)
			error('Input name is not proper filename.');
		end
		
		%--
		% build library filename
		%--
		
		file = [root, filesep, name, filesep, name, '.mat'];
		
		% NOTE: is this better than the line above?
		
% 		file = fullfile(root, name, [name, '.mat']);
			
	%--
	% error
	%--
	
	otherwise, error('Input must be library, or parent directory and name.');
		
end
