function out = scan_copy_dir(d1,d2)

% scan_copy_dir - scan and copy directory structure
% -------------------------------------------------
%
% out = scan_copy_dir(d1,d2)
%
% Input:
% ------
%  d1 - scan start directory (def: pwd)
%  d2 - output directory root
%
% Output:
% -------
%  out - copied directories

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
% $Revision: 498 $
% $Date: 2005-02-03 19:53:25 -0500 (Thu, 03 Feb 2005) $
%--------------------------------

%---------------------------------------
% HANDLE INPUT
%---------------------------------------

%--
% set default scan start directory
%--

if ((nargin < 1) || isempty(d1))
	d1 = pwd;
end

%---------------------------------------
% SCAN DIRECTORY
%---------------------------------------

% NOTE: scan the directory with 'what_ext' as a callback using input extensions

out = scan_dir(d1,[],[],0);

%---------------------------------------
% CREATE NEW PATHS AND DIRECTORIES
%---------------------------------------

%--
% replace root directory prefix
%--

out = strrep(out,d1,d2);

%--
% create directories using absolute path
%--

% NOTE: the order in which this list implies we create parents then children

for k = 1:length(out)
	
	% TODO: provide some indication of which directories were created

	if (~exist(out{k},'dir'))
		[out1,out2,out3] = mkdir(out{k});
	end
	
end

