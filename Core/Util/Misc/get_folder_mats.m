function mats = get_folder_mats(p,r,verb)

% get_folder_mats - get folder mat files
% --------------------------------------
%
% mats = get_folder_mats(p,r)
%
% Input:
% ------
%  p - directory to search
%  r - recursive searc flag
%
% Output:
% -------
%  mats - mat file descriptions

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
% $Revision: 928 $
% $Date: 2005-04-07 18:27:05 -0400 (Thu, 07 Apr 2005) $
%--------------------------------

% TODO: update this function to use 'scan_dir' maybe just use 'scan_ext'

%-------------------------------------------------
% SET PERSISTENT VARIABLES
%-------------------------------------------------

%--
% create list of folders to exclude in recursive search
%--

persistent EXCLUDE_PATH EXCLUDE_NAME;

if (isempty(EXCLUDE_PATH))
	
	EXCLUDE_PATH = { ...
		'C:\WINDOWS', ...
		'C:\Program Files', ...
		'C:\I386' ...
	};

	EXCLUDE_NAME = { ...
		'.svn', ...
		'private' ...
	};

end

%-------------------------------------------------
% HANDLE INPUT
%-------------------------------------------------

%--
% set verbosity
%--

% TODO: develop an environment level flag for this kind of work

if (nargin < 3)
	verb = 1; % NOTE: set to 1 for debug

end

%--
% set recursive flag
%--

if ((nargin < 2) || isempty(r))
	r = 1;
end

%--
% set starting directory
%--

if ((nargin < 1) || isempty(p))
	p = pwd;
end

%-------------------------------------------------
% RECURSIVE SEARCH
%-------------------------------------------------

if (r)
	
	%--
	% check for excluded directory
	%--
			
	if ( ...
		~isempty(find(strcmp(p,EXCLUDE_PATH),1)) || ...
		~isempty(find(strcmp(file_parent(p),EXCLUDE_NAME),1)) ...
	)		
		mats = []; return;
		
	end
	
	%--
	% add mats from current directory with non-recursive call
	%--

	d = p;

	mats = get_folder_mats(d,0,verb);
		
	%--
	% add mats from children directories recursively
	%--
		
	ch = what_ext(p);
	
	if (~isempty(ch.dir))
		
		%--
		% loop over children directories
		%--
		
		for k = 1:length(ch.dir)
			
			d = [p, filesep, ch.dir{k}];
			
			if (isempty(mats))
				mats = get_folder_mats(d,1,verb);
			else
				mats = [mats, get_folder_mats(d,1,verb)];
			end
			
		end
		
	end
		
	return;
	
end

%-------------------------------------------------
% GET FOLDER MATS
%-------------------------------------------------

%--
% get information about matlab files in directory
%--

w = what(p);

%--
% return quickly when there are no mat files
%--

if (isempty(w.mat))
	mats = []; return
end

%--
% pack output and display
%--

mats.dir = p;

mats.files = w.mat;

if (verb)
	
	str = w.path;
	
	disp(' ');
	str_line(length(str));
	disp(str);
	str_line(length(str));

end
	
%--
% get names of variables contained in files
%--
	
for k = 1:length(mats.files)
	
	mats.variables{k} = fieldnames(load([mats.dir, filesep, mats.files{k}]));

	if (verb)

		str = mats.files{k};

		disp(' ');
		disp(str);
		str_line(length(str));

		for j = 1:length(mats.variables{k})
			disp([int2str(j), '. ', mats.variables{k}{j}]);
		end

	end

end



